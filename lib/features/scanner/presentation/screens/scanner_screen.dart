import 'package:event_scanner_app/core/theme/app_colors.dart';
import 'package:event_scanner_app/core/utils/api_response.dart';
import 'package:event_scanner_app/features/scanner/data/models/event.dart';
import 'package:event_scanner_app/features/scanner/data/services/qr_service.dart';
import 'package:event_scanner_app/features/scanner/presentation/widgets/scanner_frame.dart';
import 'package:event_scanner_app/features/scanner/presentation/widgets/scanner_result_overlay.dart';
import 'package:event_scanner_app/providers/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:event_scanner_app/features/scanner/presentation/widgets/scanner_audio.dart';

class ScannerScreen extends StatefulWidget {
  final Event event;

  const ScannerScreen({super.key, required this.event});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final MobileScannerController controller = MobileScannerController();
  final QrService service = QrService();
  final ScannerAudio audioPlayer = ScannerAudio();

  bool isLoading = false;
  bool scanned = false;
  bool? scanSuccess;
  String resultMessage = "";

  @override
  void initState() {
    super.initState();
    audioPlayer.initAudio();
  }

  /// Handle scanning and verification of QR token
  Future<void> handleScan(String token) async {
    if (scanned) return;

    setState(() {
      isLoading = true;
      scanned = true;
      scanSuccess = null;
    });

    try {
      final ApiResponse<Map<String, dynamic>> result =
          await service.verifyToken(token);

      if (result.status == Status.success) {
        final data = result.data!;

        bool success = data["success"] == true ||
            data["status"] == "success" ||
            data["statusCode"] == 200 ||
            (data["data"] != null && data["data"]["status"] == "success");

        String message = data["message"] ??
            data["msg"] ??
            data["data"]?["message"] ??
            (success ? "Check-in successful" : "Check-in failed");
        resultMessage = message; // تحديث المتغير

        // Play audio feedback
        await audioPlayer.playFeedback(success);

        if (!mounted) return;
        setState(() {
          scanSuccess = success;
          resultMessage = data["message"] ??
              (success ? "Check-in successful" : "Check-in failed");
        });

        if (success) {
          // Increment the event's checked-in count
          widget.event.checkedInCount += 1;
          context.read<EventProvider>().updateEventCheckedInCount(
              widget.event.id, widget.event.checkedInCount);
        }

        await Future.delayed(const Duration(seconds: 2));
        if (!mounted) return;
        Navigator.pop(context, widget.event.checkedInCount);
      } else {
        handleScanFailure(result.message ?? "Unknown error");
      }
    } catch (e) {
      handleScanFailure("Error scanning QR");
    } finally {
      if (mounted) {
        // تأكد من إيقاف التحميل فقط إذا لم يظهر overlay
        if (scanSuccess == null) {
          setState(() {
            isLoading = false;
          });
        }
      }
    }
  }

  void handleScanFailure(String message) async {
    if (mounted) {
      setState(() {
        scanSuccess = null;
        scanned = false;
        isLoading = false;
      });
    }

    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    setState(() {
      scanSuccess = null;
      scanned = false;
      isLoading = false;
    });

    await controller.start();
  }

  /// Reset the scanner to allow rescanning
  void resetScanner() async {
    setState(() {
      scanned = false;
      scanSuccess = null;
      isLoading = false;
    });
    await controller.start();
  }

  @override
  void dispose() {
    controller.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Scanner"),
        foregroundColor: AppColors.yellow,
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: (capture) {
              if (scanned || isLoading) return;
              final barcode = capture.barcodes.first;
              final code = barcode.rawValue;
              if (code != null && code.isNotEmpty) handleScan(code);
            },
          ),
          ScannerFrame(isLoading: isLoading, scanSuccess: scanSuccess),
          if (scanSuccess != null)
            ResultOverlay(
              success: scanSuccess!,
              message: resultMessage,
              onRetry: resetScanner,
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: resetScanner,
        child: const Icon(Icons.refresh, color: AppColors.yellow),
      ),
    );
  }
}
