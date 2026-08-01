import 'package:flutter/material.dart';

const kBottomNavBarHeight = 80.0;

class NavigationBarItem {
  const NavigationBarItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final Widget icon;
  final Widget selectedIcon;
  final String label;
}

class BottomNavigationBar extends StatelessWidget {
  const BottomNavigationBar({
    required this.index,
    required this.items,
    required this.onDestinationSelected,
    super.key,
  });

  final int index;
  final void Function(int index) onDestinationSelected;
  final List<NavigationBarItem> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MediaQuery(
      data: MediaQuery.of(context).removePadding(removeTop: true),
      child: NavigationBar(
        backgroundColor:
            (theme.appBarTheme.backgroundColor ?? theme.colorScheme.surface)
                .withValues(alpha: 0.6),
        selectedIndex: index,
        onDestinationSelected: onDestinationSelected,
        destinations: items
            .map(
              (e) => NavigationDestination(
                icon: e.icon,
                selectedIcon: e.selectedIcon,
                label: e.label,
              ),
            )
            .toList(),
      ),
    );
  }
}

class SideNavigationBar extends StatelessWidget {
  const SideNavigationBar({
    required this.index,
    required this.items,
    required this.onDestinationSelected,
    required this.midWidth,
    super.key,
  });

  final int index;
  final void Function(int index) onDestinationSelected;
  final List<NavigationBarItem> items;

  final double midWidth;

  @override
  Widget build(BuildContext context) {
    final leftPdding = MediaQuery.viewInsetsOf(context).left;
    final theme = Theme.of(context);
    return NavigationRail(
      minWidth: leftPdding + midWidth,
      backgroundColor:
          (theme.appBarTheme.backgroundColor ?? theme.colorScheme.surface)
              .withValues(alpha: 0.6),
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      selectedIndex: index,
      onDestinationSelected: onDestinationSelected,
      destinations: items
          .map(
            (e) => NavigationRailDestination(
              icon: e.icon,
              selectedIcon: e.selectedIcon,
              label: Text(e.label),
            ),
          )
          .toList(),
      labelType: NavigationRailLabelType.all,
      useIndicator: true,
    );
  }
}
