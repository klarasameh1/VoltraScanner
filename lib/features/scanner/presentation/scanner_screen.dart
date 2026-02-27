import 'package:event_scanner_app/features/scanner/presentation/scan_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../checkin_service.dart';
import 'package:audioplayers/audioplayers.dart';

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

  Future<void> handleScan(String token) async {
    setState(() {
      isLoading = true;
      scanned = true;
    });

    try {
      final result = await service.verifyToken(token);

      bool success = result["status"] == "success";

      if (success) {
        await audioPlayer.play(AssetSource('sounds/success.mp3'));
      } else {
        await audioPlayer.play(AssetSource('sounds/error.mp3'));
      }

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ScanResultScreen(
            success: success,
            message: result["message"] ?? "",
          ),
        ),
      );

      resetScanner();
    } catch (e) {
      debugPrint(e.toString());
    }

    setState(() => isLoading = false);
  }

  void resetScanner() {
    scanned = false;
    controller.start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Event Check-In"),
        centerTitle: true,
        backgroundColor: const Color(0x800053C8),
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
                controller.stop();
                handleScan(code);
              }
            },
          ),

          // Overlay Frame
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0x800053C8),
                  width: 4,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),

          // Loading Indicator
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
        ],
      ),

      // Reset Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0x800053C8),
        onPressed: resetScanner,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}