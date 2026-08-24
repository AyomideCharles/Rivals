import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:rivals/core/services/auth_service.dart';
import 'package:rivals/shared/app_bar.dart';
import 'package:rivals/shared/app_button.dart';
import 'package:rivals/shared/app_textfield.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _currentPassword = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  bool obsureCurrentPassword = true;
  bool obsureNewPassword = true;
  bool obsureConfirmPassword = true;

  @override
  void dispose() {
    _currentPassword.dispose();
    _newPassword.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  toogleObsureCurrentPassword() {
    obsureCurrentPassword = !obsureCurrentPassword;
    setState(() {});
  }

  toogleObsureNewPassword() {
    obsureNewPassword = !obsureNewPassword;
    setState(() {});
  }

  toogleObsureConfirmPassword() {
    obsureConfirmPassword = !obsureConfirmPassword;
    setState(() {});
  }

  Future<void> changePassword() async {
    if (_currentPassword.text.isEmpty ||
        _newPassword.text.isEmpty ||
        _confirmPassword.text.isEmpty) {
      SmartDialog.showToast('Fill in all fields');
      return;
    }

    if (_newPassword.text != _confirmPassword.text) {
      SmartDialog.showToast('New passwords do not match');
      return;
    }

    if (_newPassword.text.length < 6) {
      SmartDialog.showToast('Password must be at least 6 characters');
      return;
    }

    SmartDialog.showLoading(msg: 'Updating password...');
    final success = await context.read<AuthProvider>().changePassword(
      currentPassword: _currentPassword.text,
      newPassword: _newPassword.text,
    );
    SmartDialog.dismiss();

    if (success && mounted) {
      SmartDialog.showToast('Password updated successfully');
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Change Password'),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              controller: _currentPassword,
              hint: 'Current password',
              obscureText: obsureCurrentPassword,
              suffixIcon: GestureDetector(
                onTap: () {
                  toogleObsureCurrentPassword();
                },
                child: Icon(
                  obsureCurrentPassword ? Icons.visibility_off : Iconsax.eye,
                ),
              ),
            ),
            const SizedBox(height: 30),
            AppTextField(
              controller: _newPassword,
              hint: 'New password',
              obscureText: obsureNewPassword,
              suffixIcon: GestureDetector(
                onTap: () {
                  toogleObsureNewPassword();
                },
                child: Icon(
                  obsureNewPassword ? Icons.visibility_off : Iconsax.eye,
                ),
              ),
            ),
            const SizedBox(height: 30),
            AppTextField(
              controller: _confirmPassword,
              hint: 'Confirm new password',
              obscureText: obsureConfirmPassword,
              suffixIcon: GestureDetector(
                onTap: () {
                  toogleObsureConfirmPassword();
                },
                child: Icon(
                  obsureConfirmPassword ? Icons.visibility_off : Iconsax.eye,
                ),
              ),
            ),
            const SizedBox(height: 70),
            AppButton(label: 'Update Password', onPressed: changePassword),
          ],
        ),
      ),
    );
  }
}
