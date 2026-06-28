import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rivals/core/providers/theme_providers.dart';
import 'package:rivals/core/theme/app_theme.dart';
import 'package:rivals/features/auth/widgets/onboarding.dart';
import 'package:rivals/features/auth/provider/auth_provider.dart';
import 'package:rivals/features/auth/widgets/splash_screen.dart';
import 'package:rivals/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final themeProvider = ThemeProvider();
  await themeProvider.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => themeProvider),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
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
            textTheme: GoogleFonts.spaceGroteskTextTheme(
              AppTheme.light.textTheme,
            ),
          ),
          darkTheme: AppTheme.dark.copyWith(
            textTheme: GoogleFonts.spaceGroteskTextTheme(
              AppTheme.dark.textTheme,
            ),
          ),
          themeMode: context.watch<ThemeProvider>().mode,
          builder: FlutterSmartDialog.init(),
          home: SplashScreen(onDone: () {}),
          // home: Builder(
          //   builder: (context) => SplashScreen(
          //     onDone: () => Navigator.of(context).pushReplacement(
          //       MaterialPageRoute(builder: (_) => const Onboarding()),
          //     ),
          //   ),
          // ),
        );
      },
    );
  }
}
