import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';
import 'package:rivals/core/services/auth_service.dart';
import 'package:rivals/core/theme/app_theme.dart';
import 'package:rivals/shared/app_bar.dart';
import 'package:rivals/shared/app_button.dart';
import 'package:rivals/shared/app_textfield.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController emailController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> sendReset() async {
    if (emailController.text.trim().isEmpty) {
      SmartDialog.showToast('Enter your email');
      return;
    }

    SmartDialog.showLoading(msg: 'Sending reset email...');
    final success = await context.read<AuthProvider>().forgotPassword(
      emailController.text,
    );
    SmartDialog.dismiss();

    if (success && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => _SuccessState()),
      );
    }
  }

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
                  controller: emailController,
                  hint: 'e.g. you@email.com',
                  prefixIcon: Icon(Icons.mail),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 35),
                AppButton(
                  label: 'Send reset link',
                  onPressed: () {
                    sendReset();
                  },
                ),
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

class _SuccessState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.mark_email_read_outlined,
            size: 72,
            color: Colors.green,
          ),
          const SizedBox(height: 24),
          Text(
            'Check your email',
            style: context.tt.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'We\'ve sent a password reset link to your email. Check your inbox and follow the instructions.',
            style: context.tt.bodyMedium?.copyWith(
              color: context.cs.onSurface.withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          AppButton(
            label: 'Back to Login',
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
