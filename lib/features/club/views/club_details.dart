import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rivals/core/models/club_model.dart';
import 'package:rivals/core/theme/app_theme.dart';
import 'package:rivals/features/auth/widgets/splash_screen.dart';
import 'package:rivals/features/club/widgets/sliver_tab.dart';
import 'package:rivals/shared/app_button.dart';

class ClubDetails extends StatefulWidget {
  final ClubModel clubModel;
  const ClubDetails({super.key, required this.clubModel});

  @override
  State<ClubDetails> createState() => _ClubDetailsState();
}

class _ClubDetailsState extends State<ClubDetails> {
  static const clubTabs = ['News', 'Wall', 'Fixtures', 'Top Fans'];
  int selectedTab = 0;

  Widget clubStat(String value, String label) => Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFFF7F8F9),
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
    return Scaffold(
      // backgroundColor: Color(0xFF14161B),
      backgroundColor: context.bgColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 200,
            backgroundColor: widget.clubModel.color,
            foregroundColor: widget.clubModel.ink,
            elevation: 0,
            leading: const BackButton(),
            title: Text(
              widget.clubModel.name,
              style: GoogleFonts.archivo(
                fontWeight: FontWeight.w800,
                fontSize: 18,
                color: widget.clubModel.ink,
              ),
            ),
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
                  Row(
                    children: [
                      clubStat(widget.clubModel.members.toString(), 'Members'),
                      clubStat('4.2K', 'Posts today'),
                      clubStat('#3', 'Banter rank'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  AppButton(label: 'Joined', onPressed: () {}),
                ],
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: TabsHeader(
              tabs: clubTabs,
              selected: selectedTab,
              onTap: (i) => setState(() => selectedTab = i),
            ),
          ),

          if (selectedTab == 0)
            SliverList(
              delegate: SliverChildBuilderDelegate((context, i) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text('data'),
                );
              }),
            )
          else
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(48),
                child: Center(
                  child: Text(
                    '${clubTabs[selectedTab]} coming soon',
                    style: context.tt.labelMedium,
                  ),
                ),
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
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
                // club.color,
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
        // crest + name lockup
        Positioned(
          left: 20,
          bottom: 18,
          child: Row(
            children: [
              clubModel.badgeUrl.isNotEmpty
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

              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    clubModel.name,
                    style: GoogleFonts.archivo(
                      fontWeight: FontWeight.w900,
                      fontSize: 24,
                      color: clubModel.ink,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Text(
                    'The ${clubModel.nickname}',
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

// ---- minimal club model (map from your data layer) ----
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

// ============================================================
// Club Hub
// ============================================================
class ClubHubPage extends StatefulWidget {
  final ClubModel club;
  const ClubHubPage({super.key, required this.club});

  @override
  State<ClubHubPage> createState() => _ClubHubPageState();
}

class _ClubHubPageState extends State<ClubHubPage> {
  static const _tabs = ['News', 'Wall', 'Fixtures', 'Top Fans'];
  int _tab = 0;
  bool _joined = false;

  // palette
  static const _bg = Color(0xFF14161B);
  static const _card = Color(0xFF23262D);
  static const _text = Color(0xFFF7F8F9);
  static const _faint = Color(0xFF7D8794);
  static const _accent = Color(0xFFB6F24D);

  List<NewsItem> get _news => [
    NewsItem(
      lead: true,
      image: true,
      cat: 'TRANSFERS',
      source: 'Fabrizio Romano',
      time: '2h',
      title: 'Here we go: ${widget.club.name} close on €60m deadline-day swoop',
      excerpt:
          'Personal terms agreed and medical booked. The ${widget.club.nickname} have moved decisively for their top target.',
    ),
    NewsItem(
      cat: 'MATCH REPORT',
      source: 'BBC Sport',
      time: '5h',
      title:
          'Player ratings: who shone as ${widget.club.name} ground out a win',
      excerpt: 'A battling three points — we rate every performer.',
    ),
    NewsItem(
      cat: 'INJURY NEWS',
      source: 'Sky Sports',
      time: '8h',
      image: true,
      title:
          'Boost for the ${widget.club.nickname} as key man returns to training',
      excerpt: 'The manager confirmed the midfielder is ahead of schedule.',
    ),
    NewsItem(
      cat: 'ACADEMY',
      source: 'The Athletic',
      time: '1d',
      image: true,
      title:
          'Meet the 17-year-old ${widget.club.nickname} fans are raving about',
      excerpt: 'Three goals in two games for the U18s.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final club = widget.club;

    return Scaffold(
      backgroundColor: _bg,
      body: CustomScrollView(
        slivers: [
          // ---- collapsing club banner ----
          SliverAppBar(
            pinned: true,
            expandedHeight: 200,
            backgroundColor: club.color,
            foregroundColor: club.ink,
            elevation: 0,
            leading: const BackButton(),
            title: Text(
              club.name,
              style: GoogleFonts.archivo(
                fontWeight: FontWeight.w800,
                fontSize: 18,
                color: club.ink,
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: _Banner(club: club),
              collapseMode: CollapseMode.parallax,
            ),
          ),

          // ---- stats + join button ----
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
              child: Column(
                children: [
                  Row(
                    children: [
                      _stat(club.members.toString(), 'Members'),
                      _stat('4.2K', 'Posts today'),
                      _stat('#3', 'Banter rank'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: _joined
                        ? OutlinedButton(
                            onPressed: () => setState(() => _joined = false),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: _text,
                              side: const BorderSide(color: Color(0xFF2C3038)),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text('✓ Joined'),
                          )
                        : ElevatedButton(
                            onPressed: () => setState(() => _joined = true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _accent,
                              foregroundColor: const Color(0xFF10210A),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Text(
                              'Join the ${club.nickname}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),

          // ---- pinned tab bar ----
          SliverPersistentHeader(
            pinned: true,
            delegate: _TabsHeader(
              tabs: _tabs,
              selected: _tab,
              onTap: (i) => setState(() => _tab = i),
            ),
          ),

          // ---- tab content ----
          if (_tab == 0)
            _newsSliver(club)
          else
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(48),
                child: Center(
                  child: Text(
                    '${_tabs[_tab]} coming soon',
                    style: const TextStyle(color: _faint),
                  ),
                ),
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  // ---- news as a sliver list ----
  Widget _newsSliver(ClubModel club) {
    final items = _news;
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, i) {
        final a = items[i];
        return a.lead
            ? _LeadStory(club: club, a: a)
            : _NewsRow(club: club, a: a);
      }, childCount: items.length),
    );
  }

  Widget _stat(String value, String label) => Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: _text,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            color: _faint,
            letterSpacing: 0.6,
          ),
        ),
      ],
    ),
  );
}

// ============================================================
// Banner
// ============================================================
class _Banner extends StatelessWidget {
  final ClubModel club;
  const _Banner({required this.club});

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
                club.color,
                Color.alphaBlend(
                  club.color.withOpacity(0.55),
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
              color: club.color,
              ink: club.ink,
              label: club.shortName,
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
        // crest + name lockup
        Positioned(
          left: 20,
          bottom: 18,
          child: Row(
            children: [
              ShieldCrest(
                size: 60,
                color: club.color,
                ink: club.ink,
                label: club.shortName,
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    club.name,
                    style: GoogleFonts.archivo(
                      fontWeight: FontWeight.w900,
                      fontSize: 24,
                      color: club.ink,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Text(
                    'The ${club.nickname}',
                    style: TextStyle(
                      color: club.ink.withOpacity(0.85),
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

// ============================================================
// Pinned tab bar (SliverPersistentHeader delegate)
// ============================================================
class _TabsHeader extends SliverPersistentHeaderDelegate {
  final List<String> tabs;
  final int selected;
  final ValueChanged<int> onTap;
  _TabsHeader({
    required this.tabs,
    required this.selected,
    required this.onTap,
  });

  @override
  double get minExtent => 56;
  @override
  double get maxExtent => 56;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      height: 56,
      color: const Color(0xFF14161B),
      alignment: Alignment.centerLeft,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
        itemCount: tabs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final on = i == selected;
          return GestureDetector(
            onTap: () => onTap(i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: on ? const Color(0xFFF7F8F9) : const Color(0xFF23262D),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: on ? const Color(0xFFF7F8F9) : const Color(0xFF2C3038),
                ),
              ),
              child: Text(
                tabs[i],
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: on ? const Color(0xFF14161B) : const Color(0xFF7D8794),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _TabsHeader old) =>
      old.selected != selected || old.tabs != tabs;
}

// ============================================================
// News widgets
// ============================================================
class _LeadStory extends StatelessWidget {
  final ClubModel club;
  final NewsItem a;
  const _LeadStory({required this.club, required this.a});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // cover
          Container(
            height: 168,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  club.color,
                  Color.alphaBlend(
                    club.color.withOpacity(0.4),
                    const Color(0xFF14161B),
                  ),
                ],
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                Positioned(
                  right: -20,
                  bottom: -24,
                  child: Opacity(
                    opacity: 0.22,
                    child: ShieldCrest(
                      size: 150,
                      color: club.color,
                      ink: club.ink,
                      label: club.shortName,
                    ),
                  ),
                ),
                Positioned(
                  left: 12,
                  top: 12,
                  child: _CatTag(text: a.cat, bg: club.color, fg: club.ink),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(
            a.title,
            style: GoogleFonts.archivo(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              height: 1.2,
              color: const Color(0xFFF7F8F9),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            a.excerpt,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF9AA4B1),
              height: 1.45,
            ),
          ),
          const SizedBox(height: 10),
          _MetaRow(a: a),
          const SizedBox(height: 8),
          const Divider(color: Color(0xFF23262D), height: 1),
        ],
      ),
    );
  }
}

class _NewsRow extends StatelessWidget {
  final ClubModel club;
  final NewsItem a;
  const _NewsRow({required this.club, required this.a});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF23262D))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CatTag(text: a.cat, outline: club.color),
                const SizedBox(height: 8),
                Text(
                  a.title,
                  style: GoogleFonts.archivo(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    height: 1.25,
                    color: const Color(0xFFF7F8F9),
                  ),
                ),
                const SizedBox(height: 8),
                _MetaRow(a: a),
              ],
            ),
          ),
          if (a.image) ...[
            const SizedBox(width: 14),
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.alphaBlend(
                      club.color.withOpacity(0.7),
                      const Color(0xFF14161B),
                    ),
                    const Color(0xFF23262D),
                  ],
                ),
              ),
              alignment: Alignment.center,
              child: ShieldCrest(
                size: 30,
                color: club.color,
                ink: club.ink,
                label: club.shortName,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CatTag extends StatelessWidget {
  final String text;
  final Color? bg, fg, outline;
  const _CatTag({required this.text, this.bg, this.fg, this.outline});

  @override
  Widget build(BuildContext context) {
    final outlined = outline != null;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: outlined ? Colors.transparent : bg,
        borderRadius: BorderRadius.circular(7),
        border: outlined ? Border.all(color: outline!.withOpacity(0.4)) : null,
      ),
      child: Text(
        text,
        style: GoogleFonts.jetBrainsMono(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 1,
          color: outlined ? outline : fg,
        ),
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final NewsItem a;
  const _MetaRow({required this.a});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          a.source,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Color(0xFF9AA4B1),
          ),
        ),
        const SizedBox(width: 7),
        const Text('·', style: TextStyle(color: Color(0xFF7D8794))),
        const SizedBox(width: 7),
        Text(
          a.time,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 12,
            color: const Color(0xFF7D8794),
          ),
        ),
        const Spacer(),
        const Icon(Icons.bookmark_border, size: 16, color: Color(0xFF7D8794)),
      ],
    );
  }
}
