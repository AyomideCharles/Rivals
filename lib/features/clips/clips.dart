import 'package:flutter/material.dart';

class Clips extends StatefulWidget {
  const Clips({super.key});

  @override
  State<Clips> createState() => _ClipsState();
}

class _ClipsState extends State<Clips> {
  final pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.blue),
          ),
          Center(child: Text('data')),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:rivals/features/auth/widgets/splash_screen.dart';

// // ============================================================
// // Model + sample data
// // ============================================================
// class Clip {
//   final String name, handle, kind, caption, sound;
//   final String crest; // club short code, '' for neutral
//   final Color color; // club color (drives the theme)
//   final Color ink;
//   final bool verified;
//   final List<String> tags;
//   final int likes, comments, shares, duration; // duration in seconds
//   const Clip({
//     required this.name,
//     required this.handle,
//     required this.kind,
//     required this.caption,
//     required this.sound,
//     required this.crest,
//     required this.color,
//     this.ink = Colors.white,
//     this.verified = false,
//     this.tags = const [],
//     required this.likes,
//     required this.comments,
//     required this.shares,
//     required this.duration,
//   });
// }

// const kClips = <Clip>[
//   Clip(
//     name: 'Goal Zone',
//     handle: '@goalzone',
//     kind: 'GOAL',
//     caption:
//         "94th minute winner and the Kop ERUPTS 🔴🌋 chills every single time.",
//     sound: 'original audio · Anfield Roar',
//     crest: 'LIV',
//     color: Color(0xFFDD1E2A),
//     verified: true,
//     tags: ['#LFC', '#LastMinute'],
//     likes: 48200,
//     comments: 1240,
//     shares: 8900,
//     duration: 11,
//   ),
//   Clip(
//     name: 'Nutmeg City',
//     handle: '@megsdaily',
//     kind: 'SKILLS',
//     caption:
//         "Filthy. Absolutely filthy. He sent the whole back line to the shop 🛒",
//     sound: 'BIG DRIP — prod. by terrace',
//     crest: 'MCI',
//     color: Color(0xFF4FA8E0),
//     ink: Color(0xFF06243B),
//     tags: ['#Skills', '#Nutmeg'],
//     likes: 21400,
//     comments: 610,
//     shares: 3100,
//     duration: 9,
//   ),
//   Clip(
//     name: 'The Banter Lab',
//     handle: '@banterlab',
//     kind: 'BANTER',
//     caption:
//         "POV: your rival after promising 'this is our year' for the 11th season 💀",
//     sound: 'crying jordan remix',
//     crest: 'ARS',
//     color: Color(0xFFEF2A35),
//     verified: true,
//     tags: ['#Banter', '#NorthLondon'],
//     likes: 67800,
//     comments: 4200,
//     shares: 15600,
//     duration: 14,
//   ),
//   Clip(
//     name: 'El Clásico HD',
//     handle: '@clasico',
//     kind: 'GOAL',
//     caption:
//         "From the halfway line. He decided the keeper was too far off his line 🚀👑",
//     sound: 'original audio · Bernabéu',
//     crest: 'RMA',
//     color: Color(0xFFE7E1CD),
//     ink: Color(0xFF1A2B6B),
//     verified: true,
//     tags: ['#Clasico', '#Worldie'],
//     likes: 91200,
//     comments: 6700,
//     shares: 22100,
//     duration: 12,
//   ),
// ];

// String fmtCount(int n) {
//   if (n >= 10000) return '${(n / 1000).round()}K';
//   if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
//   return '$n';
// }

// // ============================================================
// // Clips page — vertical PageView
// // ============================================================
// class Clips extends StatefulWidget {
//   const Clips({super.key});
//   @override
//   State<Clips> createState() => _ClipsState();
// }

// class _ClipsState extends State<Clips> {
//   final _controller = PageController();
//   int _active = 0;
//   String _feed = 'For You';

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF06080C),
//       body: Stack(
//         children: [
//           // the swipeable feed
//           PageView.builder(
//             controller: _controller,
//             scrollDirection: Axis.vertical,
//             itemCount: kClips.length,
//             onPageChanged: (i) => setState(() => _active = i),
//             itemBuilder: (context, i) =>
//                 ClipCard(clip: kClips[i], isActive: i == _active),
//           ),

