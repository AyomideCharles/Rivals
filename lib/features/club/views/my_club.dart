import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:rivals/core/models/club_model.dart';
import 'package:rivals/core/services/club_service.dart';
import 'package:rivals/core/theme/app_theme.dart';
import 'package:rivals/features/auth/provider/auth_provider.dart';
import 'package:rivals/features/club/views/club_details.dart';
import 'package:rivals/shared/app_bar.dart';

class MyClub extends StatefulWidget {
  const MyClub({super.key});

  @override
  State<MyClub> createState() => _MyClubState();
}

class _MyClubState extends State<MyClub> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _leagues = [
    'Premier League',
    'La Liga',
    'Serie A',
    'Bundesliga',
    'Ligue 1',
    'Primeira Liga',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _leagues.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (auth.userData == null || auth.clubId.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: CustomAppBar(
        backButton: false,
        showLogo: true,
        actions: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: context.cs.outline, width: 1),
              color: context.cs.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Iconsax.notification),
          ),
          const SizedBox(width: 15),
          Container(
            margin: const EdgeInsets.only(right: 20),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: context.cs.outline, width: 1),
              color: context.cs.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Iconsax.search_favorite_1),
          ),
        ],
      ),
      body: StreamBuilder<List<ClubModel>>(
        stream: ClubService.getAllClubs(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final allClubs = snapshot.data!;
          final myClub = allClubs.firstWhere(
            (c) => c.shortName == auth.clubId,
            orElse: () => ClubModel.empty(),
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(height: 16),

              const Padding(
                padding: EdgeInsets.only(left: 20, top: 20),
                child: Text('Your community'),
              ),
              const SizedBox(height: 10),
              ListTile(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ClubDetails(clubModel: myClub),
                  ),
                ),
                contentPadding: const EdgeInsets.only(left: 20, right: 20),
                leading: myClub.hasBadge
                    ? Image.network(
                        myClub.badgeUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => CircleAvatar(
                          radius: 30,
                          child: Text(
                            myClub.shortName,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      )
                    : CircleAvatar(
                        radius: 30,
                        child: Text(
                          myClub.shortName,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                title: Row(
                  children: [
                    Text(myClub.name, style: context.tt.titleMedium),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: context.cs.outline, width: 1),
                        color: context.cs.surface,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text('Your club', style: context.tt.labelMedium),
                    ),
                  ],
                ),
                subtitle: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('clubStats')
                      .doc(auth.clubId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    final members = snapshot.data?.exists == true
                        ? snapshot.data!.get('members') ?? 0
                        : 0;
                    return Text(
                      '$members members  ·  ${myClub.nickname}',
                      style: context.tt.bodySmall,
                    );
                  },
                ),
                trailing: const Icon(Icons.navigate_next),
              ),

              const Divider(height: 16),
              const Padding(
                padding: EdgeInsets.only(left: 20, top: 16, bottom: 8),
                child: Text('Explore clubs'),
              ),

              TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                indicatorColor: AppTheme.accent,
                labelColor: context.cs.onSurface,
                unselectedLabelColor: context.cs.onSurface.withOpacity(0.4),
                dividerColor: Colors.transparent,
                labelStyle: context.tt.labelMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                tabs: _leagues.map((l) => Tab(text: l)).toList(),
              ),

              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: _leagues.map((league) {
                    final leagueClubs = allClubs
                        .where(
                          (c) =>
                              c.league == league && c.shortName != auth.clubId,
                        )
                        .toList();

                    if (leagueClubs.isEmpty) {
                      return const Center(child: Text('No clubs found'));
                    }

                    return ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: leagueClubs.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        final club = leagueClubs[index];
                        return ListTile(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ClubDetails(clubModel: club),
                            ),
                          ),
                          contentPadding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            bottom: 8,
                          ),
                          leading: club.hasBadge
                              ? Image.network(
                                  club.badgeUrl,
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) => CircleAvatar(
                                    radius: 20,
                                    child: Text(
                                      club.shortName,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                )
                              : CircleAvatar(
                                  radius: 20,
                                  child: Text(
                                    club.shortName,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                          title: Text(club.name),
                          subtitle: StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('clubStats')
                                .doc(club.shortName)
                                .snapshots(),
                            builder: (context, snapshot) {
                              final members = snapshot.data?.exists == true
                                  ? snapshot.data!.get('members') ?? 0
                                  : 0;
                              return Text(
                                '$members members · ${club.nickname}',
                                style: context.tt.bodySmall,
                              );
                            },
                          ),
                          trailing: const Icon(Icons.navigate_next),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
