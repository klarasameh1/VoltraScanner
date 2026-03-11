import 'dart:ui';
import 'package:event_scanner_app/core/theme/app_colors.dart';
import 'package:event_scanner_app/core/utils/api_response.dart';
import 'package:event_scanner_app/features/scanner/data/models/event.dart';
import 'package:event_scanner_app/features/scanner/data/services/qr_service.dart';
import 'package:event_scanner_app/providers/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';

class ScannerScreen extends StatefulWidget {
  final Event event;

  const ScannerScreen({super.key, required this.event});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final MobileScannerController controller = MobileScannerController();
  final QrService service = QrService();
  final AudioPlayer audioPlayer = AudioPlayer();

  bool isLoading = false;
  bool scanned = false;
  bool? scanSuccess;
  String resultMessage = "";

  @override
  void initState() {
    super.initState();
    _initAudio();
  }

  /// Preload audio assets for success and failure
  Future<void> _initAudio() async {
    try {
      await audioPlayer.setSource(AssetSource('sounds/success.mp3'));
      await audioPlayer.setSource(AssetSource('sounds/failed.mp3'));
    } catch (e) {
      debugPrint('Audio init error: $e');
    }
  }

  /// Handle scanning and verification of QR token
  Future<void> handleScan(String token) async {
    if (scanned) return;

    setState(() {
      isLoading = true;
      scanned = true;
    });

    try {
      final ApiResponse<Map<String, dynamic>> result = await service.verifyToken(token);

      if (result.status == Status.success) {
        final data = result.data!;
        bool success = data["status"] == "success";

        // Play audio feedback
        try {
          await audioPlayer.stop();
          await audioPlayer.play(
            AssetSource(success ? 'sounds/success.mp3' : 'sounds/failed.mp3'),
          );
        } catch (e) {
          debugPrint('Audio playback error: $e');
        }

        if (!mounted) return;

        setState(() {
          scanSuccess = success;
          resultMessage = data["message"] ?? (success ? "Check-in successful" : "Check-in failed");
        });

        if (success) {
          // Increment the event's checked-in count
          widget.event.checkedInCount += 1;
          // update the provider here
          context.read<EventProvider>().updateEventCheckedInCount(widget.event.id, widget.event.checkedInCount);
        }

        // Wait 2 seconds to show result before closing
        await Future.delayed(const Duration(seconds: 2));

        if (!mounted) return;
        Navigator.pop(context, widget.event.checkedInCount);

      } else {
        // Failed case
        setState(() {
          scanSuccess = false;
          resultMessage = result.message ?? "Unknown error";
        });

        await Future.delayed(const Duration(seconds: 2));
        if (!mounted) return;

        setState(() {
          scanSuccess = null;
          scanned = false;
          isLoading = false;
        });

        await controller.start(); // Restart scanner
      }
    } catch (e) {
      debugPrint("Scan error: $e");
      if (!mounted) return;

      setState(() {
        scanSuccess = false;
        resultMessage = "Error scanning QR";
      });

      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;

      setState(() {
        scanSuccess = null;
        scanned = false;
        isLoading = false;
      });

      await controller.start();
    } finally {
      if (mounted && scanSuccess == null) {
        setState(() => isLoading = false);
      }
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
          // QR Camera view
          MobileScanner(
            controller: controller,
            onDetect: (capture) {
              if (scanned || isLoading) return;
              final barcode = capture.barcodes.first;
              final code = barcode.rawValue;
              if (code != null && code.isNotEmpty) {
                handleScan(code);
              }
            },
          ),

          // Scanner frame overlay
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.yellow, width: 4),
                borderRadius: BorderRadius.circular(20),
              ),
              child: isLoading && scanSuccess == null
                  ? const Center(
                child: CircularProgressIndicator(color: AppColors.white),
              )
                  : null,
            ),
          ),

          // Scan result overlay
          if (scanSuccess != null) ...[
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(color: Colors.black.withOpacity(0.3)),
              ),
            ),
            Center(
              child: AnimatedScale(
                scale: 1,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutBack,
                child: Container(
                  width: 300,
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: scanSuccess! ? AppColors.accentGreen : AppColors.red,
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
                        scanSuccess! ? Icons.check_circle_rounded : Icons.cancel_rounded,
                        size: 100,
                        color: AppColors.white,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        resultMessage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                      if (!scanSuccess!) ...[
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: resetScanner,
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