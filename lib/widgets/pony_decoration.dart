import 'package:flutter/material.dart';
import '../theme/mlp_theme.dart';

/// Floating pony character shown at the bottom of the home screen.
/// Uses the bundled asset images.
class PonyDecoration extends StatelessWidget {
  const PonyDecoration({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Soft glow under pony
          Container(
            width: 200,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              boxShadow: [
                BoxShadow(
                  color: MlpColors.pinkGlow,
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
              ],
            ),
          ),
          // Pony image
          Image.asset(
            'assets/images/rarity.png',
            height: 120,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const _FallbackPony(),
          ),
        ],
      ),
    );
  }
}

/// Shown when the asset image is missing (dev mode).
class _FallbackPony extends StatelessWidget {
  const _FallbackPony();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('🦄', style: const TextStyle(fontSize: 64)),
        Text(
          'Rarity',
          style: TextStyle(
            color: MlpColors.pinkLight,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

/// Decorative stars / sparkles scattered in the background.
class StarfieldBackground extends StatelessWidget {
  const StarfieldBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _StarPainter(),
        size: Size.infinite,
      ),
    );
  }
}

class _StarPainter extends CustomPainter {
  static const _stars = [
    Offset(0.1, 0.05), Offset(0.85, 0.08), Offset(0.45, 0.12),
    Offset(0.2, 0.22), Offset(0.75, 0.18), Offset(0.6, 0.3),
    Offset(0.05, 0.4), Offset(0.92, 0.35), Offset(0.35, 0.55),
    Offset(0.8, 0.6),  Offset(0.15, 0.7),  Offset(0.55, 0.75),
    Offset(0.9, 0.8),  Offset(0.3, 0.88),  Offset(0.65, 0.92),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = MlpColors.pinkLight.withOpacity(0.25);
    for (final s in _stars) {
      canvas.drawCircle(
        Offset(s.dx * size.width, s.dy * size.height),
        1.5,
        paint,
      );
    }
    // A few bigger sparkles
    final bigPaint = Paint()..color = MlpColors.purple.withOpacity(0.2);
    canvas.drawCircle(Offset(size.width * 0.7, size.height * 0.15), 3, bigPaint);
    canvas.drawCircle(Offset(size.width * 0.25, size.height * 0.6), 2.5, bigPaint);
  }

  @override
  bool shouldRepaint(_StarPainter old) => false;
}
