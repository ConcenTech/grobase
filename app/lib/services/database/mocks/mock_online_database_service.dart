import 'package:logging/logging.dart' show Level;
// ignore: implementation_imports, depend_on_referenced_packages
import 'package:realtime_client/src/message.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../models/database/gateway.drift.dart';
import '../../../models/database/gateway_event.drift.dart';
import '../../../models/database/inverter.drift.dart';
import '../../../models/database/inverter_member.drift.dart';
import '../../../models/database/inverter_snapshot.drift.dart';
import '../../../models/gateway_registration.dart';
import '../../../models/invite_link.dart';
import '../../../models/invite_preview.dart';
import '../online_database_service.dart';
import 'offline_mock_data.dart';

/// In-memory [OnlineDatabaseService] for offline / screenshot development.
///
/// Override [databaseProvider] with this when [OFFLINE_MODE] is enabled.
class MockOnlineDatabaseService extends OnlineDatabaseService {
  MockOnlineDatabaseService({OfflineMockDataset? dataset})
    : _dataset = dataset ?? OfflineMockData.build();

  final OfflineMockDataset _dataset;

  @override
  String get supabaseUrl => supabaseDebugUrl;

  @override
  Future<List<Inverter>> inverters() async =>
      List<Inverter>.unmodifiable(_dataset.inverters);

  @override
  Future<Inverter?> getInverterById(String inverterId) async {
    for (final inverter in _dataset.inverters) {
      if (inverter.id == inverterId) {
        return inverter;
      }
    }
    return null;
  }

  @override
  Future<List<InverterSnapshot>> snapshots({
    required String inverterId,
    DateTime? start,
    DateTime? end,
  }) async {
    final forInverter = _dataset.snapshots
        .where((s) => s.inverterId == inverterId)
        .toList();

    var filtered = forInverter.where((s) {
      if (start != null && s.recordedAt.isBefore(start)) {
        return false;
      }
      if (end != null && s.recordedAt.isAfter(end)) {
        return false;
      }
      return true;
    }).toList();

    // Sync asks for "today" onwards; still return the latest point for stale
    // systems (e.g. Workshop) so offline screenshots stay useful.
    if (filtered.isEmpty && forInverter.isNotEmpty) {
      forInverter.sort((a, b) => a.recordedAt.compareTo(b.recordedAt));
      filtered = [forInverter.last];
    }

    filtered.sort((a, b) => a.recordedAt.compareTo(b.recordedAt));
    return filtered;
  }

  @override
  RealtimeChannel inverterChanges({
    required void Function(Inverter user) onCreate,
    required void Function(Inverter user) onUpdate,
    required void Function(String id) onDelete,
  }) {
    return RealtimeChannel('topic', MockRealtimeClient());
  }

  @override
  Future<List<Gateway>> gateways(String inverterId) async => const [];

  @override
  Future<List<GatewayEvent>> gatewayEvents(String inverterId) async => const [];

  @override
  Future<List<InverterMember>> inverterMembers(String inverterId) async =>
      const [];

  @override
  Future<void> removeViewer({
    required String inverterId,
    required String userId,
  }) async {}

  @override
  Future<InviteLink> createInviteLink(String inverterId) async {
    throw UnsupportedError('Invites are unavailable in offline mode');
  }

  @override
  Future<InvitePreview> getInvitePreview(String token) async {
    throw UnsupportedError('Invites are unavailable in offline mode');
  }

  @override
  Future<void> acceptInvite(String token) async {
    throw UnsupportedError('Invites are unavailable in offline mode');
  }

  @override
  Future<GatewayRegistrationResponse> registerGateway(
    GatewayRegistrationRequest request,
  ) async {
    throw UnsupportedError('Provisioning is unavailable in offline mode');
  }
}

class MockRealtimeClient extends RealtimeClient {
  MockRealtimeClient() : super('http://localhost:54321');

  @override
  Future<void> connect() async {
    return;
  }

  @override
  Future<void> disconnect({int? code, String? reason}) async {
    return;
  }

  @override
  List<RealtimeChannel> getChannels() {
    return [];
  }

  @override
  Future<String> removeChannel(RealtimeChannel channel) async {
    return 'ok';
  }

  @override
  Future<List<String>> removeAllChannels() async {
    return [];
  }

  @override
  void log([
    String? kind,
    String? message,
    dynamic data,
    Level level = Level.FINEST,
  ]) {
    return;
  }

  @override
  void onOpen(void Function() callback) {
    return;
  }

  @override
  void onClose(void Function(dynamic) callback) {
    return;
  }

  @override
  void onError(void Function(dynamic) callback) {
    return;
  }

  @override
  void onMessage(void Function(dynamic) callback) {
    return;
  }

  @override
  String get connectionState => 'open';

  @override
  bool get isConnected => true;

  @override
  void remove(RealtimeChannel channel) {
    return;
  }

  @override
  RealtimeChannel channel(
    String topic, [
    RealtimeChannelConfig params = const RealtimeChannelConfig(),
  ]) {
    return RealtimeChannel(topic, this, params: params);
  }

  @override
  String? push(Message message) {
    return null;
  }

  @override
  void onConnMessage(Object rawMessage) {
    return;
  }

  @override
  String get endPointURL {
    return 'http://localhost:54321';
  }

  @override
  String makeRef() {
    return '1';
  }

  @override
  int get ref => 1;

  @override
  set ref(int value) {
    return;
  }

  @override
  Future<void> setAuth(String? token) async {
    return;
  }

  @override
  Future<void> sendHeartbeat() async {
    return;
  }
}
