import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rivals/core/providers/theme_providers.dart';
import 'package:rivals/core/theme/app_theme.dart';
import 'package:rivals/features/auth/views/login.dart';
import 'package:rivals/features/auth/views/sign_up.dart';
import 'package:rivals/shared/app_button.dart';
import 'package:rivals/shared/app_logo_text.dart';
import 'package:rivals/theme_usage.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RivalsLogo(),
                  SizedBox(width: 20),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: context.cs.outline, width: 1),
                      color: context.cs.surface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      onPressed: () {
                        context.read<ThemeProvider>().toggle();
                      },
                      icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 22),
              CardContainer(),
              SizedBox(height: 22),
              Text('Pick a side.', style: context.tt.displayLarge),
              RichText(
                text: TextSpan(
                  style: context.tt.displayLarge,
                  children: [
                    TextSpan(text: 'Talk your '),
                    TextSpan(
                      text: 'talk',
                      style: TextStyle(color: AppTheme.accent),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 22),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ThemeUsage()),
                  );
                },
                child: Text(
                  "Join your club's community, fire back at the rivals, and live every match-day with millions of fans.",
                  style: context.tt.titleSmall,
                ),
              ),
              Spacer(),
              AppButton(
                label: 'Create your account',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUp()),
                  );
                },
              ),
              const SizedBox(height: 8),
              AppButton2(
                label: 'I already have an account',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardContainer extends StatelessWidget {
  final double height;
  final List<String> crests;
  final bool useNetwork;

  const CardContainer({
    super.key,
    this.height = 168,
    this.useNetwork = false,
    this.crests = const [
      'assets/images/manutd.png',
      'assets/images/manutd.png',
      'assets/images/manutd.png',
      'assets/images/manutd.png',
      'assets/images/manutd.png',
      'assets/images/manutd.png',
      'assets/images/manutd.png',
      'assets/images/manutd.png',
    ],
  });

  Widget _crestImage(String src, double size) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        src,
        width: size,
        height: size,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => _missing(size, Colors.transparent),
      ),
    );
  }

  Widget _missing(double size, Color borderColor) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(size * 0.18),
      border: Border.all(color: borderColor),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final card = context.cs.surface;
    final cardElev = context.cs.surfaceContainerHighest;
    final borderColor = context.cs.outline;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borderColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.28,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [for (final src in crests) _crestImage(src, 40)],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.transparent, cardElev],
                  stops: const [0.2, 0.92],
                ),
              ),
            ),
          ),
          Positioned(
            left: 18,
            right: 18,
            bottom: 18,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '1 M FANS · 100 CLUBS · ENDLESS BANTER',
                  style: context.tt.bodySmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'The home of football \nfan culture',
                  style: context.tt.displayMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
