import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rivals/core/theme/app_theme.dart';
import 'package:rivals/shared/app_bar.dart';
import 'package:rivals/shared/app_button.dart';
import 'package:rivals/shared/app_textfield.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  Widget thirdPartySignUp(String title, String image) {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        border: Border.all(color: context.cs.outline, width: 1),
        color: context.cs.surface,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, width: 30, height: 30),
          SizedBox(width: 10),
          Text(title, style: context.tt.titleSmall),
        ],
      ),
    );
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
                Text('Create account', style: context.tt.displayLarge),
                SizedBox(height: 4),
                Text("Set up your fan identity. You'll pick your club next"),
                SizedBox(height: 30),
                Text('DISPLAY NAME', style: context.tt.bodySmall),
                SizedBox(height: 12),
                AppTextField(hint: 'e.g. Alex rivera'),
                SizedBox(height: 30),
                Text('EMAIL', style: context.tt.bodySmall),
                SizedBox(height: 12),
                AppTextField(
                  hint: 'e.g. you@email.com',
                  prefixIcon: Icon(Icons.mail),
                ),
                SizedBox(height: 30),
                Text('PASSWORD', style: context.tt.bodySmall),
                SizedBox(height: 12),
                AppTextField(
                  hint: 'At least 6 characters',
                  obscureText: true,
                  prefixIcon: Icon(Iconsax.lock),
                  suffixIcon: Icon(Iconsax.eye),
                ),
                SizedBox(height: 35),
                AppButton(label: 'Continue', onPressed: () {}),
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(flex: 4, child: Divider()),
                    SizedBox(width: 20),
                    Text('OR'),
                    SizedBox(width: 20),
                    Expanded(flex: 4, child: Divider()),
                  ],
                ),
                SizedBox(height: 15),
                thirdPartySignUp(
                  'Continue with Apple',
                  'assets/images/apple_logo.png',
                ),
                SizedBox(height: 15),
                thirdPartySignUp(
                  'Continue with Google',
                  'assets/images/google_logo.png',
                ),
                SizedBox(height: 30),
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: context.tt.titleSmall,
                      children: [
                        TextSpan(text: 'Already a member? '),
                        TextSpan(
                          text: 'Login',
                          style: TextStyle(color: AppTheme.accent),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  'By coming you agree to RIVALS terms and the Fan Conduct Code. Banter hard, play fair',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
