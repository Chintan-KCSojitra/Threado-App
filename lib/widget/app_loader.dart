import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:thredo/res/color.dart';
import 'package:thredo/res/style.dart';
import 'package:thredo/widget/text_widget.dart';

/// Branded Threado loader — lightweight arc animation in app colours.
class AppLoader extends StatefulWidget {
  const AppLoader({
    super.key,
    this.size = 44,
    this.accentColor,
    this.trackColor,
    this.strokeWidth = 3,
  });

  const AppLoader.small({
    super.key,
    this.accentColor,
    this.trackColor,
  })  : size = 26,
        strokeWidth = 2.5;

  const AppLoader.large({
    super.key,
    this.accentColor,
    this.trackColor,
  })  : size = 56,
        strokeWidth = 3.5;

  final double size;
  final Color? accentColor;
  final Color? trackColor;
  final double strokeWidth;

  static Widget centered({
    double size = 44,
    Color? accentColor,
    Color? trackColor,
  }) {
    return Center(
      child: AppLoader(
        size: size,
        accentColor: accentColor,
        trackColor: trackColor,
      ),
    );
  }

  @override
  State<AppLoader> createState() => _AppLoaderState();
}

class _AppLoaderState extends State<AppLoader> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accent = widget.accentColor ?? colorCEAB8D;
    final track = widget.trackColor ?? colorE7E3DA.withValues(alpha: 0.55);

    return RepaintBoundary(
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final rotation = _controller.value;
            final pulse = 0.82 + (math.sin(rotation * math.pi * 2) * 0.18);
            return CustomPaint(
              painter: _ThreadLoaderPainter(
                rotation: rotation,
                pulse: pulse,
                accentColor: accent,
                trackColor: track,
                strokeWidth: widget.strokeWidth,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ThreadLoaderPainter extends CustomPainter {
  const _ThreadLoaderPainter({
    required this.rotation,
    required this.pulse,
    required this.accentColor,
    required this.trackColor,
    required this.strokeWidth,
  });

  final double rotation;
  final double pulse;
  final Color accentColor;
  final Color trackColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - strokeWidth;

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth * 0.55;

    canvas.drawCircle(center, radius, trackPaint);

    final mainStart = rotation * math.pi * 2;
    final mainPaint = Paint()
      ..color = accentColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      mainStart,
      math.pi * 1.28,
      false,
      mainPaint,
    );

    final innerPaint = Paint()
      ..color = accentColor.withValues(alpha: 0.42)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth * 0.62
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.72),
      -mainStart * 1.35,
      math.pi * 0.82,
      false,
      innerPaint,
    );

    canvas.drawCircle(
      center,
      strokeWidth * 0.85 * pulse,
      Paint()..color = accentColor,
    );
  }

  @override
  bool shouldRepaint(covariant _ThreadLoaderPainter oldDelegate) {
    return oldDelegate.rotation != rotation ||
        oldDelegate.pulse != pulse ||
        oldDelegate.accentColor != accentColor ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

/// Full-screen or inset loading overlay with optional message.
class AppLoaderOverlay extends StatelessWidget {
  const AppLoaderOverlay({
    super.key,
    this.message,
    this.backgroundColor,
    this.loaderSize = 56,
    this.loaderAccentColor,
  });

  final String? message;
  final Color? backgroundColor;
  final double loaderSize;
  final Color? loaderAccentColor;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: backgroundColor ?? colorBlack.withValues(alpha: 0.32),
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 40.w),
          padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 28.h),
          decoration: BoxDecoration(
            color: colorWhite,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: colorBlack.withValues(alpha: 0.08),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppLoader(
                size: loaderSize,
                accentColor: loaderAccentColor,
              ),
              if (message != null && message!.trim().isNotEmpty) ...[
                SizedBox(height: 16.h),
                TextWidget(
                  text: message!,
                  textAlign: TextAlign.center,
                  textStyle: BaseTextStyle.text500.copyWith(
                    fontSize: 14.sp,
                    color: color79747E,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
