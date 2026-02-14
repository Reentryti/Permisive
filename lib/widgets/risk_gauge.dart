import 'dart:math';
import 'package:flutter/material.dart';
import '../theme.dart';
import 'glass_card.dart';

class RiskGauge extends StatelessWidget {
  final double averageScore;
  final int totalApps;

  const RiskGauge({super.key, required this.averageScore, required this.totalApps});

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.riskColor(averageScore);
    final label = AppTheme.riskLabel(averageScore);

    return GlassCard(
      borderColor: color.withValues(alpha: 0.3),
      child: Column(
        children: [
          const SizedBox(height: 8),
          SizedBox(
            width: 180,
            height: 110,
            child: CustomPaint(
              painter: _GaugePainter(
                score: averageScore,
                maxScore: 20,
                color: color,
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      averageScore.toStringAsFixed(1),
                      style: TextStyle(
                        color: color,
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Average Risk: $label',
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Based on $totalApps scanned applications',
            style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double score;
  final double maxScore;
  final Color color;

  _GaugePainter({required this.score, required this.maxScore, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2 - 10;
    const startAngle = pi;
    const sweepAngle = pi;

    // Background arc
    final bgPaint = Paint()
      ..color = AppTheme.dividerColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      bgPaint,
    );

    // Score arc
    final scorePaint = Paint()
      ..shader = SweepGradient(
        center: Alignment.center,
        startAngle: pi,
        endAngle: 2 * pi,
        colors: [AppTheme.accentGreen, AppTheme.accentAmber, AppTheme.accentRed],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    final scoreRatio = (score / maxScore).clamp(0.0, 1.0);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle * scoreRatio,
      false,
      scorePaint,
    );

    // Needle dot
    final needleAngle = startAngle + sweepAngle * scoreRatio;
    final dotCenter = Offset(
      center.dx + radius * cos(needleAngle),
      center.dy + radius * sin(needleAngle),
    );
    canvas.drawCircle(dotCenter, 6, Paint()..color = color);
    canvas.drawCircle(dotCenter, 3, Paint()..color = AppTheme.deepNavy);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
