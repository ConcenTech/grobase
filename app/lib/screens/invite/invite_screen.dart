import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/components/app_scaffold.dart';
import '../../core/components/loading_indicator.dart';
import '../../models/invite_preview.dart';
import 'invite_screen_notifier.dart';

TextStyle _errorTextStyle(ThemeData theme) {
  return theme.textTheme.bodyMedium!.copyWith(
    color: theme.colorScheme.error,
    fontWeight: FontWeight.w600,
    fontSize: 14,
  );
}

class InviteScreen extends ConsumerWidget {
  final String token;

  const InviteScreen({super.key, required this.token});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(inviteScreenProvider(token), (_, state) {
      if (state is InviteScreenStateAccepted) {
        context.go('/home');
      }
    });

    final state = ref.watch(inviteScreenProvider(token));
    final theme = Theme.of(context);

    final Widget body;

    if (state.isLoading || state.hasError) {
      body = _InviteScreenChildren(
        heading: 'System invite',
        children: [
          if (state.isLoading) ...[
            const Text('Please wait while we load the invite details.'),
            const LoadingIndicator(),
          ] else
            Text(
              (state as InviteScreenStateError).message,
              style: _errorTextStyle(theme),
            ),

          if (state.hasError)
            FilledButton(
              onPressed: () {
                GoRouter.of(context).go('/home');
              },
              child: const Text('Go home'),
            )
          else
            const SizedBox(height: 20),
        ],
      );
    } else {
      state as InviteScreenStatePreviewLoaded;
      final preview = state.preview;

      body = switch (preview.status) {
        .pending => _InviteValidWidget(
          preview: preview,
          token: token,
          isAccepting: state.isAccepting,
        ),
        .expired => const _InviteInvalidWidget(isExpired: true),
        .revoked || .used => const _InviteInvalidWidget(isExpired: false),
      };
    }

    return AppScaffold(showAppName: true, body: body);
  }
}

class _InviteInvalidWidget extends StatelessWidget {
  /// If true, the invite has expired. Othwise, the invite is unavailable
  final bool isExpired;

  const _InviteInvalidWidget({required this.isExpired});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _InviteScreenChildren(
      heading: 'Invite unavailable',
      children: [
        if (isExpired)
          Text(
            'This invite has expired.\n'
            'Please contact the system owner for a new invite.',
            style: _errorTextStyle(theme),
          )
        else
          Text(
            'This invite has been used or revoked.\n'
            'Please contact the system owner for a new invite.',
            style: _errorTextStyle(theme),
          ),
        FilledButton(
          onPressed: () {
            GoRouter.of(context).go('/home');
          },
          child: const Text('Go home'),
        ),
      ],
    );
  }
}

class _InviteValidWidget extends StatelessWidget {
  final InvitePreview preview;
  final bool isAccepting;
  final String token;

  const _InviteValidWidget({
    required this.preview,
    required this.token,
    required this.isAccepting,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final line1 = preview.invitedByEmail == null
        ? 'You have been invited as a viewer to'
        : '${preview.invitedByEmail} has invited you to be a viewer of';
    final line2 = preview.inverterName == null
        ? 'a Grobase system.'
        : '${preview.inverterName}.';
    return _InviteScreenChildren(
      heading: 'You\'re invited!',
      children: [
        Text('$line1 $line2'),
        Consumer(
          builder: (context, ref, child) {
            return FilledButton(
              onPressed: isAccepting
                  ? null
                  : () {
                      ref
                          .read(inviteScreenProvider(token).notifier)
                          .acceptInvite();
                    },
              child: isAccepting
                  ? const Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : const Text('Accept invite'),
            );
          },
        ),
        TextButton(
          onPressed: isAccepting
              ? null
              : () {
                  GoRouter.of(context).go('/home');
                },
          child: const Text('Not now'),
        ),
      ],
    );
  }
}

class _InviteScreenChildren extends StatelessWidget {
  const _InviteScreenChildren({
    super.key,
    required this.children,
    required this.heading,
  });

  final List<Widget> children;
  final String heading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 16,
          children: [
            Flexible(
              child: Image.asset(
                'assets/images/renewable-energy-site.png',
                fit: BoxFit.contain,
              ),
            ),
            Text(heading, style: theme.textTheme.headlineLarge),
            ...children,
          ],
        ),
      ),
    );
  }
}
