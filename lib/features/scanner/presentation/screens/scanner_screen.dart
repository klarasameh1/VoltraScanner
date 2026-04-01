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
import 'dart:convert';

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
  Future<void> handleScan(String qrData) async {
    if (scanned) return;
    debugPrint("🔍 RAW QR: $qrData");
    debugPrint("🔍 QR TYPE: ${qrData.runtimeType}");

    setState(() {
      isLoading = true;
      scanned = true;
      scanSuccess = null;
    });

    try {
      print("QR DATA: $qrData");

      // Try to decode if it's JSON, but now we might just get a raw token
      String token;
      try {
        // Attempt to parse as JSON
        final decoded = jsonDecode(qrData);
        // Check if it has a token field, otherwise use the whole decoded value
        if (decoded is Map && decoded.containsKey("token")) {
          token = decoded["token"].toString();
        } else if (decoded is Map && decoded.containsKey("id")) {
          // Legacy support: if it has id and event_id, combine or use as is?
          // Based on your backend change, they expect just a token
          // So we'll treat the whole QR as the token
          token = qrData;
        } else {
          token = qrData;
        }
      } catch (e) {
        // Not JSON, treat the whole string as the token
        token = qrData;
      }

      debugPrint("📝 Sending token: $token");

      // Send only the token to the service
      final ApiResponse<Map<String, dynamic>> result = await service.verifyToken(token);

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

        // Play audio feedback
        await audioPlayer.playFeedback(success);

        if (!mounted) return;

        setState(() {
          scanSuccess = success;
          resultMessage = message;
          isLoading = false;
        });

        if (success) {
          widget.event.checkedInCount += 1;
          context.read<EventProvider>().updateEventCheckedInCount(
              widget.event.id, widget.event.checkedInCount);
        }

        await Future.delayed(const Duration(seconds: 4));
        if (!mounted) return;

        Navigator.pop(context, widget.event.checkedInCount);
      } else {
        if (!mounted) return;
        setState(() {
          scanSuccess = false;
          resultMessage = result.message ?? "Check-in failed";
          isLoading = false;
        });

        await audioPlayer.playFeedback(false);

        await Future.delayed(const Duration(seconds: 4));
        if (!mounted) return;
        resetScanner();
      }
    } catch (e) {
      // failed in connect or json
      if (!mounted) return;
      setState(() {
        scanSuccess = false;
        resultMessage = "Invalid QR or network issue";
        isLoading = false;
      });

      await audioPlayer.playFeedback(false);

      await Future.delayed(const Duration(seconds: 4));
      if (!mounted) return;
      resetScanner();
    }
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
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            backgroundColor: const Color(0x800053C8),
            onPressed: resetScanner,
            child: const Icon(Icons.refresh),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
