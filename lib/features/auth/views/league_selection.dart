import 'package:flutter/material.dart';
import 'package:rivals/core/services/club_service.dart';
import 'package:rivals/core/theme/app_theme.dart';
import 'package:rivals/features/auth/views/club_selection.dart';
import 'package:rivals/shared/app_logo_text.dart';

class LeagueSelection extends StatefulWidget {
  const LeagueSelection({super.key});

  @override
  State<LeagueSelection> createState() => _LeagueSelectionState();
}

class _LeagueSelectionState extends State<LeagueSelection>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
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
              Row(
                children: [
                  Text('Seclet your club'),
                  SizedBox(width: 10),
                  Icon(Icons.navigate_next),
                ],
              ),
              SizedBox(height: 30),
              Expanded(
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: ClubService.getLeagues(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final leagues = snapshot.data!;

                    return GridView.builder(
                      padding: EdgeInsets.zero,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 20,
                            childAspectRatio: 1.1,
                          ),
                      itemCount: leagues.length,
                      itemBuilder: (context, index) {
                        final league = leagues[index];
                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ClubSelection(title: league['name']),
                            ),
                          ),
                          child: FadeTransition(
                            opacity: _fadeAnim(index),
                            child: SlideTransition(
                              position: _slideAnim(index),
                              child: Container(
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: context.cs.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: context.cs.outline),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ClipRRect(
                                          child: Image.network(
                                            league['badgeUrl'] ?? '',
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) =>
                                                const Icon(
                                                  Icons.sports_soccer,
                                                  size: 40,
                                                ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: context.cs.surface,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            border: Border.all(
                                              color: context.cs.outline,
                                            ),
                                          ),
                                          child: Text(
                                            '${league['numberOfClubs']} clubs',
                                            style: context.tt.labelMedium,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      league['name'] ?? '',
                                      style: context.tt.titleMedium,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(league['country'] ?? ''),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
