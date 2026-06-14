import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/gateway.dart';
import '../models/gateway_event.dart';
import '../models/gateway_registration.dart';
import '../models/inverter.dart';
import '../models/inverter_member.dart';
import '../models/inverter_snapshot.dart';
import '../models/invite_link.dart';
import '../models/invite_preview.dart';

final databaseProvider = Provider.autoDispose((ref) => DatabaseService());

class DatabaseService {
  final _db = Supabase.instance.client;

  // Returns the current user's inverters for the home screen.
  Future<List<Inverter>> inverters() async {
    try {
      final data = await _db
          .from('inverters')
          .select()
          .order('created_at', ascending: false);

      return data.map((item) => Inverter.fromJson(item)).toList();
    } on PostgrestException catch (e) {
      throw DatabaseException(e.message, error: e.details);
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
      final data = await _db
          .from('inverter_snapshots')
          .select()
          .eq('inverter_id', inverterId)
          .filter('ingested_at', '<=', end?.toIso8601String())
          .filter('ingested_at', '>=', start?.toIso8601String())
          .order('timestamp', ascending: true);

      return data.map((item) => InverterSnapshot.fromJson(item)).toList();
    } on PostgrestException catch (e) {
      throw DatabaseException(e.message, error: e.details);
    } catch (e) {
      throw DatabaseException('An unexpected error occurred', error: e);
    }
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
          .order('timestamp', ascending: false);
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
  String toString() => 'DatabaseException: $message';
}
