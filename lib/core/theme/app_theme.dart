import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Single source of truth for all visual styling in Footy Hub.
/// Usage:
///   MaterialApp(
///     theme: AppTheme.light,
///     darkTheme: AppTheme.dark,
///     themeMode: ThemeMode.system,
///   )
class AppTheme {
  AppTheme._();

  // ── Brand palette ──────────────────────────────────────────────────────────
  // static const Color _accent = Color(0xFFB6F24D);
  // static const Color _accent = Color(0xFF52A8FF);
  static const Color _accent = Color(0xFFFF8A3D);
  static const Color accentInk = Color(0xFF10210A);
  static const Color _accentDark = Color(0xFF12A35E);
  static const Color _navy = Color(0xFF1A1A2E);
  static const Color _error = Color(0xFFE53935);
  static const Color _warning = Color(0xFFFFA726);
  static const Color _success = Color(0xFF43A047);

  // Light surface palette
  static const Color _lightBg = Color(0xFFF4F4F6);
  static const Color _lightSurface = Color(0xFFFFFFFF);
  static const Color _lightCard = Color(0xFFFFFFFF);
  static const Color _lightBorder = Color(0xFFE4E4E7);
  static const Color _lightText1 = Color(0xFF111118);
  static const Color _lightText2 = Color(0xFF6B6B7B);
  static const Color _lightText3 = Color(0xFFA1A1B0);

  // Dark surface palette
  // static const Color _darkBg = Color(0xFF0C0C0F);
  static const Color _darkBg = Color(0xFF14161B);
  static const Color _darkSurface = Color(0xFF17171C);
  static const Color _darkCard = Color(0xFF1E1E25);
  static const Color _darkBorder = Color(0xFF2A2A35);
  static const Color _darkText1 = Color(0xFFF2F2F5);
  static const Color _darkText2 = Color(0xFF9090A0);
  static const Color _darkText3 = Color(0xFF5A5A6A);

  // ── Exposed color constants (use in widgets for club-agnostic tints) ───────
  static const Color accent = _accent;
  static const Color accentDark = _accentDark;
  static const Color navy = _navy;
  static const Color error = _error;
  static const Color warning = _warning;
  static const Color success = _success;

  // ── Typography scale ───────────────────────────────────────────────────────
  static TextTheme _buildTextTheme(Color t1, Color t2, Color t3) {
    return TextTheme(
      // Display
      displayLarge: _t(32, FontWeight.w800, t1, 0),
      displayMedium: _t(28, FontWeight.w700, t1, 0),
      displaySmall: _t(24, FontWeight.w700, t1, 0),
      // Headline
      headlineLarge: _t(22, FontWeight.w700, t1, 0),
      headlineMedium: _t(20, FontWeight.w600, t1, 0),
      headlineSmall: _t(18, FontWeight.w600, t1, 0),
      // Title
      titleLarge: _t(16, FontWeight.w600, t1, 0),
      titleMedium: _t(15, FontWeight.w500, t1, 0),
      titleSmall: _t(13, FontWeight.w500, t1, 0.1),
      // Body
      bodyLarge: _t(15, FontWeight.w400, t1, 0),
      bodyMedium: _t(14, FontWeight.w400, t2, 0),
      bodySmall: _t(12, FontWeight.w400, t2, 0),
      // Label
      labelLarge: _t(13, FontWeight.w600, t1, 0.2),
      labelMedium: _t(11, FontWeight.w500, t2, 0.3),
      labelSmall: _t(10, FontWeight.w400, t3, 0.4),
    );
  }

  static TextStyle _t(
    double size,
    FontWeight weight,
    Color color,
    double spacing,
  ) {
    return TextStyle(
      fontFamily: 'Inter',
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: spacing,
      height: 1.4,
    );
  }

