import 'package:flutter/material.dart';
import '../theme.dart';

class ScanButton extends StatefulWidget {
  final VoidCallback onPressed;
  const ScanButton({super.key, required this.onPressed});

  @override
  State<ScanButton> createState() => _ScanButtonState();
}

class _ScanButtonState extends State<ScanButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppTheme.accentCyan.withValues(alpha: 0.2 + 0.15 * _controller.value),
                blurRadius: 30 + 20 * _controller.value,
                spreadRadius: 2,
              ),
            ],
          ),
          child: child,
        );
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onPressed,
          borderRadius: BorderRadius.circular(60),
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppTheme.accentCyan, Color(0xFF0091EA)],
              ),
              border: Border.all(
                color: AppTheme.accentCyan.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.radar_rounded, color: AppTheme.deepNavy, size: 36),
                SizedBox(height: 4),
                Text(
                  'SCAN',
                  style: TextStyle(
                    color: AppTheme.deepNavy,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
