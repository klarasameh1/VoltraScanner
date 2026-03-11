import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:event_scanner_app/core/theme/app_colors.dart';

class ResultOverlay extends StatelessWidget {
  final bool success;
  final String message;
  final VoidCallback? onRetry;

  const ResultOverlay({
    super.key,
    required this.success,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Blurred background
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),
        ),
        // Centered result box
        Center(
          child: AnimatedScale(
            scale: 1,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutBack,
            child: Container(
              width: 300,
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: success ? AppColors.accentGreen : AppColors.red,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 25,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    success ? Icons.check_circle_rounded : Icons.cancel_rounded,
                    size: 100,
                    color: AppColors.white,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                  if (!success && onRetry != null) ...[
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: onRetry,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.white,
                        foregroundColor: AppColors.red,
                      ),
                      child: const Text('Try Again'),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}