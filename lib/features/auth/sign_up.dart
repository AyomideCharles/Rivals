import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:rivals/core/theme/app_theme.dart';
import 'package:rivals/features/auth/login.dart';
import 'package:rivals/features/auth/provider/auth_provider.dart';
import 'package:rivals/features/auth/league_selection.dart';
import 'package:rivals/shared/app_bar.dart';
import 'package:rivals/shared/app_button.dart';
import 'package:rivals/shared/app_textfield.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController displayNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    displayNameController.dispose();
    super.dispose();
  }

  toggleObscurePassword() {
    obscurePassword = !obscurePassword;
    setState(() {});
  }

  Future<void> signUp(BuildContext context) async {
    try {
      if (!formKey.currentState!.validate()) return;
      SmartDialog.showLoading();
      final authProvider = context.read<AuthProvider>();
      final success = await authProvider.signUp(
        emailController.text,
        passwordController.text,
        displayNameController.text,
      );
      if (success && context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LeagueSelection()),
        );
      }
    } catch (e) {
      SmartDialog.showToast(e.toString());
    } finally {
      SmartDialog.dismiss();
    }
  }

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
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
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
                    Text(
                      "Set up your fan identity. You'll pick your club next",
                    ),
                    SizedBox(height: 30),
                    Text('DISPLAY NAME', style: context.tt.bodySmall),
                    SizedBox(height: 12),
                    AppTextField(
                      hint: 'e.g. Alex rivera',
                      controller: displayNameController,
                      validator: (String? value) {
                        if (value == '' || value!.isEmpty) {
                          return 'Enter your display name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 30),
                    Text('EMAIL', style: context.tt.bodySmall),
                    SizedBox(height: 12),
                    AppTextField(
                      controller: emailController,
                      hint: 'e.g. you@email.com',
                      prefixIcon: Icon(Icons.mail),
                      validator: (String? value) {
                        if (value == '' || value!.isEmpty) {
                          return 'Enter email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 30),
                    Text('PASSWORD', style: context.tt.bodySmall),
                    SizedBox(height: 12),
                    AppTextField(
                      hint: 'At least 6 characters',
                      obscureText: obscurePassword,
                      controller: passwordController,
                      prefixIcon: Icon(Iconsax.lock),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          toggleObscurePassword();
                        },
                        child: Icon(
                          obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                      validator: (String? value) {
                        if (value == '' || value!.isEmpty) {
                          return 'Enter password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 35),
                    AppButton(
                      label: 'Continue',
                      onPressed: () {
                        signUp(context);
                      },
                    ),
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
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Login()),
                        );
                      },
                      child: Center(
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
        ),
      ),
    );
  }
}
