import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rivals/bottom_navigation.dart';
import 'package:rivals/core/theme/app_theme.dart';
import 'package:rivals/features/auth/widgets/onboarding.dart';
import 'package:rivals/features/auth/provider/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onDone;
  const SplashScreen({super.key, required this.onDone});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  Timer? _advance;
  bool _left = false;

  static const _clubs = [
    ('ARS', Color(0xFFEF2A35), Colors.white),
    ('LIV', Color(0xFFDD1E2A), Colors.white),
    ('MCI', Color(0xFF4FA8E0), Color(0xFF06243B)),
    ('MUN', Color(0xFFD6202A), Colors.white),
    ('CHE', Color(0xFF2356C7), Colors.white),
    ('TOT', Color(0xFF15264F), Colors.white),
  ];

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..forward();
    _advance = Timer(const Duration(milliseconds: 3000), _finish);
  }

  void _finish() async {
    if (_left) return;
    _left = true;

    final user = FirebaseAuth.instance.currentUser;

    if (!mounted) return;

    if (user == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Onboarding()),
      );
      return;
    }

    final auth = context.read<AuthProvider>();
    await auth.refreshUserData();

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const BottomNav()),
    );
  }

  @override
  void dispose() {
    _advance?.cancel();
    _c.dispose();
    super.dispose();
  }

  Animation<double> _a(double b, double e, {Curve curve = Curves.easeOut}) =>
      CurvedAnimation(
        parent: _c,
        curve: Interval(b, e, curve: curve),
      );

  @override
  Widget build(BuildContext context) {
    final pitch = _a(0.05, 0.45);
    final glow = _a(0.04, 0.85);
    final beam = _a(0.21, 0.79, curve: Curves.linear);
    final stamp = _a(0.10, 0.40, curve: Curves.elasticOut);
    final ring = _a(0.23, 0.62);
    final line = _a(0.42, 0.66, curve: Curves.easeInOutCubic);
    final clubs = _a(0.54, 0.88);
    final tag = _a(0.58, 0.80);
    final load = _a(0.06, 1.00, curve: Curves.easeInOutCubic);

    return GestureDetector(
      onTap: _finish,
      child: Scaffold(
        // backgroundColor: AppTheme.navy,
        body: AnimatedBuilder(
          animation: _c,
          builder: (context, _) {
            return ClipRect(
              child: Stack(
                fit: StackFit.expand,
                alignment: Alignment.center,
                children: [
                  // 1. pitch grid
                  Positioned.fill(
                    child: _PitchGrid(opacity: pitch.value.clamp(0, 1)),
                  ),

                  // 2. ignition glow
                  Transform.scale(
                    scale: 0.4 + glow.value * 0.6,
                    child: Container(
                      width: 520,
                      height: 520,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppTheme.accent.withOpacity(0.3 * glow.value),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.62],
                        ),
                      ),
                    ),
                  ),

                  // 3. sweeping stadium light-beam
                  Positioned.fill(child: _Beam(t: beam.value)),

                  // 4. center content
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 120,
                          height: 92,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // accent glow
                              Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.accent.withOpacity(
                                        // was RivalsColors.accent
                                        0.3 * stamp.value.clamp(0, 1),
                                      ),
                                      blurRadius: 30,
                                      spreadRadius: -2,
                                      offset: const Offset(0, 12),
                                    ),
                                  ],
                                ),
                              ),

                              // ring pulse
                              Transform.scale(
                                scale: 0.6 + ring.value * 1.5,
                                child: Container(
                                  width: 92,
                                  height: 92,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppTheme.accent.withOpacity(
                                        // was RivalsColors.accent
                                        0.6 *
                                            (1 - ring.value).clamp(0, 1) *
                                            0.8,
                                      ),
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),

                              // crest stamp
                              ColorFiltered(
                                colorFilter: ColorFilter.matrix([
                                  1,
                                  0,
                                  0,
                                  0,
                                  0,
                                  0,
                                  1,
                                  0,
                                  0,
                                  0,
                                  0,
                                  0,
                                  1,
                                  0,
                                  0,
                                  0,
                                  0,
                                  0,
                                  stamp.value.clamp(0, 1),
                                  0,
                                ]),
                                child: Transform.scale(
                                  scale: (0.4 + stamp.value * 0.6).clamp(
                                    0.4,
                                    1.0,
                                  ),
                                  child: ShieldCrest(
                                    size: 92,
                                    color: AppTheme
                                        .accent, // was RivalsColors.accent
                                    ink: AppTheme
                                        .accentInk, // was RivalsColors.accentInk
                                    label: 'RV',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 22),
                        _Wordmark(progress: _c),
                        const SizedBox(height: 20),

                        // accent line
                        Container(
                          height: 3,
                          width: 120 * line.value,
                          decoration: BoxDecoration(
                            color: AppTheme.accent, // was RivalsColors.accent
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),

                        const SizedBox(height: 26),

                        // club crests
                        ColorFiltered(
                          colorFilter: ColorFilter.matrix([
                            1,
                            0,
                            0,
                            0,
                            0,
                            0,
                            1,
                            0,
                            0,
                            0,
                            0,
                            0,
                            1,
                            0,
                            0,
                            0,
                            0,
                            0,
                            clubs.value.clamp(0, 1),
                            0,
                          ]),
                          child: SizedBox(
                            height: 30,
                            width: _clubs.length * 23 + 7,
                            child: Stack(
                              children: [
                                for (var i = 0; i < _clubs.length; i++)
                                  Positioned(
                                    left: i * 23.0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppTheme.navy,
                                          width: 2,
                                        ),
                                      ),
                                      child: ShieldCrest(
                                        size: 30,
                                        color: _clubs[i].$2,
                                        ink: _clubs[i].$3,
                                        label: _clubs[i].$1,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        // tagline
                        Text(
                          'PICK A SIDE · TALK YOUR TALK',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.8,
                            color: AppTheme.navy.withOpacity(
                              // was RivalsColors.textFaint
                              tag.value.clamp(0, 1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // loading bar
                  Positioned(
                    bottom: 64,
                    child: Container(
                      width: 132,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppTheme.navy.withOpacity(
                          0.3,
                        ), // was RivalsColors.border
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: FractionallySizedBox(
                          widthFactor: load.value,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppTheme.accent, // was RivalsColors.accent
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 28,
                    child: TextButton(
                      onPressed: _finish,
                      child: Text(
                        'SKIP',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 11,
                          letterSpacing: 1.4,
                          color: Colors.white.withOpacity(
                            0.4,
                          ), // was RivalsColors.textFaint
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ── Pitch grid ────────────────────────────────────────────────────────────────
class _PitchGrid extends StatelessWidget {
  final double opacity;
  const _PitchGrid({required this.opacity});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.dstIn,
      shaderCallback: (rect) => RadialGradient(
        center: Alignment.center,
        radius: 0.66,
        colors: [Colors.black.withOpacity(opacity), Colors.transparent],
      ).createShader(rect),
      child: CustomPaint(size: Size.infinite, painter: _GridPainter()),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Colors.white.withOpacity(0.06)
      ..strokeWidth = 1;
    const step = 44.0;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), p);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

// ── Beam ──────────────────────────────────────────────────────────────────────
class _Beam extends StatelessWidget {
  final double t;
  const _Beam({required this.t});

  @override
  Widget build(BuildContext context) {
    final o = (t < 0.4 ? t / 0.4 : (1 - (t - 0.4) / 0.6)).clamp(0.0, 1.0);
    return LayoutBuilder(
      builder: (ctx, c) {
        final w = c.maxWidth, h = c.maxHeight;
        final dx = (-0.9 + 0.8 * t) * (w * 1.4);
        return Transform.translate(
          offset: Offset(w * 0.5 + dx, -h * 0.12),
          child: Transform.rotate(
            angle: 0.14,
            alignment: Alignment.topLeft,
            child: Container(
              width: w * 1.4,
              height: h * 1.6,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.transparent,
                    AppTheme.accent.withOpacity(
                      0.22 * o,
                    ), // was RivalsColors.accent
                    Colors.transparent,
                  ],
                  stops: const [0.44, 0.50, 0.56],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ── Wordmark ──────────────────────────────────────────────────────────────────
class _Wordmark extends StatelessWidget {
  final AnimationController progress;
  const _Wordmark({required this.progress});

  @override
  Widget build(BuildContext context) {
    const letters = ['R', 'I', 'V', 'A', 'L', 'S'];
    final style = GoogleFonts.archivo(
      fontWeight: FontWeight.w900,
      fontSize: 52,
      height: 1.0,
      color: Colors.white, // was RivalsColors.text
    );
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < letters.length; i++)
          _Letter(
            char: letters[i],
            accent: letters[i] == 'A',
            anim: CurvedAnimation(
              parent: progress,
              curve: Interval(
                0.29 + i * 0.045,
                0.55 + i * 0.045,
                curve: Curves.easeOutCubic,
              ),
            ),
            style: style,
          ),
      ],
    );
  }
}

class _Letter extends StatelessWidget {
  final String char;
  final bool accent;
  final Animation<double> anim;
  final TextStyle style;
  const _Letter({
    required this.char,
    required this.accent,
    required this.anim,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: AnimatedBuilder(
        animation: anim,
        builder: (context, child) => Transform.translate(
          offset: Offset(0, (1 - anim.value) * 56),
          child: Opacity(opacity: anim.value.clamp(0, 1), child: child),
        ),
        child: Text(
          char,
          style: accent
              ? style.copyWith(
                  color: AppTheme.accent,
                ) // was RivalsColors.accent
              : style,
        ),
      ),
    );
  }
}

// ── Shield crest ──────────────────────────────────────────────────────────────
class ShieldCrest extends StatelessWidget {
  final double size;
  final Color color;
  final Color ink;
  final String label;
  const ShieldCrest({
    super.key,
    required this.size,
    required this.color,
    required this.ink,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(size: Size(size, size), painter: _ShieldPainter(color)),
          Padding(
            padding: EdgeInsets.only(bottom: size * 0.06),
            child: Text(
              label,
              style: GoogleFonts.archivo(
                fontWeight: FontWeight.w900,
                fontSize: size * 0.3,
                color: ink,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShieldPainter extends CustomPainter {
  final Color color;
  _ShieldPainter(this.color);

  @override
  void paint(Canvas canvas, Size s) {
    final sx = s.width / 40, sy = s.height / 44;
    final shield = Path()
      ..moveTo(20 * sx, 1 * sy)
      ..lineTo(38 * sx, 8 * sy)
      ..lineTo(38 * sx, 19 * sy)
      ..cubicTo(38 * sx, 30 * sy, 30.4 * sx, 38 * sy, 20 * sx, 42 * sy)
      ..cubicTo(9.6 * sx, 38 * sy, 2 * sx, 30 * sy, 2 * sx, 19 * sy)
      ..lineTo(2 * sx, 8 * sy)
      ..close();

    final fill = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color, color.withOpacity(0.82)],
      ).createShader(Rect.fromLTWH(0, 0, s.width, s.height));
    canvas.drawPath(shield, fill);

    final hi = Path()
      ..moveTo(20 * sx, 1 * sy)
      ..lineTo(38 * sx, 8 * sy)
      ..lineTo(38 * sx, 11 * sy)
      ..lineTo(20 * sx, 5 * sy)
      ..lineTo(2 * sx, 11 * sy)
      ..lineTo(2 * sx, 8 * sy)
      ..close();
    canvas.drawPath(hi, Paint()..color = Colors.white.withOpacity(0.18));
  }

  @override
  bool shouldRepaint(_) => false;
}
