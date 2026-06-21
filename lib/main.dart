import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rivals/core/providers/theme_providers.dart';
import 'package:rivals/core/theme/app_theme.dart';
import 'package:rivals/features/auth/onboarding.dart';
import 'package:rivals/features/auth/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final themeProvider = ThemeProvider();
  await themeProvider.init();

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => themeProvider)],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) {
        return MaterialApp(
          title: 'Rivals',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light.copyWith(
            textTheme: GoogleFonts.hankenGroteskTextTheme(
              AppTheme.light.textTheme,
            ),
          ),
          darkTheme: AppTheme.dark.copyWith(
            textTheme: GoogleFonts.hankenGroteskTextTheme(
              AppTheme.dark.textTheme,
            ),
          ),
          themeMode: context.watch<ThemeProvider>().mode,
          home: Builder(
            builder: (context) => SplashScreen(
              onDone: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const Onboarding()),
              ),
            ),
          ),
        );
      },
    );
  }
}
