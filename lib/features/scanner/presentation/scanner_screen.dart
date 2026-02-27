import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:audioplayers/audioplayers.dart';
import '../checkin_service.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final MobileScannerController controller = MobileScannerController();
  final CheckinService service = CheckinService();
  final AudioPlayer audioPlayer = AudioPlayer();

  bool isLoading = false;
  bool scanned = false;

  bool? scanSuccess; // null = no result
  String resultMessage = "";

  Future<void> handleScan(String token) async {
    setState(() {
      isLoading = true;
      scanned = true;
    });

    try {
      final result = await service.verifyToken(token);
      bool success = result["status"] == "success";

      // 🔊 Play Sound
      await audioPlayer.stop();
      if (success) {
        await audioPlayer.play(
          AssetSource('sounds/success.mp3'),
        );
      } else {
        await audioPlayer.play(
          AssetSource('sounds/error.mp3'),
        );
      }

      // 🟢 Show Result Overlay
      setState(() {
        scanSuccess = success;
        resultMessage = result["message"] ?? "";
      });

      // ⏳ Wait 2 seconds
      await Future.delayed(const Duration(seconds: 2));

      // 🔄 Reset
      setState(() {
        scanSuccess = null;
        scanned = false;
      });

      await controller.start();
    } catch (e) {
      debugPrint(e.toString());
    }

    setState(() => isLoading = false);
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
          /// 📷 Camera
          MobileScanner(
            controller: controller,
            onDetect: (capture) async {
              if (scanned) return;

              final barcode = capture.barcodes.first;
              final code = barcode.rawValue;

              if (code != null) {
                scanned = true;
                await controller.stop();
                await handleScan(code);
              }
            },
          ),

          /// 🔲 Scanner Frame
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xffFFD700),
                  width: 4,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),

          /// ⏳ Loading
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),

          /// 🌫️ Blur + Result Overlay
          if (scanSuccess != null) ...[
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                ),
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
                    color: scanSuccess!
                        ? Colors.green
                        : Colors.red,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 25,
                        spreadRadius: 2,
                      )
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
        child: const Icon(Icons.refresh , color:Color(0xffFFD700) ,),
      ),
    );
  }
}