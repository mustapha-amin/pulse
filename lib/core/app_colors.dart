import 'package:flutter/painting.dart';
import 'package:skeletonizer/skeletonizer.dart';

abstract class AppColors {
  static const primaryColor = Color(0xff0E8667);

  static PaintingEffect skeletonEffect({required bool isDark}) {
    return ShimmerEffect(
      baseColor: isDark ? const Color(0xFF3A3A3A) : const Color(0xFFE0E0E0),
      highlightColor: isDark
          ? const Color(0xFF5A5A5A)
          : const Color(0xFFF5F5F5),
    );
  }
}
