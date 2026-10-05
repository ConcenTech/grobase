import 'package:material_ui/material_ui.dart';
import 'package:google_fonts/google_fonts.dart';

class InverterTitleText extends StatelessWidget {
  const InverterTitleText({required this.name, super.key});

  final String name;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleTextTheme = theme.textTheme.headlineMedium!.merge(
      GoogleFonts.montserrat(fontWeight: .w500),
    );

    return Hero(
      tag: 'app-bar-title-$name',
      child: Text(
        name,
        style: titleTextTheme,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
