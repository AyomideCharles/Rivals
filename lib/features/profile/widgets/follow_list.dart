import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rivals/core/services/follow_service.dart';
import 'package:rivals/core/theme/app_theme.dart';
import 'package:rivals/features/home/widgets/users_profile.dart';
import 'package:rivals/shared/app_bar.dart';

enum FollowListType { followers, following }

class FollowList extends StatelessWidget {
  final String userId;
  final FollowListType type;

  const FollowList({super.key, required this.userId, required this.type});

  @override
  Widget build(BuildContext context) {
    final isFollowers = type == FollowListType.followers;
    final field = isFollowers ? 'followingId' : 'followerId';
    final otherField = isFollowers ? 'followerId' : 'followingId';

    return Scaffold(
      appBar: CustomAppBar(title: isFollowers ? 'Followers' : 'Following'),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('follows')
            .where(field, isEqualTo: userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return Center(
              child: Text(
                isFollowers ? 'No followers yet' : 'Not following anyone yet',
                style: context.tt.bodyMedium,
              ),
            );
          }

          final userIds = docs.map((doc) => doc[otherField] as String).toList();

          return FutureBuilder<Map<String, Map<String, dynamic>>>(
            future: FollowService.fetchUsersByIds(userIds),
            builder: (context, userSnapshot) {
              if (!userSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final usersMap = userSnapshot.data!;

              return Column(
                children: [
                  Divider(height: 16),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: userIds.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final targetUserId = userIds[index];
                        final data = usersMap[targetUserId] ?? {};
                        final displayName = data['displayName'] ?? '';
                        final clubName = data['clubName'] ?? '';
                        final clubLeague = data['clubLeague'] ?? '';
                        final photoUrl = data['photoUrl'] ?? '';

                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 4,
                          ),
                          leading: GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => UsersProfile(
                                  userId: targetUserId,
                                  displayName: displayName,
                                  clubName: clubName,
                                  clubLeague: clubLeague,
                                  profileImageUrl: '',
                                ),
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 22,
                              backgroundImage: photoUrl.isNotEmpty
                                  ? NetworkImage(photoUrl)
                                  : null,
                              child: photoUrl.isEmpty
                                  ? Text(
                                      displayName.isNotEmpty
                                          ? displayName[0].toUpperCase()
                                          : '?',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                          title: GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => UsersProfile(
                                  userId: targetUserId,
                                  displayName: displayName,
                                  clubName: clubName,
                                  clubLeague: clubLeague,
                                  profileImageUrl: '',
                                ),
                              ),
                            ),
                            child: Text(
                              '@$displayName',
                              style: context.tt.bodySmall?.copyWith(
                                color: context.cs.onSurface,
                              ),
                            ),
                          ),
                          subtitle: Text(
                            '$clubName',
                            style: context.tt.bodySmall,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
