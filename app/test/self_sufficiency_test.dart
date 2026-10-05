import 'package:flutter_test/flutter_test.dart';
import 'package:grobase/screens/history/self_sufficiency_card.dart';

void main() {
  test('grid charging is not counted as powering the house', () {
    // Solar 1.1 can only cover 1.1 of the 2.6 charge. The other 1.5 came
    // from the grid, so house import is 2.7 of the 3.2 consumed.
    expect(
      selfSufficiencyPercent(
        solarEnergyToday: 1.1,
        gridImportEnergyToday: 4.2,
        dischargeEnergyToday: 0.5,
        gridExportEnergyToday: 0,
        chargeEnergyToday: 2.6,
      ),
      closeTo(15.625, 0.001),
    );
  });

  test('own power against a much larger import is 10%', () {
    expect(
      selfSufficiencyPercent(
        solarEnergyToday: 5,
        gridImportEnergyToday: 90,
        dischargeEnergyToday: 5,
        gridExportEnergyToday: 0,
        chargeEnergyToday: 0,
      ),
      10,
    );
  });

  test('equal own power and import is 50%', () {
    expect(
      selfSufficiencyPercent(
        solarEnergyToday: 2.5,
        gridImportEnergyToday: 5,
        dischargeEnergyToday: 2.5,
        gridExportEnergyToday: 0,
        chargeEnergyToday: 0,
      ),
      50,
    );
  });

  test('solar-covered charge leaves import in the ratio', () {
    // Consumption is 9 kWh. The 3 kWh charge came from solar, so all 3 kWh
    // imported powered the house.
    expect(
      selfSufficiencyPercent(
        solarEnergyToday: 10,
        gridImportEnergyToday: 3,
        dischargeEnergyToday: 2,
        gridExportEnergyToday: 3,
        chargeEnergyToday: 3,
      ),
      closeTo(66.667, 0.001),
    );
  });

  test('no household consumption is zero', () {
    expect(
      selfSufficiencyPercent(
        solarEnergyToday: 1,
        gridImportEnergyToday: 1,
        dischargeEnergyToday: 0,
        gridExportEnergyToday: 0,
        chargeEnergyToday: 2,
      ),
      0,
    );
  });
}
