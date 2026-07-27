import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rivals/core/models/club_model.dart';
import 'package:rivals/core/services/auth_service.dart';
import 'package:rivals/core/theme/app_theme.dart';
import 'package:rivals/features/auth/widgets/splash_screen.dart';
import 'package:rivals/features/club/widgets/club_fixtures_tab.dart';
import 'package:rivals/features/club/widgets/club_news_tab.dart';
import 'package:rivals/features/club/widgets/club_wall_tab.dart';
import 'package:rivals/shared/app_button.dart';

class ClubDetails extends StatefulWidget {
  final ClubModel clubModel;
  const ClubDetails({super.key, required this.clubModel});

  @override
  State<ClubDetails> createState() => _ClubDetailsState();
}

class _ClubDetailsState extends State<ClubDetails>
    with SingleTickerProviderStateMixin {
  static const clubTabs = ['News', 'Wall', 'Fixtures', 'Top Fans'];
  int selectedTab = 0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: clubTabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget clubStat(String value, String label) => Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: context.cs.onSurface,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF7D8794),
            letterSpacing: 0.6,
          ),
        ),
      ],
    ),
  );
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: context.bgColor,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            pinned: true,
            expandedHeight: 200,
            backgroundColor: widget.clubModel.color,
            foregroundColor: widget.clubModel.ink,
            elevation: 0,
            leading: const BackButton(),
            flexibleSpace: FlexibleSpaceBar(
              background: Banner(clubModel: widget.clubModel),
              collapseMode: CollapseMode.parallax,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
              child: Column(
                children: [
                  StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('clubStats')
                        .doc(widget.clubModel.shortName)
                        .snapshots(),
                    builder: (context, snapshot) {
                      final members = snapshot.data?.exists == true
                          ? snapshot.data!.get('members') ?? 0
                          : 0;
                      return Row(
                        children: [
                          clubStat(members.toString(), 'Members'),
                          clubStat('4.2K', 'Posts today'),
                          clubStat('#3', 'Banter rank'),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  if (auth.clubId == widget.clubModel.shortName)
                    AppButton2(label: 'Joined', onPressed: () {}),
                ],
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _TabHeader(
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
                tabs: clubTabs.map((t) => Tab(text: t)).toList(),
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            SingleChildScrollView(child: ClubNewsTab(club: widget.clubModel)),
            ClubWallTab(club: widget.clubModel),
            ClubFixturesTab(),
            ClubFixturesTab(),
          ],
        ),
      ),
    );
  }
}

class Banner extends StatelessWidget {
  final ClubModel clubModel;
  const Banner({super.key, required this.clubModel});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                clubModel.color,
                Color.alphaBlend(
                  clubModel.color.withOpacity(0.55),
                  const Color(0xFF14161B),
                ),
              ],
            ),
          ),
        ),
        // crest watermark
        Positioned(
          right: -20,
          bottom: -10,
          child: Opacity(
            opacity: 0.22,
            child: ShieldCrest(
              size: 150,
              color: clubModel.color,
              ink: clubModel.ink,
              label: clubModel.shortName,
            ),
          ),
        ),
        // bottom fade into page bg
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.center,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Color(0xFF14161B)],
            ),
          ),
        ),
        Positioned(
          left: 20,
          bottom: 18,
          child: Row(
            children: [
              Hero(
                tag: 'club-badge-${clubModel.shortName}',
                child: clubModel.badgeUrl.isNotEmpty
                    ? Image.network(
                        clubModel.badgeUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return ShieldCrest(
                            size: 60,
                            color: clubModel.color,
                            ink: clubModel.ink,
                            label: clubModel.shortName,
                          );
                        },
                      )
                    : ShieldCrest(
                        size: 60,
                        color: clubModel.color,
                        ink: clubModel.ink,
                        label: clubModel.shortName,
                      ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Hero(
                    tag: 'club-name-${clubModel.shortName}',
                    child: Material(
                      type: MaterialType.transparency,
                      child: Text(
                        clubModel.name,
                        style: GoogleFonts.archivo(
                          fontWeight: FontWeight.w900,
                          fontSize: 24,
                          color: clubModel.ink,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    clubModel.nickname,
                    style: TextStyle(
                      color: clubModel.ink.withOpacity(0.85),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Club {
  final String name, short, nick, members;
  final Color color, ink;
  const Club({
    required this.name,
    required this.short,
    required this.nick,
    required this.members,
    required this.color,
    this.ink = Colors.white,
  });
}

class NewsItem {
  final String cat, title, excerpt, source, time;
  final bool lead, image;
  const NewsItem({
    required this.cat,
    required this.title,
    required this.excerpt,
    required this.source,
    required this.time,
    this.lead = false,
    this.image = false,
  });
}

class _TabHeader extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  const _TabHeader(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return ColoredBox(color: context.bgColor, child: tabBar);
  }

  @override
  bool shouldRebuild(covariant _TabHeader old) => false;
}
