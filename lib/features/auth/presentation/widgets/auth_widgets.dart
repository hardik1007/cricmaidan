import 'package:flutter/material.dart';

// ── App logo / wordmark used on auth screens ──────────────────────────────
class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: cs.primaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(Icons.bolt_rounded, size: 36, color: cs.primary),
        ),
        const SizedBox(height: 12),
        Text(
          'CricMaidan',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
        ),
      ],
    );
  }
}

// ── "— or —" divider ─────────────────────────────────────────────────────
class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'or',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Theme.of(context).colorScheme.outline),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}

// ── Google Sign-In button ─────────────────────────────────────────────────
class GoogleSignInButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final String label;

  const GoogleSignInButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    this.label = 'Continue with Google',
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _GoogleLogo(),
                const SizedBox(width: 12),
                Text(label),
              ],
            ),
    );
  }
}

class _GoogleLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Simple "G" as SVG-like custom painter — no image asset needed
    return SizedBox(
      width: 20,
      height: 20,
      child: CustomPaint(
        painter: _GoogleLogoPainter(
          surfaceColor: Theme.of(context).colorScheme.surface,
        ),
      ),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  final Color surfaceColor;

  _GoogleLogoPainter({required this.surfaceColor});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2;

    final segments = [
      // Red
      (0.0, 0.94, const Color(0xFFEA4335)),
      // Blue
      (0.94, 1.78, const Color(0xFF4285F4)),
      // Green
      (1.78, 2.62, const Color(0xFF34A853)),
      // Yellow
      (2.62, 3.36, const Color(0xFFFBBC05)),
      // Red wrap
      (3.36, 4.19, const Color(0xFFEA4335)),
    ];

    for (final seg in segments) {
      final paint = Paint()
        ..color = seg.$3
        ..strokeWidth = 4.0
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: r - 2),
        seg.$1,
        seg.$2 - seg.$1,
        false,
        paint,
      );
    }

    // Cut-out horizontal bar for the "G" notch
    final cutPaint = Paint()
      ..color = surfaceColor
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;
    // Skip the cutout paint trick — just draw a clean ring with arc segments
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Simpler approach: static colored circle with "G" text
// Replace _GoogleLogo with this for reliability across platforms
class GoogleLogoSimple extends StatelessWidget {
  const GoogleLogoSimple({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF4285F4),
      ),
      child: const Center(
        child: Text(
          'G',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

// ── Error banner shown below the form ────────────────────────────────────
class AuthErrorBanner extends StatelessWidget {
  final String message;
  final VoidCallback onDismiss;

  const AuthErrorBanner({
    super.key,
    required this.message,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: cs.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, color: cs.error, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: cs.onErrorContainer, fontSize: 13),
            ),
          ),
          GestureDetector(
            onTap: onDismiss,
            child: Icon(Icons.close_rounded, color: cs.error, size: 18),
          ),
        ],
      ),
    );
  }
}

// ignore: unused_element
class _FakeContext {
  const _FakeContext();
  // ignore: unused_field
  BuildContext get _buildContext => throw UnimplementedError();
}