//           // top controls (For You / Following + live)
//           Positioned(
//             top: 0,
//             left: 0,
//             right: 0,
//             child: SafeArea(
//               bottom: false,
//               child: Padding(
//                 padding: const EdgeInsets.only(top: 6, bottom: 10),
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         _FeedTab(
//                           'Following',
//                           _feed == 'Following',
//                           () => setState(() => _feed = 'Following'),
//                         ),
//                         const SizedBox(width: 18),
//                         _FeedTab(
//                           'For You',
//                           _feed == 'For You',
//                           () => setState(() => _feed = 'For You'),
//                         ),
//                       ],
//                     ),
//                     Positioned(
//                       right: 16,
//                       child: _GlassIcon(
//                         icon: Icons.sensors,
//                         live: true,
//                         onTap: () {
//                           /* open live matches */
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _FeedTab extends StatelessWidget {
//   final String label;
//   final bool selected;
//   final VoidCallback onTap;
//   const _FeedTab(this.label, this.selected, this.onTap);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             label,
//             style: GoogleFonts.archivo(
//               fontSize: 16,
//               fontWeight: FontWeight.w800,
//               color: selected ? Colors.white : Colors.white60,
//               shadows: const [Shadow(color: Colors.black54, blurRadius: 8)],
//             ),
//           ),
//           const SizedBox(height: 4),
//           AnimatedContainer(
//             duration: const Duration(milliseconds: 180),
//             height: 3,
//             width: selected ? 20 : 0,
//             decoration: BoxDecoration(
//               color: const Color(0xFFB6F24D),
//               borderRadius: BorderRadius.circular(2),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _GlassIcon extends StatelessWidget {
//   final IconData icon;
//   final bool live;
//   final VoidCallback onTap;
//   const _GlassIcon({
//     required this.icon,
//     this.live = false,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 40,
//         height: 40,
//         decoration: BoxDecoration(
//           color: Colors.black.withOpacity(0.32),
//           borderRadius: BorderRadius.circular(13),
//           border: Border.all(color: Colors.white24),
//         ),
//         child: Stack(
//           children: [
//             Center(child: Icon(icon, size: 20, color: Colors.white)),
//             if (live)
//               Positioned(
//                 top: 7,
//                 right: 8,
//                 child: Container(
//                   width: 8,
//                   height: 8,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFE5484D),
//                     shape: BoxShape.circle,
//                     border: Border.all(
//                       color: const Color(0xFF111111),
//                       width: 2,
//                     ),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ============================================================
// // One clip
// // ============================================================
// class ClipCard extends StatefulWidget {
//   final Clip clip;
//   final bool isActive;
//   const ClipCard({super.key, required this.clip, required this.isActive});

//   @override
//   State<ClipCard> createState() => _ClipCardState();
// }

// class _ClipCardState extends State<ClipCard> with TickerProviderStateMixin {
//   late final AnimationController _ken; // Ken Burns drift
//   late final AnimationController _progress; // playback progress bar
//   bool _paused = false;
//   bool _liked = false;
//   bool _following = false;
//   int _burst = 0; // bump to retrigger the heart burst

//   @override
//   void initState() {
//     super.initState();
//     _ken = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 14),
//     );
//     _progress = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: widget.clip.duration),
//     );
//     if (widget.isActive) _play();
//   }

//   void _play() {
//     _ken.repeat(reverse: true);
//     _progress
//       ..reset()
//       ..repeat();
//     _paused = false;
//   }

//   void _stop() {
//     _ken.stop();
//     _progress.stop();
//   }

//   @override
//   void didUpdateWidget(covariant ClipCard old) {
//     super.didUpdateWidget(old);
//     if (widget.isActive && !old.isActive) _play();
//     if (!widget.isActive && old.isActive) {
//       _stop();
//       _progress.reset();
//     }
//   }

//   @override
//   void dispose() {
//     _ken.dispose();
//     _progress.dispose();
//     super.dispose();
//   }

//   void _togglePlay() {
//     setState(() {
//       _paused = !_paused;
//       if (_paused) {
//         _ken.stop();
//         _progress.stop();
//       } else {
//         _ken.repeat(reverse: true);
//         _progress.repeat();
//       }
//     });
//   }

//   void _like() {
//     setState(() {
//       _liked = true;
//       _burst++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final c = widget.clip;
//     final accent = c.color;
//     final likes = c.likes + (_liked ? 1 : 0);

//     return GestureDetector(
//       onTap: _togglePlay,
//       onDoubleTap: _like,
//       child: Stack(
//         fit: StackFit.expand,
//         children: [
//           // animated "video" background
//           AnimatedBuilder(
//             animation: _ken,
//             builder: (context, _) {
//               final t = _ken.value;
//               return Transform.scale(
//                 scale: 1.06 + t * 0.12,
//                 child: Transform.translate(
//                   offset: Offset(-t * 8, -t * 12),
//                   child: DecoratedBox(
//                     decoration: BoxDecoration(
//                       gradient: RadialGradient(
//                         center: const Alignment(0.4, -0.6),
//                         radius: 1.2,
//                         colors: [
//                           Color.alphaBlend(
//                             accent.withOpacity(0.55),
//                             const Color(0xFF0A0D12),
//                           ),
//                           const Color(0xFF06080C),
//                         ],
//                         stops: const [0.0, 0.7],
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),

//           // big rotated watermark (GOAL / SKILLS / ...)
//           Positioned(
//             top: 110,
//             left: -10,
//             child: Transform.rotate(
//               angle: -0.14,
//               child: Text(
//                 c.kind,
//                 style: GoogleFonts.archivo(
//                   fontSize: 104,
//                   height: 0.8,
//                   fontWeight: FontWeight.w900,
//                   letterSpacing: -4,
//                   color: accent.withOpacity(0.32),
//                 ),
//               ),
//             ),
//           ),

//           // faint giant crest
//           if (c.crest.isNotEmpty)
//             Positioned(
//               right: -34,
//               top: 280,
//               child: Opacity(
//                 opacity: 0.08,
//                 child: ShieldCrest(
//                   size: 180,
//                   color: accent,
//                   ink: c.ink,
//                   label: c.crest,
//                 ),
//               ),
//             ),

//           // legibility shades
//           const DecoratedBox(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.bottomCenter,
//                 end: Alignment.center,
//                 colors: [Colors.black87, Colors.transparent],
//               ),
//             ),
//           ),

//           // center play button when paused
//           if (_paused)
//             Center(
//               child: Container(
//                 width: 78,
//                 height: 78,
//                 decoration: BoxDecoration(
//                   color: Colors.black.withOpacity(0.34),
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(
//                   Icons.play_arrow,
//                   color: Colors.white,
//                   size: 40,
//                 ),
//               ),
//             ),

//           // double-tap heart burst
//           if (_burst > 0) Center(child: _HeartBurst(key: ValueKey(_burst))),

//           // right action rail
//           Positioned(
//             right: 10,
//             bottom: 30,
//             child: _Rail(
//               clip: c,
//               liked: _liked,
//               following: _following,
//               likes: likes,
//               onLike: _like,
//               onFollow: () => setState(() => _following = !_following),
//               progress: _progress, // spins the sound disc
//             ),
//           ),

//           // bottom meta
//           Positioned(left: 16, right: 86, bottom: 30, child: _Meta(clip: c)),

//           // progress bar
//           Positioned(
//             left: 0,
//             right: 0,
//             bottom: 0,
//             child: AnimatedBuilder(
//               animation: _progress,
//               builder: (context, _) => LinearProgressIndicator(
//                 value: widget.isActive ? _progress.value : 0,
//                 minHeight: 3,
//                 backgroundColor: Colors.white24,
//                 valueColor: const AlwaysStoppedAnimation(Colors.white),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ---- heart burst overlay ----
// class _HeartBurst extends StatefulWidget {
//   const _HeartBurst({super.key});
//   @override
//   State<_HeartBurst> createState() => _HeartBurstState();
// }

// class _HeartBurstState extends State<_HeartBurst>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _c = AnimationController(
//     vsync: this,
//     duration: const Duration(milliseconds: 800),
//   )..forward();

//   @override
//   void dispose() {
//     _c.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _c,
//       builder: (context, _) {
//         final v = _c.value;
//         final scale = v < 0.2 ? 0.4 + (v / 0.2) * 0.8 : 1.2 - (v - 0.2) * 0.1;
//         final opacity = v < 0.2 ? v / 0.2 : (1 - (v - 0.2) / 0.8);
//         return Opacity(
//           opacity: opacity.clamp(0, 1),
//           child: Transform.translate(
//             offset: Offset(0, -26 * v),
//             child: Transform.scale(
//               scale: scale,
//               child: Transform.rotate(
//                 angle: -0.14,
//                 child: const Icon(
//                   Icons.favorite,
//                   color: Colors.white,
//                   size: 120,
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// // ---- right action rail ----
// class _Rail extends StatelessWidget {
//   final Clip clip;
//   final bool liked, following;
//   final int likes;
//   final VoidCallback onLike, onFollow;
//   final Animation<double> progress;
//   const _Rail({
//     required this.clip,
//     required this.liked,
//     required this.following,
//     required this.likes,
//     required this.onLike,
//     required this.onFollow,
//     required this.progress,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         // author + follow
//         SizedBox(
//           width: 52,
//           height: 60,
//           child: Stack(
//             // clipBehavior: Clip.none,
//             alignment: Alignment.topCenter,
//             children: [
//               Container(
//                 width: 48,
//                 height: 48,
//                 decoration: BoxDecoration(
//                   color: clip.color,
//                   shape: BoxShape.circle,
//                   border: Border.all(color: Colors.black54, width: 2),
//                 ),
//                 alignment: Alignment.center,
//                 child: Text(
//                   clip.name.substring(0, 1),
//                   style: GoogleFonts.archivo(
//                     fontWeight: FontWeight.w800,
//                     color: clip.ink,
//                     fontSize: 18,
//                   ),
//                 ),
//               ),
//               Positioned(
//                 bottom: 0,
//                 child: GestureDetector(
//                   onTap: onFollow,
//                   child: Container(
//                     width: 22,
//                     height: 22,
//                     decoration: BoxDecoration(
//                       color: following ? Colors.white : const Color(0xFFB6F24D),
//                       shape: BoxShape.circle,
//                       border: Border.all(
//                         color: const Color(0xFF06080C),
//                         width: 2,
//                       ),
//                     ),
//                     child: Icon(
//                       following ? Icons.check : Icons.add,
//                       size: 14,
//                       color: const Color(0xFF10210A),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 20),
//         _RailBtn(
//           icon: liked ? Icons.favorite : Icons.favorite_border,
//           label: fmtCount(likes),
//           color: liked ? const Color(0xFFE5484D) : Colors.white,
//           onTap: onLike,
//         ),
//         const SizedBox(height: 20),
//         _RailBtn(
//           icon: Icons.mode_comment_outlined,
//           label: fmtCount(clip.comments),
//         ),
//         const SizedBox(height: 20),
//         _RailBtn(icon: Icons.repeat, label: fmtCount(clip.shares)),
//         const SizedBox(height: 20),
//         _RailBtn(icon: Icons.reply, label: 'Share'),
//         const SizedBox(height: 22),
//         // spinning sound disc
//         RotationTransition(
//           turns: progress.drive(
//             Tween(begin: 0.0, end: 4.0),
//           ), // spins as it plays
//           child: Container(
//             width: 46,
//             height: 46,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               gradient: const RadialGradient(
//                 colors: [Color(0xFF2A2F38), Color(0xFF11141A)],
//                 stops: [0.38, 0.4],
//               ),
//               border: Border.all(color: Colors.white24),
//             ),
//             child: clip.crest.isNotEmpty
//                 ? Center(
//                     child: ShieldCrest(
//                       size: 28,
//                       color: clip.color,
//                       ink: clip.ink,
//                       label: clip.crest,
//                     ),
//                   )
//                 : const Icon(Icons.music_note, color: Colors.white, size: 18),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _RailBtn extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final Color color;
//   final VoidCallback? onTap;
//   const _RailBtn({
//     required this.icon,
//     required this.label,
//     this.color = Colors.white,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         children: [
//           Icon(
//             icon,
//             color: color,
//             size: 30,
//             shadows: const [Shadow(color: Colors.black54, blurRadius: 6)],
//           ),
//           const SizedBox(height: 5),
//           Text(
//             label,
//             style: GoogleFonts.jetBrainsMono(
//               color: Colors.white,
//               fontSize: 12,
//               fontWeight: FontWeight.w700,
//               shadows: const [Shadow(color: Colors.black54, blurRadius: 6)],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ---- bottom caption / sound ----
// class _Meta extends StatelessWidget {
//   final Clip clip;
//   const _Meta({required this.clip});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Text(
//               clip.handle,
//               style: GoogleFonts.hankenGrotesk(
//                 color: Colors.white,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w800,
//                 shadows: const [Shadow(color: Colors.black54, blurRadius: 8)],
//               ),
//             ),
//             if (clip.verified) ...[
//               const SizedBox(width: 6),
//               const Icon(Icons.verified, color: Color(0xFFB6F24D), size: 16),
//             ],
//             if (clip.crest.isNotEmpty) ...[
//               const SizedBox(width: 8),
//               Container(
//                 padding: const EdgeInsets.fromLTRB(4, 3, 9, 3),
//                 decoration: BoxDecoration(
//                   color: Colors.white24,
//                   borderRadius: BorderRadius.circular(999),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     ShieldCrest(
//                       size: 16,
//                       color: clip.color,
//                       ink: clip.ink,
//                       label: clip.crest,
//                     ),
//                     const SizedBox(width: 5),
//                     Text(
//                       clip.crest,
//                       style: GoogleFonts.hankenGrotesk(
//                         color: Colors.white,
//                         fontSize: 12,
//                         fontWeight: FontWeight.w800,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ],
//         ),
//         const SizedBox(height: 8),
//         Text(
//           '${clip.caption} ${clip.tags.join(' ')}',
//           maxLines: 3,
//           overflow: TextOverflow.ellipsis,
//           style: GoogleFonts.hankenGrotesk(
//             color: Colors.white,
//             fontSize: 14,
//             height: 1.4,
//             shadows: const [Shadow(color: Colors.black54, blurRadius: 6)],
//           ),
//         ),
//         const SizedBox(height: 12),
//         Row(
//           children: [
//             const Icon(Icons.music_note, color: Colors.white, size: 15),
//             const SizedBox(width: 8),
//             Expanded(
//               child: Text(
//                 clip.sound,
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 style: GoogleFonts.hankenGrotesk(
//                   color: Colors.white,
//                   fontSize: 13,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
