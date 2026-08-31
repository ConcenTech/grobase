import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/database/inverter.drift.dart';
import '../../services/database/database_providers.dart';

class SystemDetailsButton extends ConsumerWidget {
  const SystemDetailsButton({super.key, required this.inverter});

  final Inverter? inverter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (inverter == null) {
      return const SizedBox();
    }

    final isOwner = ref
        .watch(DatabaseProviders.userMembership(inverter!.id))
        .maybeWhen(
          data: (user) => user?.role == .owner,
          orElse: () => false,
          skipLoadingOnRefresh: true,
          skipLoadingOnReload: true,
        );

    if (!isOwner) {
      return const SizedBox();
    }

    return IconButton(
      onPressed: () =>
          GoRouter.of(context).push('/system-details', extra: inverter),
      icon: const Icon(Icons.info),
    );
  }
}
