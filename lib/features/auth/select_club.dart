import 'package:flutter/material.dart';
import 'package:rivals/core/theme/app_theme.dart';
import 'package:rivals/shared/app_logo_text.dart';

class SelectClub extends StatelessWidget {
  const SelectClub({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('FOOTBALL', style: context.tt.bodySmall),
                  SizedBox(width: 25),
                  Text('·', style: context.tt.bodySmall),
                  SizedBox(width: 25),
                  Text('COMMUNITY', style: context.tt.bodySmall),
                  SizedBox(width: 25),
                  Text('·', style: context.tt.bodySmall),
                  SizedBox(width: 25),
                  Text('BANTER', style: context.tt.bodySmall),
                ],
              ),
              SizedBox(height: 25),
              RivalsLogo(size: 55),
              SizedBox(height: 15),
              Text(
                'First pick your league, then find your club and join the community.',
                // style: context.tt.titleMedium,
              ),
              SizedBox(height: 30),
              Text('CHOOSE YOUR CLUB'),
            ],
          ),
        ),
      ),
    );
  }
}
