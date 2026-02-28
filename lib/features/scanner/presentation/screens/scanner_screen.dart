import 'dart:ui';
import 'package:event_scanner_app/features/scanner/data/models/event.dart';
import 'package:event_scanner_app/features/scanner/data/services/qr_service.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:audioplayers/audioplayers.dart';

class ScannerScreen extends StatefulWidget {
  final Event event; // receive the event

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

  Future<void> handleScan(String token) async {
    if (scanned) return; // prevent multiple scans
    setState(() {
      isLoading = true;
      scanned = true;
    });

    try {
      final result = await service.verifyToken(token);
      bool success = result["status"] == "success";

      await audioPlayer.stop();
      await audioPlayer.play(
        AssetSource(success ? 'sounds/success.mp3' : 'sounds/failed.mp3'),
      );

      if (!mounted) return;
      setState(() {
        scanSuccess = success;
        resultMessage = result["message"] ?? (success ? "Success" : "Failed");
      });

      if (success) {
        // Increase the checked-in count for the event
        widget.event.checkedInCount += 1;
      }

      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;
      Navigator.pop(context, widget.event.checkedInCount); // return count to HomeScreen
    } catch (e) {
      debugPrint("Scan error: $e");
      if (!mounted) return;
      setState(() {
        scanSuccess = false;
        resultMessage = "Error scanning QR";
        scanned = false;
      });
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void resetScanner() async {
    scanned = false;
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
        foregroundColor: const Color(0xffFFD700),
        centerTitle: true,
        backgroundColor: const Color(0xFF028ECA),
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: (capture) {
              if (scanned) return;
              final barcode = capture.barcodes.first;
              final code = barcode.rawValue;
              if (code != null) {
                handleScan(code);
              }
            },
          ),
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xffFFD700), width: 4),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
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
                    color: scanSuccess! ? Colors.green : Colors.red,
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
                        scanSuccess!
                            ? Icons.check_circle_rounded
                            : Icons.cancel_rounded,
                        size: 100,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        resultMessage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF028ECA),
        onPressed: resetScanner,
        child: const Icon(Icons.refresh, color: Color(0xffFFD700)),
      ),
    );
  }
}