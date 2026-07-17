import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/database/gateway.drift.dart';
import '../../models/database/gateway_event.drift.dart';
import '../../models/database/inverter.dart';
import '../../models/database/inverter_member.drift.dart';
import '../../models/database/inverter_snapshot.drift.dart';
import '../../models/gateway_registration.dart';
import '../../models/invite_link.dart';
import '../../models/invite_preview.dart';

const supabaseDebugUrl = 'http://192.168.0.51:54321';
const supabaseDebugAnonKey = 'sb_publishable_ACJWlzQHlZjBrEguHvfOxg_3BJgxAaH';

final _logger = Logger('OnlineDatabaseService');

class OnlineDatabaseService {
  static Future<void> initialize() async {
    /// These should be set via `--dart-define` at build time, but we provide
    /// defaults for local development..
    const supabaseUrl = String.fromEnvironment(
      'SUPABASE_URL',
      defaultValue: supabaseDebugUrl,
    );
    const supabasePublishableKey = String.fromEnvironment(
      'SUPABASE_PUBLISHABLE_KEY',
      defaultValue: supabaseDebugAnonKey,
    );

    if (!kDebugMode) {
      if (supabaseUrl.isEmpty || supabaseUrl == supabaseDebugUrl) {
        throw Exception('SUPABASE_URL is not set');
      }
      if (supabasePublishableKey.isEmpty ||
          supabasePublishableKey == supabaseDebugAnonKey) {
        throw Exception('SUPABASE_PUBLISHABLE_KEY is not set');
      }
    }

    await Supabase.initialize(
      url: supabaseUrl,
      publishableKey: supabasePublishableKey,
    );
  }

  /// Lazy so subclasses (e.g. mocks) can construct without initializing Supabase.
  SupabaseClient get _db => Supabase.instance.client;

  /// Base Supabase URL for provisioning the gateway firmware.
  String get supabaseUrl => _db.rest.url.replaceFirst(RegExp(r'/rest/v1$'), '');

  // Returns the current user's inverters for the home screen.
  Future<List<Inverter>> inverters() async {
    try {
      final data = await Future(() async {
        return await _db
            .from('inverters')
            .select()
            .order('created_at', ascending: false);
      }).timeout(const Duration(seconds: 30));

      return data.map((item) => Inverter.fromJson(item)).toList();
    } on PostgrestException catch (e) {
      throw DatabaseException(e.message, error: e.details);
    } on TimeoutException catch (e) {
      throw DatabaseException('Timed out while loading systems', error: e);
    } catch (e) {
      throw DatabaseException('An unexpected error occurred', error: e);
    }
  }

  // Returns one inverter row for dashboard/settings screens.
  Future<Inverter?> getInverterById(String inverterId) async {
    try {
      final data = await _db
          .from('inverters')
          .select()
          .eq('id', inverterId)
          .maybeSingle();

      return data == null ? null : Inverter.fromJson(data);
    } on PostgrestException catch (e) {
      throw DatabaseException(e.message, error: e.details);
    } catch (e) {
      throw DatabaseException('An unexpected error occurred', error: e);
    }
  }

  // Returns chart data from inverter_snapshots for the selected time range.
  Future<List<InverterSnapshot>> snapshots({
    required String inverterId,
    DateTime? start,
    DateTime? end,
  }) async {
    try {
      var query = _db
          .from('inverter_snapshots')
          .select()
          .eq('inverter_id', inverterId);
      if (start != null) {
        query = query.gte('recorded_at', start.toIso8601String());
      }

      if (end != null) {
        query = query.lte('recorded_at', end.toIso8601String());
      }
      final data = await query.order('recorded_at', ascending: true);

      return data.map((item) => InverterSnapshot.fromJson(item)).toList();
    } on PostgrestException catch (e) {
      throw DatabaseException(e.message, error: e.details);
    } catch (e) {
      throw DatabaseException('An unexpected error occurred', error: e);
    }
  }

