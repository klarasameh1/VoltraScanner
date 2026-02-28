import 'dart:ui';
import 'package:event_scanner_app/core/utils/api_response.dart';
import 'package:event_scanner_app/features/scanner/data/models/event.dart';
import 'package:event_scanner_app/features/scanner/data/services/qr_service.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:audioplayers/audioplayers.dart';

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

  Future<void> _initAudio() async {
    try {
      await audioPlayer.setSource(AssetSource('sounds/success.mp3'));
      await audioPlayer.setSource(AssetSource('sounds/failed.mp3'));
    } catch (e) {
      debugPrint('Audio init error: $e');
    }
  }

  Future<void> handleScan(String token) async {
    if (scanned) return;

    setState(() {
      isLoading = true;
      scanned = true;
    });

    try {
      final result = await service.verifyToken(token);

      if (result.isSuccess) {
        final data = result.data!;
        bool success = data["status"] == "success";

        // AUDIO
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
          resultMessage = data["message"] ?? (success ? "Success" : "Failed");
        });

        if (success) {
          widget.event.checkedInCount += 1;
        }

        // WAIT 2 SECONDS
        await Future.delayed(const Duration(seconds: 2));

        if (!mounted) return;
        Navigator.pop(context, widget.event.checkedInCount);
      } else {
        // IN failed case
        setState(() {
          scanSuccess = false;
          resultMessage = result.error!;
        });

        await Future.delayed(const Duration(seconds: 2));
        if (!mounted) return;

        setState(() {
          scanSuccess = null;
          scanned = false;
          isLoading = false;
        });

        await controller.start(); // Rescan
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

  /// FOR TESTING
  // Future<void> _testScan(String token, {bool isSuccess = true}) async {
  //   if (scanned) return;
  //
  //   // محاكاة الـ API
  //   await Future.delayed(const Duration(seconds: 1));
  //
  //   if (isSuccess) {
  //     widget.event.checkedInCount += 1;
  //     setState(() {
  //       scanSuccess = true;
  //       resultMessage = "Check-in successful (Test)";
  //     });
  //   } else {
  //     setState(() {
  //       scanSuccess = false;
  //       resultMessage = "Invalid QR Code (Test)";
  //     });
  //   }
  //
  //   try {
  //     await audioPlayer.stop();
  //     await audioPlayer.play(
  //       AssetSource(isSuccess ? 'sounds/success.mp3' : 'sounds/failed.mp3'),
  //     );
  //   } catch (e) {
  //     debugPrint('Audio playback error: $e');
  //   }
  //
  //   await Future.delayed(const Duration(seconds: 2));
  //
  //   if (!mounted) return;
  //
  //   if (isSuccess) {
  //     Navigator.pop(context, widget.event.checkedInCount);
  //   } else {
  //     setState(() {
  //       scanSuccess = null;
  //       scanned = false;
  //     });
  //   }
  // }
  ///-------------------------------------------------------

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
        foregroundColor: const Color(0xffFFD700),
        centerTitle: true,
        backgroundColor: const Color(0xFF028ECA),
        ///TESTING
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.check_circle, color: Colors.green),
        //     onPressed: () => _testScan("123", isSuccess: true),
        //     tooltip: "Test Success",
        //   ),
        //   IconButton(
        //     icon: const Icon(Icons.cancel, color: Colors.red),
        //     onPressed: () => _testScan("INVALID", isSuccess: false),
        //     tooltip: "Test Fail",
        //   ),
        // ],
        ///-------------------------------------------------------
      ),
      body: Stack(
        children: [
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
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xffFFD700), width: 4),
                borderRadius: BorderRadius.circular(20),
              ),
              child: isLoading && scanSuccess == null
                  ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
                  : null,
            ),
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
                      if (!scanSuccess!) ...[
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: resetScanner,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.red,
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
        backgroundColor: const Color(0xFF028ECA),
        onPressed: resetScanner,
        child: const Icon(Icons.refresh, color: Color(0xffFFD700)),
      ),
    );
  }
}