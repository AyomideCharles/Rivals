import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rivals/features/auth/provider/auth_provider.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SafeArea(
          child: Column(
            children: [
              Text(auth.user?.displayName ?? ''),
              Text(auth.user?.email ?? ''),
              Text(auth.clubName),
            ],
          ),
        ),
      ),
    );
  }
}