  RealtimeChannel inverterChanges({
    required void Function(Inverter user) onCreate,
    required void Function(Inverter user) onUpdate,
    required void Function(String id) onDelete,
  }) {
    return _db
        .channel('inverters')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'inverters',
          callback: (payload) {
            switch (payload.eventType) {
              case .insert:
                onCreate(Inverter.fromJson(payload.newRecord));
              case .update:
                onUpdate(Inverter.fromJson(payload.newRecord));
              case .delete:
                onDelete(payload.oldRecord['id']);
              default:
                break;
            }
          },
        )
        .subscribe((status, object) {
          _logger.info('Inverter changes subscription status: $status');
          if (status == RealtimeSubscribeStatus.channelError) {
            _logger.warning(object);
          }
        });
  }

  RealtimeChannel snapshotChanges({
    required String inverterId,
    DateTime? start,
    required void Function(InverterSnapshot user) onCreate,
    // required void Function(String id) onDelete,
  }) {
    return _db
        .channel('snapshots:$inverterId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'inverter_snapshots',
          filter: PostgresChangeFilter(
            type: .eq,
            column: 'inverter_id',
            value: inverterId,
          ),
          callback: (payload) {
            switch (payload.eventType) {
              case .insert:
                onCreate(InverterSnapshot.fromJson(payload.newRecord));
              // case .delete:
              //   onDelete(payload.oldRecord['id']);
              default:
                break;
            }
          },
        )
        .subscribe((status, object) {
          _logger.info('Snapshot changes subscription status: $status');
          if (status == RealtimeSubscribeStatus.channelError) {
            _logger.warning(object);
          }
        });
  }

  // Returns all the gateways for the authenticated user.
  Future<List<Gateway>> gateways(String inverterId) async {
    try {
      final data = await _db.rpc('get_gateways_safe');
      return data.map((item) => Gateway.fromJson(item)).toList();
    } on PostgrestException catch (e) {
      throw DatabaseException(e.message, error: e.details);
    } catch (e) {
      throw DatabaseException('An unexpected error occurred', error: e);
    }
  }

  // Returns owner-only operational events for the inverter event log screen.
  Future<List<GatewayEvent>> gatewayEvents(String inverterId) async {
    try {
      final data = await _db
          .from('gateway_events')
          .select()
          .eq('inverter_id', inverterId)
          .order('recorded_at', ascending: false);
      return data.map((item) => GatewayEvent.fromJson(item)).toList();
    } on PostgrestException catch (e) {
      throw DatabaseException(e.message, error: e.details);
    } catch (e) {
      throw DatabaseException('An unexpected error occurred', error: e);
    }
  }

  // Returns the owner-only member list for managing viewers.
  Future<List<InverterMember>> inverterMembers(String inverterId) async {
    try {
      final data = await _db
          .from('inverter_members')
          .select()
          .eq('inverter_id', inverterId)
          .order('created_at', ascending: false);
      return data.map((item) => InverterMember.fromJson(item)).toList();
    } on PostgrestException catch (e) {
      throw DatabaseException(e.message, error: e.details);
    } catch (e) {
      throw DatabaseException('An unexpected error occurred', error: e);
    }
  }

  // Removes a viewer from an inverter.
  Future<void> removeViewer({
    required String inverterId,
    required String userId,
  }) async {
    try {
      await _db
          .from('inverter_members')
          .delete()
          .eq('inverter_id', inverterId)
          .eq('user_id', userId);
    } on PostgrestException catch (e) {
      throw DatabaseException(e.message, error: e.details);
    } catch (e) {
      throw DatabaseException('An unexpected error occurred', error: e);
    }
  }

  // Invite link flow.

  // Creates a single-use viewer invite link via the create_invite_link edge function.
  Future<InviteLink> createInviteLink(String inverterId) async {
    try {
      final res = await _db.functions.invoke(
        'create_invite_link',
        body: {'inverter_id': inverterId},
      );

      assert(
        res.data is Map<String, dynamic>,
        'Expected a Map<String, dynamic> response',
      );

      if (res.status >= 400) {
        throw DatabaseException(res.data['message'], error: res.data['error']);
      }

      return InviteLink.fromJson(res.data);
    } catch (e) {
      throw DatabaseException('An unexpected error occurred', error: e);
    }
  }

  // Loads public invite metadata for the invite landing page.

  Future<InvitePreview> getInvitePreview(String token) async {
    try {
      final res = await _db.functions.invoke(
        'get_invite_preview',
        body: {'token': token},
      );

      assert(
        res.data is Map<String, dynamic>,
        'Expected a Map<String, dynamic> response',
      );

      if (res.status >= 400) {
        throw DatabaseException(res.data['message'], error: res.data['error']);
      }

      return InvitePreview.fromJson(res.data);
    } catch (e) {
      throw DatabaseException('An unexpected error occurred', error: e);
    }
  }

  // Accepts an invite after auth and grants viewer access.
  Future<void> acceptInvite(String token) async {
    try {
      final res = await _db.functions.invoke(
        'accept_invite',
        body: {'invite_token': token},
      );

      assert(
        res.data is Map<String, dynamic>,
        'Expected a Map<String, dynamic> response',
      );

      if (res.status >= 400) {
        throw DatabaseException(res.data['message'], error: res.data['error']);
      }
    } catch (e) {
      throw DatabaseException('An unexpected error occurred', error: e);
    }
  }

  // Provisioning and gateway replacement.

  // Calls register_gateway for new setup or replace-gateway flows.
  Future<GatewayRegistrationResponse> registerGateway(
    GatewayRegistrationRequest request,
  ) async {
    try {
      final res = await _db.functions.invoke(
        'register_gateway',
        body: request.toJson(),
      );

      assert(
        res.data is Map<String, dynamic>,
        'Expected a Map<String, dynamic> response',
      );

      if (res.status >= 400) {
        throw DatabaseException(res.data['message'], error: res.data['error']);
      }

      return GatewayRegistrationResponse.fromJson(res.data);
    } catch (e) {
      throw DatabaseException('An unexpected error occurred', error: e);
    }
  }
}

class DatabaseException implements Exception {
  final String message;
  final Object? error;

  DatabaseException(this.message, {this.error});

  @override
  String toString() => 'DatabaseException: $message $error';
}
