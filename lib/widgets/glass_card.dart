import 'package:flutter/material.dart';
import 'dart:ui';
import '../theme/colors.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsets padding;
  final Color? borderColor;
  final List<Color>? gradientColors;
  final double? width;
  final double? height;

  const GlassCard({
    super.key,
    required this.child,
    this.borderRadius = 24,
    this.padding = const EdgeInsets.all(20),
    this.borderColor,
    this.gradientColors,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: borderColor ?? AppColors.glassBorderFor(context),
              width: 1.5,
            ),
            gradient: LinearGradient(
              colors: gradientColors ??
                  (Theme.of(context).brightness == Brightness.dark
                      ? [
                          Colors.white.withOpacity(0.10),
                          Colors.white.withOpacity(0.05),
                        ]
                      : [
                          Colors.black.withOpacity(0.05),
                          Colors.black.withOpacity(0.02),
                        ]),
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
