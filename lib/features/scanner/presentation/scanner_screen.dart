import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../checkin_service.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final MobileScannerController controller = MobileScannerController();
  final CheckinService service = CheckinService();

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

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: success ? Colors.green : Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            result["message"]!,
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                resetScanner();
              },
              child: const Text(
                "OK",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      );
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