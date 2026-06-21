import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rivals/core/providers/theme_providers.dart';
import 'package:rivals/core/theme/app_theme.dart';

class ThemeUsage extends StatelessWidget {
  const ThemeUsage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ── Scaffold background ───────────────────────────────────────────────
      // Automatically uses AppTheme._lightBg or _darkBg — no code needed
      appBar: AppBar(
        // ── AppBar ─────────────────────────────────────────────────────────
        // Automatically uses AppTheme.appBarTheme:
        //   backgroundColor: surface (white / dark card)
        //   elevation: 0
        //   titleTextStyle: Inter 18 bold
        title: const Text('Rivals'), // styled by appBarTheme automatically
        actions: [
          // ── primaryIconTheme ─────────────────────────────────────────────
          // Icons in actions use primaryIconTheme: accent green, size 22
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),

      // ── Bottom nav bar ────────────────────────────────────────────────────
      // Uses AppTheme.bottomNavigationBarTheme automatically:
      //   selectedItemColor: accent green
      //   unselectedItemColor: t3 (muted)
      //   backgroundColor: surface
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (_) {},
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shield_outlined),
            label: 'My Club',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Explore'),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── context.tt — Text theme ─────────────────────────────────────
            // displaySmall = Inter 24 bold, text1 color
            Text('Theme showcase', style: context.tt.displaySmall),
            const SizedBox(height: 4),
            // bodyMedium = Inter 14 regular, text2 color (muted)
            Text(
              'Every token from app_theme.dart in one screen',
              style: context.tt.bodyMedium,
            ),
            const SizedBox(height: 24),

