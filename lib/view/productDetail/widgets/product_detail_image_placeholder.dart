import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:thredo/res/color.dart';
import 'package:thredo/res/image.dart';
import 'package:thredo/res/style.dart';
import 'package:thredo/widget/app_loader.dart';
import 'package:thredo/widget/text_widget.dart';

/// Branded, thread-themed loading state for the product detail hero image.
class ProductDetailImagePlaceholder extends StatefulWidget {
  const ProductDetailImagePlaceholder({super.key});

  @override
  State<ProductDetailImagePlaceholder> createState() =>
      _ProductDetailImagePlaceholderState();
}

class _ProductDetailImagePlaceholderState
    extends State<ProductDetailImagePlaceholder>
    with SingleTickerProviderStateMixin {
  static const _tips = <String>[
    'Pinch to zoom and inspect every thread strand',
    'Use Thread Match AR to compare shades in real time',
    'Try Image Match to find similar embroidery designs',
    'Save your favourite threads to build a palette',
    'Discover premium threads from trusted brands',
  ];

  late final AnimationController _weaveController;
  Timer? _tipTimer;
  int _tipIndex = 0;

  @override
  void initState() {
    super.initState();
    _weaveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
    _tipTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted) return;
      setState(() => _tipIndex = (_tipIndex + 1) % _tips.length);
    });
  }

  @override
  void dispose() {
    _tipTimer?.cancel();
    _weaveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color09064A, colorBlack, Color(0xFF1A1530)],
          stops: [0.0, 0.55, 1.0],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedBuilder(
            animation: _weaveController,
            builder: (context, _) {
              return CustomPaint(
                painter: _ThreadWeavePainter(progress: _weaveController.value),
              );
            },
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildLogoBadge(),
                  SizedBox(height: 28.h),
                  _buildSpoolIcon(),
                  SizedBox(height: 20.h),
                  const AppLoader.small(accentColor: colorCEAB8D),
                  SizedBox(height: 16.h),
                  TextWidget(
                    text: 'Preparing fabric preview',
                    textStyle: BaseTextStyle.text600.copyWith(
                      fontSize: 15.sp,
                      color: colorE7E3DA,
                      letterSpacing: 0.2,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  SizedBox(
                    height: 44.h,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      switchInCurve: Curves.easeOut,
                      switchOutCurve: Curves.easeIn,
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 0.15),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        );
                      },
                      child: TextWidget(
                        key: ValueKey<int>(_tipIndex),
                        text: _tips[_tipIndex],
                        textAlign: TextAlign.center,
                        textStyle: BaseTextStyle.text400.copyWith(
                          fontSize: 12.sp,
                          color: colorCEAB8D.withValues(alpha: 0.9),
                          height: 1.45,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
              .animate()
              .fadeIn(duration: 400.ms, curve: Curves.easeOut)
              .slideY(begin: 0.06, end: 0, duration: 450.ms, curve: Curves.easeOut),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomShimmerBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: colorWhite.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: colorE7E3DA.withValues(alpha: 0.25)),
      ),
      child: Image.asset(
        PNGImages.imgTransparentLogo,
        height: 28.h,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildSpoolIcon() {
    return SizedBox(
      width: 72.w,
      height: 72.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 72.w,
            height: 72.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: colorCEAB8D.withValues(alpha: 0.35),
                width: 1.5,
              ),
            ),
          )
              .animate(onPlay: (c) => c.repeat())
              .scale(
                begin: const Offset(0.92, 0.92),
                end: const Offset(1.08, 1.08),
                duration: 1800.ms,
                curve: Curves.easeInOut,
              )
              .then()
              .scale(
                begin: const Offset(1.08, 1.08),
                end: const Offset(0.92, 0.92),
                duration: 1800.ms,
                curve: Curves.easeInOut,
              ),
          Icon(
            Icons.texture_rounded,
            size: 34.sp,
            color: colorCEAB8D,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomShimmerBar() {
    return SizedBox(
      height: 3.h,
      child: ClipRect(
        child: AnimatedBuilder(
          animation: _weaveController,
          builder: (context, _) {
            return LayoutBuilder(
              builder: (context, constraints) {
                final travel = constraints.maxWidth * 1.4;
                final offsetX =
                    (travel * _weaveController.value) - (travel * 0.45);
                return Transform.translate(
                  offset: Offset(offsetX, 0),
                  child: Container(
                    width: constraints.maxWidth * 0.45,
                    height: 3.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          colorCEAB8D.withValues(alpha: 0.85),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

/// Draws gently drifting thread-like curves across the background.
class _ThreadWeavePainter extends CustomPainter {
  _ThreadWeavePainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    const strandCount = 10;
    final wavePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (var i = 0; i < strandCount; i++) {
      final t = i / strandCount;
      final phase = (progress + t) * math.pi * 2;
      final alpha = 0.06 + (t * 0.1);
      wavePaint
        ..strokeWidth = 1.0 + (i.isEven ? 0.5 : 0.0)
        ..color = Color.lerp(colorE7E3DA, colorCEAB8D, t)!
            .withValues(alpha: alpha);

      final path = Path();
      final baseY = size.height * (0.12 + t * 0.76);
      path.moveTo(0, baseY);

      for (var x = 0.0; x <= size.width; x += 6) {
        final normalized = x / size.width;
        final y = baseY +
            math.sin(normalized * math.pi * 3 + phase) * (8 + i * 1.2) +
            math.cos(normalized * math.pi * 1.5 - phase * 0.6) * 4;
        path.lineTo(x, y);
      }

      canvas.drawPath(path, wavePaint);
    }
  }

  @override
  bool shouldRepaint(_ThreadWeavePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
