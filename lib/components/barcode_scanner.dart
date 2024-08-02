import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'camera_error_builder.dart';
import 'overlay.dart';

/// Barcode scanner widget
class BarcodeScanner extends StatefulWidget {
  final Text? appBarTitle;
  final void Function(BarcodeCapture)? onDetect;
  final List<Widget>? stackContent;
  // Prevents onDetect from executing. Usually set to true once a barcode has been scanned.
  final bool preventScan;

  /// The threshold for updates to the [scanWindow].
  ///
  /// If the [scanWindow] would be updated,
  /// due to new layout constraints for the scanner,
  /// and the width or height of the new scan window have not changed by this threshold,
  /// then the scan window is not updated.
  ///
  /// It is recommended to set this threshold
  /// if scan window updates cause performance issues.
  ///
  /// Defaults to no threshold for scan window updates.
  final double scanWindowUpdateThreshold;

  final void Function(String?)? onImagePick;
  const BarcodeScanner({
    super.key,
    required this.preventScan,
    this.scanWindowUpdateThreshold = 0.0,
    this.onDetect,
    this.onImagePick,
    this.appBarTitle,
    this.stackContent,
  });

  @override
  State<BarcodeScanner> createState() => _BarcodeScannerState();
}

class _BarcodeScannerState extends State<BarcodeScanner> {
  /// Scanner controller
  late MobileScannerController controller = MobileScannerController(
    autoStart: false,
    detectionSpeed: DetectionSpeed.normal,
  );
  final cutOutSize = Adaptive.w(80);

  @override
  void initState() {
    _restartCamera();
    super.initState();
  }

  // Unfortunately this bullshit is necessary because this package is a buggy piece of shit
  // https://github.com/juliansteenbakker/mobile_scanner/issues/1037

  Future<void> _restartCamera() async {
    controller.stop();
    await Future.delayed(
      const Duration(seconds: 1),
      () => controller.start(),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onDetect(BarcodeCapture barcodes) {
    if (!widget.preventScan) {
      HapticFeedback.vibrate();
      widget.onDetect?.call(barcodes);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        title: widget.appBarTitle,
        actions: [
          IconButton(
            icon: const Icon(Icons.cameraswitch_rounded),
            onPressed: controller.switchCamera,
          ),
          IconButton(
            icon: controller.torchEnabled
                ? const Icon(Icons.flashlight_off_rounded)
                : const Icon(Icons.flashlight_on_rounded),
            onPressed: controller.toggleTorch,
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          MobileScanner(
            onDetect: onDetect,
            controller: controller,
            fit: BoxFit.cover,
            errorBuilder: (_, error, ___) => const CameraErrorBuilder(),
            key: widget.key,
            scanWindow: Rect.fromCenter(
              center: Offset(Adaptive.w(50), Adaptive.h(50)),
              width: Adaptive.w(80),
              height: Adaptive.w(80),
            ),
            scanWindowUpdateThreshold: widget.scanWindowUpdateThreshold,
          ),
          Container(
            decoration: ShapeDecoration(
              shape: OverlayShape(
                borderRadius: 24,
                borderColor: Colors.white,
                borderLength: 42,
                borderWidth: 12,
                cutOutSize: cutOutSize,
                cutOutCenterOffset: 0,
                overlayColor: const Color.fromRGBO(0, 0, 0, 82),
              ),
            ),
          ),
          ...?widget.stackContent,
        ],
      ),
    );
  }
}
