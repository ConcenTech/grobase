import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/components/bottom_sheet_container.dart';
import '../../core/components/loading_indicator.dart';
import '../../models/database/inverter.dart';
import '../../services/database/online_database_service.dart';
import '../../services/inverters/inverter_invites_notifier.dart';

class InviteMemberWidget extends ConsumerStatefulWidget {
  const InviteMemberWidget({super.key, required this.inverter});

  final Inverter inverter;

  @override
  ConsumerState<InviteMemberWidget> createState() => _InviteMemberWidgetState();
}

class _InviteMemberWidgetState extends ConsumerState<InviteMemberWidget> {
  bool _isLoading = false;
  final TextEditingController _inviteLinkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _generateInviteLink();
  }

  Future<void> _generateInviteLink() async {
    setState(() => _isLoading = true);

    try {
      final link = await ref
          .read(inverterInvitesProvider(widget.inverter.id).notifier)
          .create();

      _inviteLinkController.text = link?.url ?? '';
    } on DatabaseException catch (e) {
      _showError(e.message);
    }

    setState(() => _isLoading = false);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _copyInviteLink() {
    Clipboard.setData(ClipboardData(text: _inviteLinkController.text));
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BottomSheetContainer(
      spacing: 8.0,
      children: [
        Text('Invite Member', style: textTheme.titleLarge),
        const Text(
          'The generated link is valid for 7 days and can only be used once.',
        ),
        if (_isLoading)
          const LoadingIndicator()
        else
          TextField(
            controller: _inviteLinkController,
            readOnly: true,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: _inviteLinkController.text.isEmpty
                    ? null
                    : _copyInviteLink,
                icon: const Icon(Icons.copy),
              ),
              border: const OutlineInputBorder(),
            ),
          ),
      ],
    );
  }
}
