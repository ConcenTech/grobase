import 'package:logging/logging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/env/env.dart';
import '../../models/database/gateway.drift.dart';
import '../../models/database/gateway_event.drift.dart';
import '../../models/database/inverter.dart';
import '../../models/database/inverter_member.drift.dart';
import '../../models/database/inverter_snapshot.drift.dart';
import '../../models/gateway_registration.dart';
import '../../models/invite_link.dart';
import '../../models/invite_preview.dart';

final _logger = Logger('OnlineDatabaseService');

class OnlineDatabaseService {
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: Env.supabaseUrl,
      publishableKey: Env.supabasePublishableKey,
    );
  }

  /// Lazy so subclasses (e.g. mocks) can construct without initializing Supabase.
  SupabaseClient get _db => Supabase.instance.client;

  /// Base Supabase URL for provisioning the gateway firmware.
  String get supabaseUrl => _db.rest.url.replaceFirst(RegExp(r'/rest/v1$'), '');

  Future<void> _ensureValidSession() async {
    final session = _db.auth.currentSession;
    if (session == null) {
      // Unable to resolve session, likely not authenticated.
      throw DatabaseException('Not authenticated');
    }
    if (session.isExpired) {
      _logger.info('Session expired, refreshing');
      await _db.auth.refreshSession();

      final newSessionIsValid = !(_db.auth.currentSession?.isExpired ?? true);
      if (!newSessionIsValid) {
        _logger.severe('Failed to refresh session');
        throw DatabaseException('Failed to refresh session');
      } else {
        _logger.info('Session refreshed');
      }
    }
  }

  // Returns the current user's inverters for the home screen.
  Future<List<Inverter>> inverters() async {
    try {
      await _ensureValidSession();
      final data = await _db
          .from('inverters')
          .select()
          .order('created_at', ascending: false);

      return data.map((item) => Inverter.fromJson(item)).toList();
    } on PostgrestException catch (e) {
      throw DatabaseException(e.message, error: e);
    } catch (e) {
      throw DatabaseException('An unexpected error occurred', error: e);
    }
  }

  // Returns one inverter row for dashboard/settings screens.
  Future<Inverter?> getInverterById(String inverterId) async {
    try {
      await _ensureValidSession();
      final data = await _db
          .from('inverters')
          .select()
          .eq('id', inverterId)
          .maybeSingle();

      return data == null ? null : Inverter.fromJson(data);
    } on PostgrestException catch (e) {
      throw DatabaseException(e.message, error: e);
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
      await _ensureValidSession();
      var query = _db
          .from('inverter_snapshots')
          .select()
          .eq('inverter_id', inverterId);
      if (start != null) {
        query = query.gt('recorded_at', start.toUtc().toIso8601String());
      }

      if (end != null) {
        query = query.lte('recorded_at', end.toUtc().toIso8601String());
      }
      final data = await query.order('recorded_at', ascending: true);

      return data.map((item) => InverterSnapshot.fromJson(item)).toList();
    } on PostgrestException catch (e) {
      throw DatabaseException(e.message, error: e);
    } catch (e) {
      throw DatabaseException('An unexpected error occurred', error: e);
    }
  }

  Future<RealtimeChannel> inverterChanges({
    required void Function(Inverter user) onCreate,
    required void Function(Inverter user) onUpdate,
    required void Function(String id) onDelete,
  }) async {
    await _ensureValidSession();
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

  Future<RealtimeChannel> snapshotChanges({
    required String inverterId,
    DateTime? start,
    required void Function(InverterSnapshot user) onCreate,
    // required void Function(String id) onDelete,
  }) async {
    await _ensureValidSession();

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
      await _ensureValidSession();
      final data = await _db.rpc('get_gateways_safe');
      return data.map((item) => Gateway.fromJson(item)).toList();
    } on PostgrestException catch (e) {
      throw DatabaseException(e.message, error: e);
    } catch (e) {
      throw DatabaseException('An unexpected error occurred', error: e);
    }
  }

  // Returns owner-only operational events for the inverter event log screen.
  Future<List<GatewayEvent>> gatewayEvents(String inverterId) async {
    try {
      await _ensureValidSession();
      final data = await _db
          .from('gateway_events')
          .select()
          .eq('inverter_id', inverterId)
          .order('recorded_at', ascending: false);
      return data.map((item) => GatewayEvent.fromJson(item)).toList();
    } on PostgrestException catch (e) {
      throw DatabaseException(e.message, error: e);
    } catch (e) {
      throw DatabaseException('An unexpected error occurred', error: e);
    }
  }

  // Returns the owner-only member list for managing viewers.
  Future<List<InverterMember>> inverterMembers(String inverterId) async {
    try {
      await _ensureValidSession();
      final data = await _db
          .from('inverter_members')
          .select()
          .eq('inverter_id', inverterId)
          .order('created_at', ascending: false);
      return data.map((item) => InverterMember.fromJson(item)).toList();
    } on PostgrestException catch (e) {
      throw DatabaseException(e.message, error: e);
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
      await _ensureValidSession();
      await _db
          .from('inverter_members')
          .delete()
          .eq('inverter_id', inverterId)
          .eq('user_id', userId);
    } on PostgrestException catch (e) {
      throw DatabaseException(e.message, error: e);
    } catch (e) {
      throw DatabaseException('An unexpected error occurred', error: e);
    }
  }

  // Invite link flow.

  // Creates a single-use viewer invite link via the create_invite_link edge function.
  Future<InviteLink> createInviteLink(String inverterId) async {
    try {
      await _ensureValidSession();
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
    } on FunctionException catch (e) {
      _logger.severe('Failed to create invite link', e);
      throw DatabaseException(
        e.reasonPhrase ?? 'Failed to create invite link',
        error: e,
      );
    } catch (e) {
      _logger.severe('Failed to create invite link', e);
      throw DatabaseException('An unexpected error occurred', error: e);
    }
  }

  // Loads public invite metadata for the invite landing page.
  // Auth is not required — get_invite_preview is a public edge function.
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
    } on FunctionException catch (e) {
      _logger.severe('Failed to get invite preview', e);
      throw DatabaseException(
        e.reasonPhrase ?? 'Failed to get invite preview',
        error: e,
      );
    } catch (e) {
      _logger.severe('Failed to get invite preview', e);
      throw DatabaseException('An unexpected error occurred', error: e);
    }
  }

  // Accepts an invite after auth and grants viewer access.
  Future<void> acceptInvite(String token) async {
    try {
      await _ensureValidSession();
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
    } on FunctionException catch (e) {
      _logger.severe('Failed to accept invite', e);
      throw DatabaseException(
        e.reasonPhrase ?? 'Failed to accept invite',
        error: e,
      );
    } catch (e) {
      _logger.severe('Failed to accept invite', e);
      throw DatabaseException('An unexpected error occurred', error: e);
    }
  }

  // Provisioning and gateway replacement.

  // Calls register_gateway for new setup or replace-gateway flows.
  Future<GatewayRegistrationResponse> registerGateway(
    GatewayRegistrationRequest request,
  ) async {
    try {
      await _ensureValidSession();
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
    } on FunctionException catch (e) {
      _logger.severe('Failed to register gateway', e);
      throw DatabaseException(
        e.reasonPhrase ?? 'Failed to register gateway',
        error: e,
      );
    } catch (e) {
      _logger.severe('Failed to register gateway', e);
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
