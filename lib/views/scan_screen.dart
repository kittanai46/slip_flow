import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../view_models/slip_scan_view_model.dart';
import '../constants/app_constants.dart';
import '../services/ocr_service.dart';
import 'ocr_result_screen.dart';
import 'package:camera/camera.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  CameraController? _cameraController;
  bool _cameraInitialized = false;
  String? _cameraError;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        if (mounted) {
          setState(() {
            _cameraError = 'No camera found';
          });
        }
        return;
      }

      _cameraController = CameraController(
        cameras[0],
        ResolutionPreset.high,
      );

      await _cameraController!.initialize();

      if (mounted) {
        setState(() {
          _cameraInitialized = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _cameraError = 'Failed to initialize camera: $e';
        });
      }
    }
  }

  Future<void> _takePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      final image = await _cameraController!.takePicture();
      if (mounted) {
        // Extract receipt data using OCR service
        final ocrService = OCRServiceImpl();
        try {
          final scanResult = await ocrService.extractTextFromImage(image.path);
          
          if (mounted) {
            final viewModel = context.read<SlipScanViewModel>();
            viewModel.imagePath = image.path;
            await viewModel.takePhoto();
            
            // Navigate to OCR result screen with extracted text
            if (mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OCRResultScreen(
                    imagePath: image.path,
                    scannedData: scanResult,
                  ),
                ),
              );
            }
          }
        } finally {
          await ocrService.dispose();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error taking photo: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.camera, size: 24),
            const SizedBox(width: 8),
            Text(l10n.scan_receipt),
          ],
        ),
        elevation: 0,
      ),
      body: Consumer<SlipScanViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isProcessing) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (viewModel.errorMessage != null) {
            return _buildErrorWidget(viewModel);
          }

          if (_cameraError != null) {
            return _buildCameraErrorWidget();
          }

          if (!_cameraInitialized) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return _buildCameraViewWidget();
        },
      ),
    );
  }

  Widget _buildCameraErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.camera_enhance, size: 64, color: Colors.red),
          const SizedBox(height: AppDimensions.paddingMedium),
          Text(_cameraError ?? 'Camera error'),
          const SizedBox(height: AppDimensions.paddingMedium),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _cameraError = null;
                _cameraInitialized = false;
              });
              _initializeCamera();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraViewWidget() {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        CameraPreview(_cameraController!),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          child: CustomPaint(
            painter: ScanFramePainter(),
          ),
        ),
        Positioned(
          bottom: 30,
          left: 0,
          right: 0,
          child: Column(
            children: [
              Text(
                AppLocalizations.of(context)!.camera,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingMedium),
              ElevatedButton(
                onPressed: _takePhoto,
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(16),
                  backgroundColor: Colors.blue,
                ),
                child: const Icon(
                  Icons.camera_alt,
                  size: 32,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildErrorWidget(SlipScanViewModel viewModel) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 64),
          const SizedBox(height: AppDimensions.paddingMedium),
          Text(viewModel.errorMessage ?? 'Unknown error'),
          const SizedBox(height: AppDimensions.paddingMedium),
          ElevatedButton(
            onPressed: () {
              viewModel.clearError();
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for the receipt scanning frame
class ScanFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final cornerPaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    // Frame dimensions (receipt aspect ratio ~3:5)
    final frameWidth = size.width * 0.85;
    final frameHeight = frameWidth * 1.5;
    final frameTop = (size.height - frameHeight) / 2;
    final frameLeft = (size.width - frameWidth) / 2;

    // Draw semi-transparent overlay outside the frame
    final rect = Rect.fromLTWH(frameLeft, frameTop, frameWidth, frameHeight);
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        Path()..addRect(rect),
      ),
      Paint()..color = Colors.black.withOpacity(0.3),
    );

    // Draw frame border
    canvas.drawRect(rect, paint);

    // Draw corner markers
    final cornerLength = 20.0;
    // Top-left
    canvas.drawLine(
      Offset(frameLeft, frameTop),
      Offset(frameLeft + cornerLength, frameTop),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(frameLeft, frameTop),
      Offset(frameLeft, frameTop + cornerLength),
      cornerPaint,
    );
    // Top-right
    canvas.drawLine(
      Offset(frameLeft + frameWidth, frameTop),
      Offset(frameLeft + frameWidth - cornerLength, frameTop),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(frameLeft + frameWidth, frameTop),
      Offset(frameLeft + frameWidth, frameTop + cornerLength),
      cornerPaint,
    );
    // Bottom-left
    canvas.drawLine(
      Offset(frameLeft, frameTop + frameHeight),
      Offset(frameLeft + cornerLength, frameTop + frameHeight),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(frameLeft, frameTop + frameHeight),
      Offset(frameLeft, frameTop + frameHeight - cornerLength),
      cornerPaint,
    );
    // Bottom-right
    canvas.drawLine(
      Offset(frameLeft + frameWidth, frameTop + frameHeight),
      Offset(frameLeft + frameWidth - cornerLength, frameTop + frameHeight),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(frameLeft + frameWidth, frameTop + frameHeight),
      Offset(frameLeft + frameWidth, frameTop + frameHeight - cornerLength),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(ScanFramePainter oldDelegate) => false;
}
