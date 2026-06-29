import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rivals/core/models/club_model.dart';
import 'package:rivals/features/auth/widgets/splash_screen.dart';

class ClubNewsTab extends StatefulWidget {
  final ClubModel club;
  const ClubNewsTab({super.key, required this.club});

  @override
  State<ClubNewsTab> createState() => _ClubNewsTabState();
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

class _ClubNewsTabState extends State<ClubNewsTab> {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _news.map((item) {
        return item.lead
            ? LeadStory(club: widget.club, item: item)
            : NewsRow(club: widget.club, item: item);
      }).toList(),
    );
  }
}

class LeadStory extends StatelessWidget {
  final ClubModel club;
  final NewsItem item;
  const LeadStory({super.key, required this.club, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // big cover card
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
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: club.color,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Text(
                      item.cat,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                        color: club.ink,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(
            item.title,
            style: GoogleFonts.archivo(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              height: 1.2,
              color: Color(0xFFF7F8F9),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.excerpt,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF9AA4B1),
              height: 1.45,
            ),
          ),
          const SizedBox(height: 10),
          _MetaRow(item: item),
          const SizedBox(height: 8),
          const Divider(color: Color(0xFF23262D), height: 1),
        ],
      ),
    );
  }
}

class NewsRow extends StatelessWidget {
  final ClubModel club;
  final NewsItem item;
  const NewsRow({super.key, required this.club, required this.item});

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
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(color: club.color.withOpacity(0.4)),
                  ),
                  child: Text(
                    item.cat,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                      color: club.color,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.title,
                  style: GoogleFonts.archivo(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    height: 1.25,
                    color: Color(0xFFF7F8F9),
                  ),
                ),
                const SizedBox(height: 8),
                _MetaRow(item: item),
              ],
            ),
          ),
          if (item.image) ...[
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

class _MetaRow extends StatelessWidget {
  final NewsItem item;
  const _MetaRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          item.source,
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
          item.time,
          style: const TextStyle(fontSize: 12, color: Color(0xFF7D8794)),
        ),
        const Spacer(),
        const Icon(Icons.bookmark_border, size: 16, color: Color(0xFF7D8794)),
      ],
    );
  }
}
