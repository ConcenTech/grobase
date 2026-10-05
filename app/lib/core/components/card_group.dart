import 'package:material_ui/material_ui.dart';

class CardGroup extends StatelessWidget {
  const CardGroup(this.children, {super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(mainAxisSize: MainAxisSize.min, children: children),
    );
  }
}