            // ── Text scale ──────────────────────────────────────────────────
            _Section(
              title: 'context.tt — text theme',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'displayLarge  · 32 ExtraBold',
                    style: context.tt.displayLarge,
                  ),
                  Text(
                    'displayMedium · 28 Bold',
                    style: context.tt.displayMedium,
                  ),
                  Text(
                    'displaySmall  · 24 Bold',
                    style: context.tt.displaySmall,
                  ),
                  const Divider(height: 16),
                  Text(
                    'headlineLarge  · 22 Bold',
                    style: context.tt.headlineLarge,
                  ),
                  Text(
                    'headlineMedium · 20 SemiBold',
                    style: context.tt.headlineMedium,
                  ),
                  Text(
                    'headlineSmall  · 18 SemiBold',
                    style: context.tt.headlineSmall,
                  ),
                  const Divider(height: 16),
                  Text(
                    'titleLarge  · 16 SemiBold',
                    style: context.tt.titleLarge,
                  ),
                  Text(
                    'titleMedium · 15 Medium',
                    style: context.tt.titleMedium,
                  ),
                  Text('titleSmall  · 13 Medium', style: context.tt.titleSmall),
                  const Divider(height: 16),
                  Text('bodyLarge  · 15 Regular', style: context.tt.bodyLarge),
                  Text(
                    'bodyMedium · 14 Regular muted',
                    style: context.tt.bodyMedium,
                  ),
                  Text(
                    'bodySmall  · 12 Regular muted',
                    style: context.tt.bodySmall,
                  ),
                  const Divider(height: 16),
                  Text(
                    'labelLarge  · 13 SemiBold',
                    style: context.tt.labelLarge,
                  ),
                  Text(
                    'labelMedium · 11 Medium muted',
                    style: context.tt.labelMedium,
                  ),
                  Text(
                    'labelSmall  · 10 Regular dim',
                    style: context.tt.labelSmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── context.cs — Color scheme ───────────────────────────────────
            _Section(
              title: 'context.cs — color scheme',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _ColorChip('primary\n(accent)', context.cs.primary),
                  _ColorChip('onPrimary', context.cs.onPrimary),
                  _ColorChip('primaryContainer', context.cs.primaryContainer),
                  _ColorChip('secondary\n(navy)', context.cs.secondary),
                  _ColorChip(
                    'secondaryContainer',
                    context.cs.secondaryContainer,
                  ),
                  _ColorChip('tertiary\n(warning)', context.cs.tertiary),
                  _ColorChip('error', context.cs.error),
                  _ColorChip('surface', context.cs.surface),
                  _ColorChip('onSurface\n(text1)', context.cs.onSurface),
                  _ColorChip(
                    'onSurfaceVariant\n(text2)',
                    context.cs.onSurfaceVariant,
                  ),
                  _ColorChip('outline\n(border)', context.cs.outline),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── AppTheme static constants ───────────────────────────────────
            _Section(
              title: 'AppTheme.x — static constants',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _ColorChip('accent', AppTheme.accent),
                  _ColorChip('accentDark', AppTheme.accentDark),
                  _ColorChip('navy', AppTheme.navy),
                  _ColorChip('error', AppTheme.error),
                  _ColorChip('warning', AppTheme.warning),
                  _ColorChip('success', AppTheme.success),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── context helpers ─────────────────────────────────────────────
            _Section(
              title: 'context.x — extension helpers',
              child: Column(
                children: [
                  _Row('context.isDark', '${context.isDark}'),
                  _Row('context.bgColor', _hexOf(context.bgColor)),
                  _Row('context.surfaceColor', _hexOf(context.surfaceColor)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Buttons ─────────────────────────────────────────────────────
            _Section(
              title: 'Buttons — styled by elevatedButtonTheme etc.',
              child: Column(
                children: [
                  // Uses elevatedButtonTheme: accent bg, white text, shape12
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('ElevatedButton'),
                  ),
                  const SizedBox(height: 8),
                  // Uses outlinedButtonTheme: border outline, shape12
                  OutlinedButton(
                    onPressed: () {},
                    child: const Text('OutlinedButton'),
                  ),
                  const SizedBox(height: 8),
                  // Uses textButtonTheme: accent color
                  TextButton(onPressed: () {}, child: const Text('TextButton')),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Input field ─────────────────────────────────────────────────
            _Section(
              title: 'TextField — styled by inputDecorationTheme',
              child: Column(
                children: [
                  // Uses inputDecorationTheme:
                  //   filled, fillColor, rounded, accent focus border
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search fans or clubs...',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Error state — uses errorBorder color
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Invalid input',
                      errorText: 'This field is required',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Card ────────────────────────────────────────────────────────
            _Section(
              title: 'Card — styled by cardTheme',
              child: Card(
                // cardTheme: surface color, 0 elevation, border, radius 12
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: context.cs.primaryContainer,
                        child: Icon(
                          Icons.sports_soccer,
                          color: context.cs.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Arsenal fan posted',
                              style: context.tt.titleSmall,
                            ),
                            Text(
                              'Haaland is overrated 😭',
                              style: context.tt.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ── Chips ───────────────────────────────────────────────────────
            _Section(
              title: 'Chips — styled by chipTheme',
              child: Wrap(
                spacing: 8,
                children: [
                  // chipTheme: inputFill bg, accent selected, shape24 (pill)
                  FilterChip(
                    label: const Text('Premier League'),
                    selected: true,
                    onSelected: (_) {},
                  ),
                  FilterChip(
                    label: const Text('La Liga'),
                    selected: false,
                    onSelected: (_) {},
                  ),
                  FilterChip(
                    label: const Text('Serie A'),
                    selected: false,
                    onSelected: (_) {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Divider ─────────────────────────────────────────────────────
            _Section(
              title: 'Divider — styled by dividerTheme',
              child: Column(
                children: [
                  // dividerTheme: border color, 0.5 thickness
                  const Divider(),
                  const SizedBox(height: 4),
                  Text(
                    '0.5px border color divider',
                    style: context.tt.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Switch ──────────────────────────────────────────────────────
            _Section(
              title: 'Switch — styled by switchTheme',
              child: Column(
                children: [
                  // switchTheme: accent thumb when on, border color track when off
                  SwitchListTile(
                    title: Text('Dark mode', style: context.tt.titleMedium),
                    subtitle: Text(
                      context.isDark ? 'Currently dark' : 'Currently light',
                      style: context.tt.bodySmall,
                    ),
                    // watch so switch rebuilds when theme changes
                    value: context.watch<ThemeProvider>().isDark,
                    onChanged: (_) => context.read<ThemeProvider>().toggle(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Snack bar ───────────────────────────────────────────────────
            _Section(
              title: 'SnackBar — styled by snackBarTheme',
              child: ElevatedButton.icon(
                // snackBarTheme: navy bg (light) / dark bg, accent action, floating
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Arsenal scored! 🔴'),
                      action: SnackBarAction(label: 'View', onPressed: () {}),
                    ),
                  );
                },
                icon: const Icon(Icons.notifications),
                label: const Text('Show SnackBar'),
              ),
            ),
            const SizedBox(height: 24),

            // ── Dialog ──────────────────────────────────────────────────────
            _Section(
              title: 'Dialog — styled by dialogTheme',
              child: OutlinedButton(
                // dialogTheme: surface bg, 0 elevation, shape16, Inter text
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Leave your club?'),
                      content: const Text(
                        'You picked your club. This cannot be undone.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Confirm'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
            const SizedBox(height: 24),

            // ── Bottom sheet ────────────────────────────────────────────────
            _Section(
              title: 'BottomSheet — styled by bottomSheetTheme',
              child: OutlinedButton(
                // bottomSheetTheme: surface bg, rounded top, drag handle
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (_) => Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Post options', style: context.tt.headlineSmall),
                          const SizedBox(height: 16),
                          ListTile(
                            leading: const Icon(Icons.share),
                            title: const Text('Share post'),
                            onTap: () {},
                          ),
                          ListTile(
                            leading: Icon(Icons.flag, color: context.cs.error),
                            title: Text(
                              'Report post',
                              style: TextStyle(color: context.cs.error),
                            ),
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: const Text('Show Bottom Sheet'),
              ),
            ),
            const SizedBox(height: 24),

            // ── ListTile ────────────────────────────────────────────────────
            _Section(
              title: 'ListTile — styled by listTileTheme',
              child: Column(
                children: [
                  // listTileTheme: Inter text, t2 icon color, shape8
                  ListTile(
                    leading: const Icon(Icons.shield),
                    title: const Text('Arsenal'),
                    subtitle: const Text('Premier League · 98k members'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.shield),
                    title: const Text('Man City'),
                    subtitle: const Text('Premier League · 142k members'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  String _hexOf(Color c) =>
      '#${c.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
}

// ── Helper widgets ─────────────────────────────────────────────────────────

class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: context.cs.primaryContainer,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            title,
            style: context.tt.labelLarge?.copyWith(color: AppTheme.accentDark),
          ),
        ),
        const SizedBox(height: 12),
        child,
        const SizedBox(height: 8),
        const Divider(),
      ],
    );
  }
}

class _ColorChip extends StatelessWidget {
  final String label;
  final Color color;
  const _ColorChip(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    final isLight = color.computeLuminance() > 0.4;
    return Container(
      width: 90,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.cs.outline, width: 0.5),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w600,
          color: isLight ? Colors.black87 : Colors.white,
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String key_;
  final String value;
  const _Row(this.key_, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(key_, style: context.tt.bodyMedium)),
          Text(
            value,
            style: context.tt.labelLarge?.copyWith(color: AppTheme.accent),
          ),
        ],
      ),
    );
  }
}
