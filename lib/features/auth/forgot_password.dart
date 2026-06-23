import 'package:flutter/material.dart';
import 'package:rivals/core/theme/app_theme.dart';
import 'package:rivals/shared/app_bar.dart';
import 'package:rivals/shared/app_button.dart';
import 'package:rivals/shared/app_textfield.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(showLogo: true),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(height: 16),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text('Reset password', style: context.tt.displayLarge),
                SizedBox(height: 4),
                Text(
                  "Enter your email and we'll send you a link to get back to the banter",
                ),
                SizedBox(height: 30),
                Text('EMAIL', style: context.tt.bodySmall),
                SizedBox(height: 12),
                AppTextField(
                  hint: 'e.g. you@email.com',
                  prefixIcon: Icon(Icons.mail),
                ),
                SizedBox(height: 35),
                AppButton(label: 'Send reset link', onPressed: () {}),
                SizedBox(height: 15),
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: context.tt.titleSmall,
                      children: [
                        TextSpan(text: 'Remembered it? '),
                        TextSpan(
                          text: 'Back to login',
                          style: TextStyle(color: AppTheme.accent),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
