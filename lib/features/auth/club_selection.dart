import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:rivals/bottom_navigation.dart';
import 'package:rivals/core/services/seed_club.dart';
import 'package:rivals/core/theme/app_theme.dart';
import 'package:rivals/shared/app_bar.dart';
import 'package:rivals/shared/app_button.dart';

class ClubSelection extends StatefulWidget {
  final String title;
  const ClubSelection({super.key, required this.title});

  @override
  State<ClubSelection> createState() => _ClubSelectionState();
}

class _ClubSelectionState extends State<ClubSelection>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  Map<String, dynamic>? selectedClub;

  // Filter local clubs by league from the clubs model
  late final List<Map<String, dynamic>> _leagueClubs = clubs
      .where((c) => c['league'] == widget.title)
      .toList();

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Animation<double> _fadeAnim(int index) {
    final start = (index * 0.12).clamp(0.0, 0.8);
    final end = (start + 0.4).clamp(0.0, 1.0);
    return CurvedAnimation(
      parent: animationController,
      curve: Interval(start, end, curve: Curves.easeOut),
    );
  }

  Animation<Offset> _slideAnim(int index) {
    final start = (index * 0.12).clamp(0.0, 0.8);
    final end = (start + 0.4).clamp(0.0, 1.0);
    return Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(start, end, curve: Curves.easeOutCubic),
      ),
    );
  }

  Future<void> confirmSelection() async {
    if (selectedClub == null) return;
    try {
      SmartDialog.showLoading(msg: 'Joining your club...');
      final uid = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'clubId': selectedClub!['shortName'],
        'clubName': selectedClub!['name'],
        'clubColor': selectedClub!['color'],
        'clubLeague': widget.title,
      });

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const BottomNav()),
          (route) => false,
        );
      }
    } catch (e) {
      SmartDialog.showToast('Something went wrong. Try again.');
    } finally {
      SmartDialog.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.title.toUpperCase()),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Select your club"),
            SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                ),
                itemCount: _leagueClubs.length,
                itemBuilder: (context, index) {
                  final club = _leagueClubs[index];

                  final isSelected =
                      selectedClub?['shortName'] == club['shortName'];
                  return FadeTransition(
                    opacity: _fadeAnim(index),
                    child: SlideTransition(
                      position: _slideAnim(index),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedClub = club;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: context.cs.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              width: isSelected ? 2 : 0,
                              color: isSelected
                                  ? AppTheme.accent
                                  : context.cs.outline,
                            ),
                          ),
                          height: 50,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/manutd.png',
                                width: 40,
                                height: 40,
                              ),
                              SizedBox(height: 10),
                              Text(
                                club['name'] ?? '',
                                textAlign: TextAlign.center,
                                style: context.tt.titleSmall,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            AppButton(
              label: selectedClub == null
                  ? 'Select a club to continue'
                  : 'Continue with ${selectedClub!['name']}',
              onPressed: confirmSelection,
            ),
          ],
        ),
      ),
    );
  }
}
