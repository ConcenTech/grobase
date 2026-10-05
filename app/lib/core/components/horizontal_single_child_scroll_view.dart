import 'package:material_ui/material_ui.dart';

class HorizontalSingleChildScrollView extends StatefulWidget {
  const HorizontalSingleChildScrollView({
    super.key,
    required this.child,
    this.padding,
    this.primary,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final bool? primary;

  @override
  State<HorizontalSingleChildScrollView> createState() =>
      _HorizontalSingleChildScrollViewState();
}

class _HorizontalSingleChildScrollViewState
    extends State<HorizontalSingleChildScrollView> {
  final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _controller,

      child: SingleChildScrollView(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        padding: widget.padding,
        primary: widget.primary,
        child: widget.child,
      ),
    );
  }
}
