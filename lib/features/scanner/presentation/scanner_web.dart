import 'dart:async';
import 'dart:html' as html;
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jsqr/jsqr.dart';

class UniversalQRScanner extends StatefulWidget {
  const UniversalQRScanner({super.key});

  @override
  State<UniversalQRScanner> createState() => _UniversalQRScannerState();
}

class _UniversalQRScannerState extends State<UniversalQRScanner> {
  html.VideoElement? _video;
  html.CanvasElement? _canvas;
  bool scanned = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _setupWebCamera();
  }

  void _setupWebCamera() async {
    _video = html.VideoElement();
    _video!.autoplay = true;
    _video!.style.width = '100%';
    _video!.style.height = '100%';
    _canvas = html.CanvasElement();

    try {
      final stream = await html.window.navigator.mediaDevices!
          .getUserMedia({'video': {'facingMode': 'environment'}});
      _video!.srcObject = stream;
    } catch (e) {
      print("Camera access denied: $e");
    }

    // تسجيل VideoElement في Flutter Web
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory('webcamElement', (int viewId) => _video!);

    // بدء loop لفحص QR كل 300ms
    _timer = Timer.periodic(const Duration(milliseconds: 300), (_) => _scanFrame());
  }

  void _scanFrame() {
    if (scanned || _video == null || _video!.videoWidth == 0) return;

    _canvas!
      ..width = _video!.videoWidth
      ..height = _video!.videoHeight;

    final ctx = _canvas!.context2D;
    ctx.drawImage(_video!, 0, 0);

    final imgData = ctx.getImageData(0, 0, _canvas!.width!, _canvas!.height!);
    final code = jsQR(Uint8ClampedList.fromList(imgData.data), imgData.width!, imgData.height!);

    if (code != null) {
      scanned = true;
      _timer?.cancel();
      Navigator.pop(context, code.data);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _video?.srcObject?.getTracks().forEach((track) => track.stop());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("QR Scanner Web")),
      body: HtmlElementView(viewType: 'webcamElement'),
    );
  }
}