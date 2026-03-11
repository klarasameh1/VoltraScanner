import 'package:flutter/material.dart';
import 'package:event_scanner_app/core/theme/app_colors.dart';

class ScannerFrame extends StatelessWidget {
  final bool isLoading;
  final bool? scanSuccess;

  const ScannerFrame({super.key, required this.isLoading, required this.scanSuccess});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 250,
        height: 250,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.yellow, width: 4),
          borderRadius: BorderRadius.circular(20),
        ),
        child: isLoading && scanSuccess == null
            ? const Center(child: CircularProgressIndicator(color: AppColors.white))
            : null,
      ),
    );
  }
}