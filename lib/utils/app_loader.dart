
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pulse/core/app_colors.dart';

class AppLoadingIndicator extends StatefulWidget {
  final Widget child;
  final bool isLoading;
  const AppLoadingIndicator({
    required this.child,
    this.isLoading = false,
    super.key,
  });

  @override
  State<AppLoadingIndicator> createState() => _AppLoadingIndicatorState();
}

class _AppLoadingIndicatorState extends State<AppLoadingIndicator> {
  @override
  Widget build(BuildContext context) {
    final loader = AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.black54,
        systemNavigationBarColor: Colors.black54,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Container(
        color: Colors.black.withValues(alpha: 0.5),
        child: Center(
          child: SpinKitFadingCircle(size: 80, color: AppColors.primaryColor),
        ),
      ),
    );

    return Stack(
      alignment: Alignment.center,
      children: [
        widget.child,
        if (widget.isLoading) Positioned.fill(child: loader),
      ],
    );
  }
}
