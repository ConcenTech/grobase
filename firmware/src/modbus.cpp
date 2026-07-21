
// Modbus helpers: request framing, CRC, chunked reads and
// reading the application register groups. This file contains
// the implementation extracted from the prototype `main.cpp`.

#include "modbus.h"
#include "debug_print.h"

#if MOCK_INVERTER
#include "modbus_mock.h"
#endif

// Configuration local to Modbus module.
static const uint8_t MODBUS_SLAVE_ID = 1;
static const uint32_t MODBUS_BAUD = 9600;
static const uint32_t DEBUG_BAUD = 115200;

static const int PIN_RX2 = 16;  // ESP32 RX (to MAX3232 TX)
static const int PIN_TX2 = 17;  // ESP32 TX (to MAX3232 RX)

static const uint32_t MODBUS_TIMEOUT_MS = 1500;
static const uint8_t READ_FUNC = 0x04;
static const uint16_t MAX_CHUNK_REGS = 40;

static const bool DEBUG_HEX = true;

HardwareSerial InverterSerial(2);

// Delegate CRC and parsing to modbus_core so those functions can be
// unit-tested on the host.
#include "modbus_core.h"

void printHexBytes(const uint8_t *buf, size_t len) {
	for (size_t i = 0; i < len; i++) {
		if (buf[i] < 16) DEBUG_PRINT('0');
		DEBUG_PRINT(buf[i], HEX);
		if (i + 1 < len) DEBUG_PRINT(' ');
	}
	DEBUG_PRINTLN();
}

void modbusInit() {
#if MOCK_INVERTER
	DEBUG_PRINTF("MOCK_INVERTER enabled: skipping UART, SN=%s\n", MODBUS_MOCK_SERIAL_NUMBER);
	return;
#endif
	InverterSerial.begin(MODBUS_BAUD, SERIAL_8N1, PIN_RX2, PIN_TX2);
	if (DEBUG_HEX) {
		DEBUG_PRINTF("Modbus UART initialized RX=%d TX=%d @ %lu\n", PIN_RX2, PIN_TX2, MODBUS_BAUD);
	}
}

bool readRegisters04(uint8_t slave, uint16_t startReg, uint16_t count, uint16_t *outRegs) {
#if MOCK_INVERTER
	(void)slave;
	(void)startReg;
	(void)count;
	(void)outRegs;
	return false;
#endif
	uint8_t req[8];
	req[0] = slave;
	req[1] = READ_FUNC;
	req[2] = (uint8_t)(startReg >> 8);
	req[3] = (uint8_t)(startReg & 0xFF);
	req[4] = (uint8_t)(count >> 8);
	req[5] = (uint8_t)(count & 0xFF);

	uint16_t crc = crc16_modbus(req, 6);
	req[6] = (uint8_t)(crc & 0xFF);
	req[7] = (uint8_t)((crc >> 8) & 0xFF);

	while (InverterSerial.available()) {
		InverterSerial.read();
	}

	if (DEBUG_HEX) {
		DEBUG_PRINTF("TX f=0x%02X start=%u count=%u frame=", READ_FUNC, startReg, count);
		printHexBytes(req, sizeof(req));
	}

	InverterSerial.write(req, sizeof(req));
	InverterSerial.flush();

	const uint8_t expectedByteCount = count * 2;
	const size_t expectedLen = 3 + expectedByteCount + 2;

	uint8_t resp[3 + 2 * MAX_CHUNK_REGS + 2];
	if (expectedLen > sizeof(resp)) return false;

	size_t got = 0;
	uint32_t t0 = millis();
	while ((millis() - t0) < MODBUS_TIMEOUT_MS && got < expectedLen) {
		if (InverterSerial.available()) {
			resp[got++] = (uint8_t)InverterSerial.read();
		} else {
			delay(1);
		}
	}

	if (got != expectedLen) {
		DEBUG_PRINTF("RX short/timeout start=%u count=%u got=%u expected=%u\n",
									startReg, count, (unsigned)got, (unsigned)expectedLen);
		return false;
	}

	if (DEBUG_HEX) {
		DEBUG_PRINT("RX full=");
		printHexBytes(resp, expectedLen);
	}

	if (resp[0] != slave) return false;
	if (resp[1] == (READ_FUNC | 0x80)) {
		DEBUG_PRINTF("Modbus exception start=%u code=0x%02X\n", startReg, resp[2]);
		return false;
	}
	if (resp[1] != READ_FUNC) return false;
	if (resp[2] != expectedByteCount) return false;

	// Validate CRC using modbus_core
	uint16_t rxCrc = ((uint16_t)resp[expectedLen - 1] << 8) | resp[expectedLen - 2];
	uint16_t calcCrc = crc16_modbus(resp, expectedLen - 2);
	if (rxCrc != calcCrc) return false;

	for (uint16_t i = 0; i < count; i++) {
		uint8_t hi = resp[3 + (i * 2)];
		uint8_t lo = resp[3 + (i * 2) + 1];
		outRegs[i] = ((uint16_t)hi << 8) | lo;
	}

	return true;
}

