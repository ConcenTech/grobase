import 'package:material_ui/material_ui.dart';

import '../../theme/theme.dart';

class ThemeTestScreen extends StatefulWidget {
  const ThemeTestScreen({super.key});

  @override
  State<ThemeTestScreen> createState() => _ThemeTestScreenState();
}

class _ThemeTestScreenState extends State<ThemeTestScreen> {
  final ScrollController _controller1 = ScrollController();
  final ScrollController _controller2 = ScrollController();
  bool _isSyncing = false;

  @override
  void initState() {
    super.initState();
    // 2. Add listeners to sync the offsets
    _controller1.addListener(() {
      if (!_isSyncing) {
        _isSyncing = true;
        _controller2.jumpTo(_controller1.offset);
        _isSyncing = false;
      }
    });

    _controller2.addListener(() {
      if (!_isSyncing) {
        _isSyncing = true;
        _controller1.jumpTo(_controller2.offset);
        _isSyncing = false;
      }
    });
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: ColoredBox(
              color: Colors.black,
              child: Theme(
                data: AppTheme.dark,
                child: ThemeList(scrollController: _controller1),
              ),
            ),
          ),
          Expanded(
            child: ColoredBox(
              color: Colors.white,
              child: Theme(
                data: AppTheme.light,
                child: ThemeList(scrollController: _controller2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ThemeWidget extends StatelessWidget {
  const ThemeWidget({super.key, required this.title, required this.color});

  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(backgroundColor: color),
    );
  }
}

class ThemeList extends StatelessWidget {
  const ThemeList({super.key, required this.scrollController});

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tm = {
      'primary': cs.primary,
      'onPrimary': cs.onPrimary,
      'primaryContainer': cs.primaryContainer,
      'onPrimaryContainer': cs.onPrimaryContainer,
      'primaryFixed': cs.primaryFixed,
      'primaryFixedDim': cs.primaryFixedDim,
      'onPrimaryFixed': cs.onPrimaryFixed,
      'onPrimaryFixedVariant': cs.onPrimaryFixedVariant,
      'secondary': cs.secondary,
      'onSecondary': cs.onSecondary,
      'secondaryContainer': cs.secondaryContainer,
      'onSecondaryContainer': cs.onSecondaryContainer,
      'secondaryFixed': cs.secondaryFixed,
      'secondaryFixedDim': cs.secondaryFixedDim,
      'onSecondaryFixed': cs.onSecondaryFixed,
      'onSecondaryFixedVariant': cs.onSecondaryFixedVariant,
      'tertiary': cs.tertiary,
      'onTertiary': cs.onTertiary,
      'tertiaryContainer': cs.tertiaryContainer,
      'onTertiaryContainer': cs.onTertiaryContainer,
      'tertiaryFixed': cs.tertiaryFixed,
      'tertiaryFixedDim': cs.tertiaryFixedDim,
      'onTertiaryFixed': cs.onTertiaryFixed,
      'onTertiaryFixedVariant': cs.onTertiaryFixedVariant,
      'error': cs.error,
      'onError': cs.onError,
      'errorContainer': cs.errorContainer,
      'onErrorContainer': cs.onErrorContainer,
      'surface': cs.surface,
      'onSurface': cs.onSurface,
      'surfaceDim': cs.surfaceDim,
      'surfaceBright': cs.surfaceBright,
      'surfaceContainerLowest': cs.surfaceContainerLowest,
      'surfaceContainerLow': cs.surfaceContainerLow,
      'surfaceContainer': cs.surfaceContainer,
      'surfaceContainerHigh': cs.surfaceContainerHigh,
      'surfaceContainerHighest': cs.surfaceContainerHighest,
      'onSurfaceVariant': cs.onSurfaceVariant,
      'outline': cs.outline,
      'outlineVariant': cs.outlineVariant,
      'shadow': cs.shadow,
      'scrim': cs.scrim,
      'inverseSurface': cs.inverseSurface,
      'onInverseSurface': cs.onInverseSurface,
      'inversePrimary': cs.inversePrimary,
      'surfaceTint': cs.surfaceTint,
    };

    return ListView.builder(
      controller: scrollController,
      itemCount: tm.length,
      itemBuilder: (context, index) {
        final entry = tm.entries.elementAt(index);
        return ThemeWidget(title: entry.key, color: entry.value);
      },
    );
  }
}
