import 'package:flutter/material.dart';
import 'package:rivals/core/theme/app_theme.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const AppButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: 48,
        decoration: BoxDecoration(
          border: Border.all(color: context.cs.outline, width: 1),
          color: AppTheme.accent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            label,
            style: context.tt.labelLarge?.copyWith(color: Colors.black),
          ),
        ),
      ),
    );
  }
}

class AppButton2 extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const AppButton2({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: 48,
        decoration: BoxDecoration(
          color: context.cs.surface,
          border: Border.all(color: context.cs.outline, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(child: Text(label, style: context.tt.labelLarge)),
      ),
    );
  }
}
