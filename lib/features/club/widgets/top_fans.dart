import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rivals/core/models/club_model.dart';
import 'package:rivals/core/models/top_fan_model.dart';
import 'package:rivals/core/services/club_service.dart';
import 'package:rivals/core/theme/app_theme.dart';

class TopFansTab extends StatelessWidget {
  final ClubModel club;
  const TopFansTab({super.key, required this.club});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TopFanModel>>(
      future: ClubService.getTopFans(club.shortName),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.emoji_events_outlined,
                  size: 48,
                  color: context.cs.onSurface.withValues(alpha: 0.3),
                ),
                const SizedBox(height: 12),
                Text(
                  'No top fans yet',
                  style: context.tt.bodyMedium?.copyWith(
                    color: context.cs.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          );
        }

        final fans = snapshot.data!;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // podium — only show if 3 or more fans
            if (fans.length >= 3)
              _Podium(fans: fans.take(3).toList())
            else
              // show simple list if less than 3
              ...fans.take(fans.length).toList().asMap().entries.map((entry) {
                final rank = entry.key + 1;
                final fan = entry.value;
                return _FanTile(fan: fan, rank: rank);
              }),

            const SizedBox(height: 24),

            // rest of the list — rank 4 and below
            if (fans.length >= 3)
              ...fans.skip(3).toList().asMap().entries.map((entry) {
                final rank = entry.key + 4;
                final fan = entry.value;
                return _FanTile(fan: fan, rank: rank);
              }),
          ],
        );
      },
    );
  }
}

// ── Podium — top 3 ────────────────────────────────────────────────────────────
class _Podium extends StatelessWidget {
  final List<TopFanModel> fans;
  const _Podium({required this.fans});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 2nd place
        _PodiumItem(fan: fans[1], rank: 2, height: 80),
        const SizedBox(width: 12),
        // 1st place
        _PodiumItem(fan: fans[0], rank: 1, height: 110),
        const SizedBox(width: 12),
        // 3rd place
        _PodiumItem(fan: fans[2], rank: 3, height: 60),
      ],
    );
  }
}

class _PodiumItem extends StatelessWidget {
  final TopFanModel fan;
  final int rank;
  final double height;
  const _PodiumItem({
    required this.fan,
    required this.rank,
    required this.height,
  });

  Color get _rankColor {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700); // gold
      case 2:
        return const Color(0xFFC0C0C0); // silver
      case 3:
        return const Color(0xFFCD7F32); // bronze
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // avatar
        Stack(
          alignment: Alignment.topRight,
          children: [
            fan.profileImageUrl.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.network(
                      fan.profileImageUrl,
                      width: rank == 1 ? 60 : 48,
                      height: rank == 1 ? 60 : 48,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return CircleAvatar(
                          radius: rank == 1 ? 30 : 24,
                          child: Text(
                            fan.displayName.isNotEmpty
                                ? fan.displayName[0].toUpperCase()
                                : '?',
                            style: TextStyle(fontSize: rank == 1 ? 20 : 16),
                          ),
                        );
                      },
                    ),
                  )
                : CircleAvatar(
                    radius: rank == 1 ? 30 : 24,
                    child: Text(
                      fan.displayName.isNotEmpty
                          ? fan.displayName[0].toUpperCase()
                          : '?',
                      style: TextStyle(fontSize: rank == 1 ? 20 : 16),
                    ),
                  ),
            // crown for 1st
            if (rank == 1)
              const Positioned(
                top: -8,
                right: -4,
                child: Text('👑', style: TextStyle(fontSize: 16)),
              ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          '@${fan.displayName}',
          style: context.tt.titleSmall,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          '${fan.score} pts',
          style: TextStyle(
            fontSize: 11,
            color: _rankColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),

        // podium block
        Container(
          width: rank == 1 ? 90 : 72,
          height: height,
          decoration: BoxDecoration(
            color: _rankColor.withValues(alpha: 0.15),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            border: Border.all(color: _rankColor.withValues(alpha: 0.4)),
          ),
          alignment: Alignment.center,
          child: Text(
            '#$rank',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: _rankColor,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Fan tile — rank 4 and below ───────────────────────────────────────────────
class _FanTile extends StatelessWidget {
  final TopFanModel fan;
  final int rank;
  const _FanTile({required this.fan, required this.rank});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.cs.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.cs.outline),
      ),
      child: Row(
        children: [
          // rank number
          SizedBox(
            width: 28,
            child: Text(
              '#$rank',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: context.cs.onSurface.withValues(alpha: 0.4),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // avatar
          fan.profileImageUrl.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    fan.profileImageUrl,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                )
              : CircleAvatar(
                  radius: 20,
                  child: Text(
                    fan.displayName.isNotEmpty
                        ? fan.displayName[0].toUpperCase()
                        : '?',
                  ),
                ),
          const SizedBox(width: 12),

          // name + stats
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('@${fan.displayName}', style: context.tt.labelMedium),
                const SizedBox(height: 2),
                Row(
                  children: [
                    _StatChip(
                      label: '${fan.posts} posts',
                      icon: Icons.article_outlined,
                    ),
                    const SizedBox(width: 8),
                    _StatChip(
                      label: '${fan.likesReceived} likes',
                      icon: Icons.thumb_up_alt_outlined,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // score
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${fan.score}',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.accent,
                ),
              ),
              Text(
                'pts',
                style: context.tt.bodySmall?.copyWith(
                  color: context.cs.onSurface.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final IconData icon;
  const _StatChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 12,
          color: context.cs.onSurface.withValues(alpha: 0.4),
        ),
        const SizedBox(width: 3),
        Text(
          label,
          style: context.tt.bodySmall?.copyWith(
            color: context.cs.onSurface.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }
}