// Similar to readRegisters04 but for Function 0x03 (holding registers)
bool readRegisters03(uint8_t slave, uint16_t startReg, uint16_t count, uint16_t *outRegs) {
#if MOCK_INVERTER
	(void)slave;
	if (startReg == 23 && count == 5) {
		modbusMockFillSerialNumberRegisters(outRegs);
		return true;
	}
	return false;
#endif
	uint8_t req[8];
	req[0] = slave;
	req[1] = 0x03; // FC 03
	req[2] = (uint8_t)(startReg >> 8);
	req[3] = (uint8_t)(startReg & 0xFF);
	req[4] = (uint8_t)(count >> 8);
	req[5] = (uint8_t)(count & 0xFF);

	uint16_t crc = crc16_modbus(req, 6);
	req[6] = (uint8_t)(crc & 0xFF);
	req[7] = (uint8_t)((crc >> 8) & 0xFF);

	while (InverterSerial.available()) {
		InverterSerial.read();
	}

	if (DEBUG_HEX) {
		DEBUG_PRINTF("TX f=0x%02X start=%u count=%u frame=", 0x03, startReg, count);
		printHexBytes(req, sizeof(req));
	}

	InverterSerial.write(req, sizeof(req));
	InverterSerial.flush();

	const uint8_t expectedByteCount = count * 2;
	const size_t expectedLen = 3 + expectedByteCount + 2;

	uint8_t resp[3 + 2 * MAX_CHUNK_REGS + 2];
	if (expectedLen > sizeof(resp)) return false;

	size_t got = 0;
	uint32_t t0 = millis();
	while ((millis() - t0) < MODBUS_TIMEOUT_MS && got < expectedLen) {
		if (InverterSerial.available()) {
			resp[got++] = (uint8_t)InverterSerial.read();
		} else {
			delay(1);
		}
	}

	if (got != expectedLen) {
		DEBUG_PRINTF("RX short/timeout start=%u count=%u got=%u expected=%u\n",
									startReg, count, (unsigned)got, (unsigned)expectedLen);
		return false;
	}

	if (DEBUG_HEX) {
		DEBUG_PRINT("RX full=");
		printHexBytes(resp, expectedLen);
	}

	if (resp[0] != slave) return false;
	if (resp[1] == (0x03 | 0x80)) {
		DEBUG_PRINTF("Modbus exception start=%u code=0x%02X\n", startReg, resp[2]);
		return false;
	}
	if (resp[1] != 0x03) return false;
	if (resp[2] != expectedByteCount) return false;

	uint16_t rxCrc = ((uint16_t)resp[expectedLen - 1] << 8) | resp[expectedLen - 2];
	uint16_t calcCrc = crc16_modbus(resp, expectedLen - 2);
	if (rxCrc != calcCrc) return false;

	for (uint16_t i = 0; i < count; i++) {
		uint8_t hi = resp[3 + (i * 2)];
		uint8_t lo = resp[3 + (i * 2) + 1];
		outRegs[i] = ((uint16_t)hi << 8) | lo;
	}

	return true;
}

bool readRange04Chunked(uint16_t pduStartReg, uint16_t count, uint16_t *outRegs) {
	uint16_t done = 0;
	while (done < count) {
		uint16_t remaining = count - done;
		uint16_t chunk = (remaining > MAX_CHUNK_REGS) ? MAX_CHUNK_REGS : remaining;
		if (!readRegisters04(MODBUS_SLAVE_ID, pduStartReg + done, chunk, outRegs + done)) {
			return false;
		}
		done += chunk;
	}
	return true;
}

static const uint16_t R1009_START = 1009;
static const uint16_t R1009_COUNT = 51;
static const uint16_t R1086_START = 1086;
static const uint16_t R1086_COUNT = 3;
static const uint16_t R1124_START = 1124;
static const uint16_t R1124_COUNT = 27;
static const uint16_t R2035_START = 2035;
static const uint16_t R2035_COUNT = 20;
static const uint16_t R2097_START = 2097;
static const uint16_t R2097_COUNT = 7; // 2097 BatVolt_DSP … 2102–2103 ExtraACPower
static const uint16_t R2112_START = 2112;
static const uint16_t R2112_COUNT = 6;

