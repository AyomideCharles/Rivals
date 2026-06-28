import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rivals/core/theme/app_theme.dart';
import 'package:rivals/features/auth/widgets/splash_screen.dart';

class RivalsLogo extends StatelessWidget {
  final double size;
  final Color? color;
  final Color accentColor;
  final bool withCrest;
  final String crestLabel;

  const RivalsLogo({
    super.key,
    this.size = 24,
    this.color,
    this.accentColor = AppTheme.accent,
    this.withCrest = false,
    this.crestLabel = 'RV',
  });

  @override
  Widget build(BuildContext context) {
    final textColor = color ?? Theme.of(context).colorScheme.onSurface;

    final base = GoogleFonts.archivo(
      fontWeight: FontWeight.w900,
      fontSize: size,
      height: 1.0,
      letterSpacing: size * 0.005,
      color: textColor,
    );

    final wordmark = RichText(
      text: TextSpan(
        style: base,
        children: [
          const TextSpan(text: 'RIV'),
          TextSpan(
            text: 'A',
            style: base.copyWith(color: accentColor),
          ),
          const TextSpan(text: 'LS'),
        ],
      ),
    );

    if (!withCrest) return wordmark;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ShieldCrest(
          size: size * 1.15,
          color: accentColor,
          ink: AppTheme.accentInk,
          label: crestLabel,
        ),
        SizedBox(width: size * 0.34),
        wordmark,
      ],
    );
  }
}
