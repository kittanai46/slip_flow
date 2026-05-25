import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../view_models/slip_scan_view_model.dart';
import '../constants/app_constants.dart';
import '../services/ocr_service.dart';
import 'receipt_confirmation_screen.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';

class ScanScreen extends StatefulWidget {
  final bool fromGallery;
  const ScanScreen({super.key, this.fromGallery = false});

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
    if (widget.fromGallery) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _pickFromGallery());
    } else {
      _initializeCamera();
    }
  }

  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) {
      if (mounted) Navigator.pop(context);
      return;
    }
    if (mounted) {
      final ocrService = OCRServiceImpl();
      try {
        final scanResult = await ocrService.extractTextFromImage(picked.path);
        if (mounted) {
          final viewModel = context.read<SlipScanViewModel>();
          viewModel.imagePath = picked.path;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ReceiptConfirmationScreen(
                imagePath: picked.path,
                scannedData: scanResult,
              ),
            ),
          );
        }
      } finally {
        await ocrService.dispose();
      }
    }
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

            // Navigate to confirmation screen where user can edit and save
            if (mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReceiptConfirmationScreen(
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
    return Scaffold(
      body: SafeArea(
        child: Consumer<SlipScanViewModel>(
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
      ),
    );
  }

  Widget _buildCameraErrorWidget() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.red.withOpacity(0.1),
            Colors.red.withOpacity(0.05),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimensions.paddingLarge),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.camera_enhance, size: 64, color: Colors.red),
            ),
            const SizedBox(height: AppDimensions.paddingLarge),
            Text(
              _cameraError ?? 'Camera error',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.paddingMedium),
            FilledButton.icon(
              onPressed: () {
                setState(() {
                  _cameraError = null;
                  _cameraInitialized = false;
                });
                _initializeCamera();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingLarge,
                  vertical: AppDimensions.paddingMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraViewWidget() {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        CameraPreview(_cameraController!),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          child: CustomPaint(
            painter: ScanFramePainter(colorScheme: colorScheme),
          ),
        ),
        // Back button top-left
        Positioned(
          top: 16,
          left: 16,
          child: SafeArea(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.45),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ),
        // Instruction text at top
        Positioned(
          top: 30,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingMedium,
              vertical: AppDimensions.paddingSmall,
            ),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
              ),
            ),
            margin: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMedium),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.info, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context)!.camera,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Capture button at bottom
        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: Center(
            child: Column(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.primary,
                        colorScheme.primary.withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withOpacity(0.4),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _takePhoto,
                      customBorder: const CircleBorder(),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Tap to capture',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorWidget(SlipScanViewModel viewModel) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.orange.withOpacity(0.1),
            Colors.orange.withOpacity(0.05),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimensions.paddingLarge),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.error_outline, color: Colors.orange, size: 64),
            ),
            const SizedBox(height: AppDimensions.paddingLarge),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMedium),
              child: Text(
                viewModel.errorMessage ?? 'Unknown error',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingLarge),
            FilledButton.icon(
              onPressed: () {
                viewModel.clearError();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingLarge,
                  vertical: AppDimensions.paddingMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom painter for the receipt scanning frame
class ScanFramePainter extends CustomPainter {
  final ColorScheme? colorScheme;

  ScanFramePainter({this.colorScheme});

  @override
  void paint(Canvas canvas, Size size) {
    final cornerPaint = Paint()
      ..color = colorScheme?.primary ?? Colors.green
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    final framePaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..strokeWidth = 1.5
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
      Paint()..color = Colors.black.withOpacity(0.4),
    );

    // Draw frame border with rounded corners
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(12)),
      framePaint,
    );

    // Draw corner markers
    final cornerLength = 24.0;
    final cornerPadding = 8.0;
    
    // Top-left corner
    canvas.drawLine(
      Offset(frameLeft + cornerPadding, frameTop),
      Offset(frameLeft + cornerPadding + cornerLength, frameTop),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(frameLeft, frameTop + cornerPadding),
      Offset(frameLeft, frameTop + cornerPadding + cornerLength),
      cornerPaint,
    );
    
    // Top-right corner
    canvas.drawLine(
      Offset(frameLeft + frameWidth - cornerPadding, frameTop),
      Offset(frameLeft + frameWidth - cornerPadding - cornerLength, frameTop),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(frameLeft + frameWidth, frameTop + cornerPadding),
      Offset(frameLeft + frameWidth, frameTop + cornerPadding + cornerLength),
      cornerPaint,
    );
    
    // Bottom-left corner
    canvas.drawLine(
      Offset(frameLeft + cornerPadding, frameTop + frameHeight),
      Offset(frameLeft + cornerPadding + cornerLength, frameTop + frameHeight),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(frameLeft, frameTop + frameHeight - cornerPadding),
      Offset(frameLeft, frameTop + frameHeight - cornerPadding - cornerLength),
      cornerPaint,
    );
    
    // Bottom-right corner
    canvas.drawLine(
      Offset(frameLeft + frameWidth - cornerPadding, frameTop + frameHeight),
      Offset(frameLeft + frameWidth - cornerPadding - cornerLength, frameTop + frameHeight),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(frameLeft + frameWidth, frameTop + frameHeight - cornerPadding),
      Offset(frameLeft + frameWidth, frameTop + frameHeight - cornerPadding - cornerLength),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(ScanFramePainter oldDelegate) => false;
}