  // ── Shape system ───────────────────────────────────────────────────────────
  static final _shape4 = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(4),
  );
  static final _shape8 = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
  );
  static final _shape12 = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  );
  static final _shape16 = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  );
  static final _shape24 = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(24),
  );

  // ── LIGHT THEME ────────────────────────────────────────────────────────────
  static ThemeData get light {
    final cs = ColorScheme(
      brightness: Brightness.light,
      primary: _accent,
      onPrimary: Colors.white,
      primaryContainer: _accent.withOpacity(0.12),
      onPrimaryContainer: _accentDark,
      secondary: _navy,
      onSecondary: Colors.white,
      secondaryContainer: _navy.withOpacity(0.08),
      onSecondaryContainer: _navy,
      tertiary: _warning,
      onTertiary: Colors.white,
      tertiaryContainer: _warning.withOpacity(0.12),
      onTertiaryContainer: const Color(0xFF7A4F00),
      error: _error,
      onError: Colors.white,
      errorContainer: _error.withOpacity(0.12),
      onErrorContainer: const Color(0xFF7A1212),
      surface: _lightSurface,
      onSurface: _lightText1,
      onSurfaceVariant: _lightText2,
      outline: _lightBorder,
      outlineVariant: _lightBorder.withOpacity(0.5),
      shadow: Colors.black.withOpacity(0.08),
      scrim: Colors.black54,
      inverseSurface: _darkSurface,
      onInverseSurface: _darkText1,
      inversePrimary: _accent,
      surfaceTint: _accent.withOpacity(0.04),
    );

    return _buildTheme(
      cs: cs,
      bg: _lightBg,
      surface: _lightSurface,
      card: _lightCard,
      border: _lightBorder,
      t1: _lightText1,
      t2: _lightText2,
      t3: _lightText3,
      inputFill: const Color(0xFFF0F0F3),
      isDark: false,
    );
  }

  // ── DARK THEME ─────────────────────────────────────────────────────────────
  static ThemeData get dark {
    final cs = ColorScheme(
      brightness: Brightness.dark,
      primary: _accent,
      onPrimary: Colors.white,
      primaryContainer: _accent.withOpacity(0.16),
      onPrimaryContainer: const Color(0xFF7FFFD4),
      secondary: const Color(0xFF8899CC),
      onSecondary: Colors.white,
      secondaryContainer: _navy,
      onSecondaryContainer: const Color(0xFFCCD6FF),
      tertiary: _warning,
      onTertiary: Colors.black,
      tertiaryContainer: _warning.withOpacity(0.16),
      onTertiaryContainer: const Color(0xFFFFDDA0),
      error: const Color(0xFFFF6B6B),
      onError: Colors.black,
      errorContainer: _error.withOpacity(0.2),
      onErrorContainer: const Color(0xFFFFB3B3),
      surface: _darkSurface,
      onSurface: _darkText1,
      onSurfaceVariant: _darkText2,
      outline: _darkBorder,
      outlineVariant: _darkBorder.withOpacity(0.5),
      shadow: Colors.black.withOpacity(0.4),
      scrim: Colors.black87,
      inverseSurface: _lightSurface,
      onInverseSurface: _lightText1,
      inversePrimary: _accentDark,
      surfaceTint: _accent.withOpacity(0.04),
    );

    return _buildTheme(
      cs: cs,
      bg: _darkBg,
      surface: _darkSurface,
      card: _darkCard,
      border: _darkBorder,
      t1: _darkText1,
      t2: _darkText2,
      t3: _darkText3,
      inputFill: const Color(0xFF22222C),
      isDark: true,
    );
  }

  // ── Shared theme builder ───────────────────────────────────────────────────
  static ThemeData _buildTheme({
    required ColorScheme cs,
    required Color bg,
    required Color surface,
    required Color card,
    required Color border,
    required Color t1,
    required Color t2,
    required Color t3,
    required Color inputFill,
    required bool isDark,
  }) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: cs,
      fontFamily: 'Inter',
      scaffoldBackgroundColor: bg,
      splashFactory: InkRipple.splashFactory,
      textTheme: _buildTextTheme(t1, t2, t3),

      // ── AppBar ────────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: t1,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
        systemOverlayStyle: isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        titleTextStyle: _t(18, FontWeight.w700, t1, 0),
        iconTheme: IconThemeData(color: t1, size: 22),
      ),

      // ── Bottom nav ────────────────────────────────────────────────────────
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: _accent,
        unselectedItemColor: t3,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: _t(10, FontWeight.w600, _accent, 0.2),
        unselectedLabelStyle: _t(10, FontWeight.w400, t3, 0.2),
      ),

      // ── Cards ─────────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: border, width: 0.5),
        ),
      ),

      // ── Elevated button ───────────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _accent,
          foregroundColor: Colors.white,
          disabledBackgroundColor: _accent.withOpacity(0.4),
          disabledForegroundColor: Colors.white70,
          minimumSize: const Size(double.infinity, 50),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          elevation: 0,
          shape: _shape12,
          textStyle: _t(15, FontWeight.w600, Colors.white, 0),
        ),
      ),

      // ── Outlined button ───────────────────────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: t1,
          minimumSize: const Size(double.infinity, 50),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          shape: _shape12,
          side: BorderSide(color: border, width: 1),
          textStyle: _t(15, FontWeight.w600, t1, 0),
        ),
      ),

      // ── Text button ───────────────────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _accent,
          textStyle: _t(14, FontWeight.w600, _accent, 0),
          shape: _shape8,
        ),
      ),

      // ── Input fields ──────────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputFill,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        hintStyle: _t(14, FontWeight.w400, t3, 0),
        labelStyle: _t(14, FontWeight.w400, t2, 0),
        floatingLabelStyle: _t(12, FontWeight.w500, _accent, 0),
        prefixIconColor: t3,
        suffixIconColor: t3,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _accent, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _error, width: 1.5),
        ),
      ),

      // ── Chips ─────────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: inputFill,
        selectedColor: _accent.withOpacity(0.15),
        labelStyle: _t(12, FontWeight.w500, t1, 0),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        shape: _shape24,
        side: BorderSide(color: border, width: 0.5),
        showCheckmark: false,
      ),

      // ── Divider ───────────────────────────────────────────────────────────
      dividerTheme: DividerThemeData(color: border, thickness: 0.5, space: 0),

      // ── Dialog ────────────────────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        elevation: 0,
        shape: _shape16,
        titleTextStyle: _t(18, FontWeight.w700, t1, 0),
        contentTextStyle: _t(14, FontWeight.w400, t2, 0),
      ),

      // ── Bottom sheet ──────────────────────────────────────────────────────
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface,
        modalBackgroundColor: surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        showDragHandle: true,
        dragHandleColor: border,
        elevation: 0,
      ),

      // ── Snack bar ─────────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? const Color(0xFF2A2A35) : _navy,
        contentTextStyle: _t(13, FontWeight.w400, Colors.white, 0),
        actionTextColor: _accent,
        shape: _shape8,
        behavior: SnackBarBehavior.floating,
      ),

      // ── List tile ─────────────────────────────────────────────────────────
      listTileTheme: ListTileThemeData(
        iconColor: t2,
        textColor: t1,
        subtitleTextStyle: _t(12, FontWeight.w400, t2, 0),
        titleTextStyle: _t(14, FontWeight.w500, t1, 0),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: _shape8,
      ),

      // ── Switch ────────────────────────────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? _accent : Colors.white,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? _accent.withOpacity(0.5)
              : border,
        ),
      ),

      // ── Tab bar ───────────────────────────────────────────────────────────
      tabBarTheme: TabBarThemeData(
        labelColor: _accent,
        unselectedLabelColor: t3,
        labelStyle: _t(13, FontWeight.w600, _accent, 0.2),
        unselectedLabelStyle: _t(13, FontWeight.w400, t3, 0.2),
        indicatorColor: _accent,
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: border,
      ),

      // ── Icon ──────────────────────────────────────────────────────────────
      iconTheme: IconThemeData(color: t2, size: 22),
      primaryIconTheme: const IconThemeData(color: _accent, size: 22),
    );
  }
}

// ── Extension helpers — use these in widgets ───────────────────────────────
extension ThemeX on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get cs => Theme.of(this).colorScheme;
  TextTheme get tt => Theme.of(this).textTheme;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  Color get bgColor => Theme.of(this).scaffoldBackgroundColor;
  Color get surfaceColor => Theme.of(this).colorScheme.surface;
}
