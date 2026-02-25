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

  @override
  void initState() {
    super.initState();
    if (kIsWeb) _setupWebCamera();
  }

  void _setupWebCamera() async {
    _video = html.VideoElement()
      ..autoplay = true
      ..style.width = '100%'
      ..style.height = '100%';
    _canvas = html.CanvasElement();

    final stream = await html.window.navigator.mediaDevices!
        .getUserMedia({'video': {'facingMode': 'environment'}});
    _video!.srcObject = stream;

    // فقط لو Web
    if (kIsWeb) {
      // ignore: undefined_prefixed_name
      ui.platformViewRegistry.registerViewFactory(
        'webcamElement',
            (int viewId) => _video!,
      );
    }

    Future.doWhile(() async {
      if (scanned) return false;
      await Future.delayed(const Duration(milliseconds: 300));
      _scanFrame();
      return true;
    });
  }

  void _scanFrame() {
    if (_video == null || _video!.videoWidth == 0) return;

    _canvas!
      ..width = _video!.videoWidth
      ..height = _video!.videoHeight;

    final ctx = _canvas!.context2D;
    ctx.drawImage(_video!, 0, 0);

    final imgData = ctx.getImageData(0, 0, _canvas!.width!, _canvas!.height!);
    final code = jsQR(Uint8ClampedList.fromList(imgData.data), imgData.width!, imgData.height!);

    if (code != null && !scanned) {
      scanned = true;
      Navigator.pop(context, code.data);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) return const SizedBox(); // Native doesn't use this file
    return Scaffold(
      appBar: AppBar(title: const Text("QR Scanner Web")),
      body: HtmlElementView(viewType: 'webcamElement'),
    );
  }
}