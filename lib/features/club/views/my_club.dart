import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:rivals/core/models/club_model.dart';
import 'package:rivals/core/services/seed_club.dart';
import 'package:rivals/core/theme/app_theme.dart';
import 'package:rivals/features/auth/provider/auth_provider.dart';
import 'package:rivals/features/club/views/club_details.dart';
import 'package:rivals/shared/app_bar.dart';

class MyClub extends StatefulWidget {
  const MyClub({super.key});

  @override
  State<MyClub> createState() => _MyClubState();
}

class _MyClubState extends State<MyClub> {
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (auth.userData == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // ── Wait for club to be selected ──────────────────────────
    if (auth.clubId.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // this is used to filter out current user club and display for others
    final otherClubs = clubs
        .where((c) => c['shortName'] != auth.clubId)
        .toList();

    final myClub = clubs.firstWhere(
      (c) => c['shortName'] == auth.clubId,
      orElse: () => {},
    );
    final hasBadge =
        myClub['badgeUrl'] != null && myClub['badgeUrl'].toString().isNotEmpty;

    return Scaffold(
      appBar: CustomAppBar(
        backButton: false,
        showLogo: true,
        actions: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: context.cs.outline, width: 1),
              color: context.cs.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Iconsax.notification),
          ),
          SizedBox(width: 15),
          Container(
            margin: EdgeInsets.only(right: 20),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: context.cs.outline, width: 1),
              color: context.cs.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Iconsax.search_favorite_1),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 20),
            child: Text('Your community'),
          ),
          SizedBox(height: 10),
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ClubDetails(clubModel: ClubModel.fromMap(myClub)),
                ),
              );
            },
            contentPadding: const EdgeInsets.only(left: 20, right: 20),
            leading: hasBadge
                ? Image.network(
                    myClub['badgeUrl'],
                    width: 60,
                    height: 60,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => CircleAvatar(
                      radius: 30,
                      child: Text(
                        auth.clubId,
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  )
                : CircleAvatar(
                    radius: 30,
                    child: Text(
                      auth.clubId,
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),

            title: Row(
              children: [
                Text(auth.clubName, style: context.tt.titleMedium),
                SizedBox(width: 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
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
                final members = snapshot.data?.get('members') ?? 0;
                return Text(
                  // '$members members  ·  ${auth.clubNickname}',
                  "$members members  ·  ${myClub['nickname'] ?? ''}",
                  style: context.tt.bodySmall,
                );
              },
            ),
            trailing: Icon(Icons.navigate_next),
          ),
          Divider(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
            child: Text('Explore clubs  ${otherClubs.length}'),
          ),
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              primary: false,
              itemCount: otherClubs.length,
              itemBuilder: (context, index) {
                final club = otherClubs[index];
                final hasBadge =
                    club['badgeUrl'] != null &&
                    club['badgeUrl'].toString().isNotEmpty;

                return ListTile(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) =>
                    //         ClubDetails(clubModel: ClubModel.fromMap(club)),
                    //   ),
                    // );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ClubHubPage(club: ClubModel.fromMap(club)),
                      ),
                    );
                  },
                  contentPadding: const EdgeInsets.only(
                    left: 20,
                    bottom: 20,
                    right: 20,
                  ),
                  // leading: Image.network(club["badgeUrl"] ?? ''),
                  leading: hasBadge
                      ? Image.network(
                          club['badgeUrl'],
                          width: 40,
                          height: 40,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => CircleAvatar(
                            radius: 20,
                            child: Text(
                              club['shortName'] ?? '',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        )
                      : CircleAvatar(
                          radius: 20,
                          child: Text(
                            club['shortName'] ?? '',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                  title: Text(club["name"] ?? ''),
                  // subtitle: Text('data'),
                  // In the ListTile subtitle for other clubs
                  subtitle: StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('clubStats')
                        .doc(club['shortName'])
                        .snapshots(),
                    builder: (context, snapshot) {
                      final members = snapshot.data?.exists == true
                          ? snapshot.data!.get('members') ?? 0
                          : 0;
                      return Text(
                        '$members members · ${club['nickname'] ?? ''}',
                        style: context.tt.bodySmall,
                      );
                    },
                  ),
                  trailing: Icon(Icons.navigate_next),
                );
              },
              separatorBuilder: (context, index) {
                return Divider();
              },
            ),
          ),
        ],
      ),
    );
  }
}