bool readAppRegisters(uint16_t *r1009,
											uint16_t *r1086,
											uint16_t *r1124,
											uint16_t *r2035,
											uint16_t *r2097,
											uint16_t *r2112) {
#if MOCK_INVERTER
	modbusMockFillAppRegisters(r1009, r1086, r1124, r2035, r2097, r2112);
	return true;
#endif
  if (!readRange04Chunked(R1009_START, R1009_COUNT, r1009)) return false;
	if (!readRange04Chunked(R1086_START, R1086_COUNT, r1086)) return false;
	if (!readRange04Chunked(R1124_START, R1124_COUNT, r1124)) return false;
	if (!readRange04Chunked(R2035_START, R2035_COUNT, r2035)) return false;
	if (!readRange04Chunked(R2097_START, R2097_COUNT, r2097)) return false;
	if (!readRange04Chunked(R2112_START, R2112_COUNT, r2112)) return false;
	return true;
}

#if MODBUS_DEBUG
// SPA FC04 ranges from Growatt protocol (Storage power / generation / SPA).
static const uint16_t DBG_R1000_START = 1000;
static const uint16_t DBG_R1000_COUNT = 44;  // 1000–1043
static const uint16_t DBG_R1044_START = 1044;
static const uint16_t DBG_R1044_COUNT = 23;  // 1044–1066
static const uint16_t DBG_R1125_START = 1125;
static const uint16_t DBG_R1125_COUNT = 125; // 1125–1249
static const uint16_t DBG_R2000_START = 2000;
static const uint16_t DBG_R2000_COUNT = 125; // 2000–2124

static void appendRegsJsonArray(String &j, const uint16_t *regs, uint16_t count) {
	j += '[';
	for (uint16_t i = 0; i < count; i++) {
		if (i) j += ',';
		j += String(regs[i]);
	}
	j += ']';
}

static bool appendDebugRange(String &j,
														 bool &first,
														 uint16_t start,
														 uint16_t count,
														 uint16_t *buf,
														 String &err) {
	if (!readRange04Chunked(start, count, buf)) {
		if (err.length() == 0) {
			err = "read_failed_start_" + String(start);
		}
		return false;
	}
	if (!first) j += ',';
	first = false;
	j += '"';
	j += String(start);
	j += "\":";
	appendRegsJsonArray(j, buf, count);
	return true;
}

bool readModbusDebugDumpJson(String &outJson) {
	static uint16_t r1000[DBG_R1000_COUNT];
	static uint16_t r1044[DBG_R1044_COUNT];
	static uint16_t r1125[DBG_R1125_COUNT];
	static uint16_t r2000[DBG_R2000_COUNT];

	outJson = "";
	outJson.reserve(4096);
	outJson += "{\"modbus_fc04\":{";

	bool first = true;
	String err;

#if MOCK_INVERTER
	for (uint16_t i = 0; i < DBG_R1000_COUNT; i++) r1000[i] = 0;
	for (uint16_t i = 0; i < DBG_R1044_COUNT; i++) r1044[i] = 0;
	for (uint16_t i = 0; i < DBG_R1125_COUNT; i++) r1125[i] = 0;
	for (uint16_t i = 0; i < DBG_R2000_COUNT; i++) r2000[i] = 0;
	outJson += "\"1000\":";
	appendRegsJsonArray(outJson, r1000, DBG_R1000_COUNT);
	outJson += ",\"1044\":";
	appendRegsJsonArray(outJson, r1044, DBG_R1044_COUNT);
	outJson += ",\"1125\":";
	appendRegsJsonArray(outJson, r1125, DBG_R1125_COUNT);
	outJson += ",\"2000\":";
	appendRegsJsonArray(outJson, r2000, DBG_R2000_COUNT);
	(void)first;
#else
	(void)appendDebugRange(outJson, first, DBG_R1000_START, DBG_R1000_COUNT, r1000, err);
	(void)appendDebugRange(outJson, first, DBG_R1044_START, DBG_R1044_COUNT, r1044, err);
	(void)appendDebugRange(outJson, first, DBG_R1125_START, DBG_R1125_COUNT, r1125, err);
	(void)appendDebugRange(outJson, first, DBG_R2000_START, DBG_R2000_COUNT, r2000, err);
#endif

	outJson += '}';
	if (err.length() > 0) {
		outJson += ",\"error\":\"";
		outJson += err;
		outJson += '"';
	}
	outJson += '}';
	return true;
}
#endif

