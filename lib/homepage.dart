import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rivals/core/providers/theme_providers.dart';
import 'package:rivals/core/theme/app_theme.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Homepage', style: context.tt.bodyLarge),
          Container(height: 200, width: 200, color: Colors.blue),
          SwitchListTile(
            title: const Text('Dark mode'),
            value: context.watch<ThemeProvider>().isDark,
            onChanged: (_) => context.read<ThemeProvider>().toggle(),
          ),
        ],
      ),
    );
  }
}
