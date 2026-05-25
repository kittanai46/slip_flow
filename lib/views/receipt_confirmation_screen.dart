import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../view_models/slip_scan_view_model.dart';
import '../constants/app_constants.dart';
import '../models/scan_result_model.dart';

class ReceiptConfirmationScreen extends StatefulWidget {
  final String imagePath;
  final ScanResult? scannedData;

  const ReceiptConfirmationScreen({
    required this.imagePath,
    this.scannedData,
    super.key,
  });

  @override
  State<ReceiptConfirmationScreen> createState() =>
      _ReceiptConfirmationScreenState();
}

class _ReceiptConfirmationScreenState extends State<ReceiptConfirmationScreen> {
  late TextEditingController _textController;
  late Set<int> _selectedBlockIndices;
  bool _isSelectionMode = false;
  Size? _imageDimensions;

  @override
  void initState() {
    super.initState();
    final scannedText = widget.scannedData?.rawText ?? '';
    _textController = TextEditingController(text: scannedText);
    _selectedBlockIndices = Set.from(
      List.generate(widget.scannedData?.textBlocks.length ?? 0, (i) => i),
    );
    
    // Load image dimensions for coordinate scaling
    _loadImageDimensions();
  }

  void _loadImageDimensions() {
    final image = Image.file(File(widget.imagePath));
    image.image.resolve(ImageConfiguration.empty).addListener(
      ImageStreamListener((imageInfo, synchronousCall) {
        setState(() {
          _imageDimensions = Size(
            imageInfo.image.width.toDouble(),
            imageInfo.image.height.toDouble(),
          );
        });
      }),
    );
  }

  void _updateTextFromSelection() {
    if (widget.scannedData == null || widget.scannedData!.textBlocks.isEmpty) {
      return;
    }

    final selectedTexts = <String>[];
    for (int i = 0; i < widget.scannedData!.textBlocks.length; i++) {
      if (_selectedBlockIndices.contains(i)) {
        selectedTexts.add(widget.scannedData!.textBlocks[i].text);
      }
    }

    _textController.text = selectedTexts.join('\n');
  }

  void _toggleBlockSelection(int index) {
    setState(() {
      if (_selectedBlockIndices.contains(index)) {
        _selectedBlockIndices.remove(index);
      } else {
        _selectedBlockIndices.add(index);
      }
      _updateTextFromSelection();
    });
  }

  void _selectAllBlocks() {
    setState(() {
      _selectedBlockIndices = Set.from(
        List.generate(widget.scannedData?.textBlocks.length ?? 0, (i) => i),
      );
      _updateTextFromSelection();
    });
  }

  void _deselectAllBlocks() {
    setState(() {
      _selectedBlockIndices.clear();
      _updateTextFromSelection();
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(

      body: SafeArea(
        child: Column(
          children: [
            // Header with back button and selection mode toggle
            Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingMedium),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      context.read<SlipScanViewModel>().reset();
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.paddingMedium),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.scan_receipt,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (_isSelectionMode && widget.scannedData?.textBlocks.isNotEmpty == true)
                          Text(
                            '${_selectedBlockIndices.length}/${widget.scannedData!.textBlocks.length} selected',
                            style: TextStyle(
                              fontSize: 12,
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: Icon(
                        _isSelectionMode ? Icons.done : Icons.touch_app,
                        color: colorScheme.primary,
                      ),
                      tooltip: _isSelectionMode ? 'Done selecting' : 'Select text regions',
                      onPressed: () {
                        setState(() {
                          _isSelectionMode = !_isSelectionMode;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Image preview with interactive selection
            if (_isSelectionMode && widget.scannedData?.textBlocks.isNotEmpty == true)
              _buildInteractiveImage(colorScheme)
            else
              Container(
                margin: const EdgeInsets.all(AppDimensions.paddingMedium),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                  child: Image.file(
                    File(widget.imagePath),
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            
            // Selection mode controls
            if (_isSelectionMode && widget.scannedData?.textBlocks.isNotEmpty == true)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingMedium,
                vertical: AppDimensions.paddingSmall,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _selectAllBlocks,
                      icon: const Icon(Icons.done_all, size: 18),
                      label: const Text('Select All'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _deselectAllBlocks,
                      icon: const Icon(Icons.clear_all, size: 18),
                      label: const Text('Clear All'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),

                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Scanned text label
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingMedium,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                l10n.scanned_text,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingSmall),
          
          // Scanned text field
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingMedium,
              ),
              child: TextField(
                controller: _textController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                    borderSide: BorderSide(
                      color: colorScheme.outlineVariant,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                    borderSide: BorderSide(
                      color: colorScheme.outlineVariant.withOpacity(0.5),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                    borderSide: BorderSide(
                      color: colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: colorScheme.surfaceContainerLowest,
                  hintText: l10n.receipt_text_hint,
                  hintStyle: TextStyle(
                    color: colorScheme.onSurfaceVariant.withOpacity(0.7),
                  ),
                  contentPadding: const EdgeInsets.all(AppDimensions.paddingMedium),
                ),
              ),
            ),
          ),
          
          // Save button
          Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => _saveSlip(context),
                icon: const Icon(Icons.save),
                label: Text(l10n.save),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildInteractiveImage(ColorScheme colorScheme) {
    final textBlocks = widget.scannedData?.textBlocks ?? [];
    if (textBlocks.isEmpty) {
      return Container(
        margin: const EdgeInsets.all(AppDimensions.paddingMedium),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          child: Image.file(
            File(widget.imagePath),
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(
          color: colorScheme.outlineVariant.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final displayWidth = constraints.maxWidth;
          final displayHeight = 240.0;

          return ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            child: Stack(
              children: [
                Image.file(
                  File(widget.imagePath),
                  height: displayHeight,
                  width: displayWidth,
                  fit: BoxFit.cover,
                ),
                Positioned.fill(
                  child: GestureDetector(
                    onTapDown: (details) {
                      // Calculate the scaled block coordinates for hit detection
                      // The text blocks are in original image coordinates
                      // We need to scale them to display coordinates
                      _handleImageTap(details, textBlocks, displayWidth, displayHeight);
                    },
                    child: CustomPaint(
                      painter: TextBlockPainter(
                        textBlocks: textBlocks,
                        selectedIndices: _selectedBlockIndices,
                        displaySize: Size(displayWidth, displayHeight),
                        imageFile: File(widget.imagePath),
                        imageDimensions: _imageDimensions,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _handleImageTap(
    TapDownDetails details,
    List<ScannedTextBlock> textBlocks,
    double displayWidth,
    double displayHeight,
  ) {
    // Use cached image dimensions if available
    if (_imageDimensions != null && _imageDimensions!.isFinite) {
      _performHitTest(details, textBlocks, displayWidth, displayHeight, _imageDimensions!);
    } else {
      // Fall back to loading dimensions if not cached
      final image = Image.file(File(widget.imagePath));
      image.image.resolve(ImageConfiguration.empty).addListener(
        ImageStreamListener((imageInfo, synchronousCall) {
          final dimensions = Size(
            imageInfo.image.width.toDouble(),
            imageInfo.image.height.toDouble(),
          );
          _performHitTest(details, textBlocks, displayWidth, displayHeight, dimensions);
        }),
      );
    }
  }

  void _performHitTest(
    TapDownDetails details,
    List<ScannedTextBlock> textBlocks,
    double displayWidth,
    double displayHeight,
    Size imageDimensions,
  ) {
    // Calculate scale factors: how to convert from image space to display space
    final scaleX = displayWidth / imageDimensions.width;
    final scaleY = displayHeight / imageDimensions.height;

    // Check which block was tapped
    for (int i = 0; i < textBlocks.length; i++) {
      final block = textBlocks[i];
      
      // Scale the block coordinates from image space to display space
      final left = block.left * scaleX;
      final top = block.top * scaleY;
      final right = block.right * scaleX;
      final bottom = block.bottom * scaleY;

      // Check if tap is within this block's bounds
      if (details.localPosition.dx >= left &&
          details.localPosition.dx <= right &&
          details.localPosition.dy >= top &&
          details.localPosition.dy <= bottom) {
        _toggleBlockSelection(i);
        break;
      }
    }
  }

  void _saveSlip(BuildContext context) async {
    try {
      final l10n = AppLocalizations.of(context)!;
      final viewModel = context.read<SlipScanViewModel>();
      await viewModel.saveSlip(
        storeName: 'Unknown Store',
        amount: 0.0,
        date: DateTime.now(),
        category: 'Other',
        notes: _textController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.saved_successfully)),
        );
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
}

class TextBlockPainter extends CustomPainter {
  final List<ScannedTextBlock> textBlocks;
  final Set<int> selectedIndices;
  final Size displaySize;
  final File? imageFile;
  final Size? imageDimensions;

  TextBlockPainter({
    required this.textBlocks,
    required this.selectedIndices,
    required this.displaySize,
    this.imageFile,
    this.imageDimensions,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Only paint if we have valid size
    if (displaySize.isEmpty || textBlocks.isEmpty) {
      return;
    }

    // Attempt to paint with error handling
    try {
      _paintBlocks(canvas, size);
    } catch (e) {
      // Silently fail to prevent app crashes
    }
  }

  void _paintBlocks(Canvas canvas, Size size) {
    // Only draw if we have image dimensions
    if (imageDimensions == null || !imageDimensions!.isFinite) {
      return;
    }

    // Calculate scale factors: how to convert from image space to display space
    final scaleX = displaySize.width / imageDimensions!.width;
    final scaleY = displaySize.height / imageDimensions!.height;

    for (int i = 0; i < textBlocks.length; i++) {
      final block = textBlocks[i];
      
      // Scale block coordinates from original image space to display space
      // Don't clamp individual coordinates - let them be drawn as-is
      // The ClipRRect will handle clipping at the edges
      final rect = Rect.fromLTRB(
        block.left * scaleX,
        block.top * scaleY,
        block.right * scaleX,
        block.bottom * scaleY,
      );

      // Skip invalid rectangles (where left >= right or top >= bottom)
      if (rect.isEmpty || rect.width <= 1 || rect.height <= 1) {
        continue;
      }

      final isSelected = selectedIndices.contains(i);
      final primaryColor = Color.lerp(const Color(0xFF6200EE), const Color(0xFF3700B3), 0.5) ?? const Color(0xFF6200EE);

      // Draw background with stronger opacity for better visibility
      final paint = Paint()
        ..color = isSelected 
            ? primaryColor.withOpacity(0.5)
            : Colors.grey.withOpacity(0.25)
        ..style = PaintingStyle.fill;
      
      canvas.drawRect(rect, paint);

      // Draw border with stronger color and visibility
      final borderPaint = Paint()
        ..color = isSelected 
            ? primaryColor.withOpacity(1.0)
            : primaryColor.withOpacity(0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = isSelected ? 3.5 : 2.5;
      
      canvas.drawRect(rect, borderPaint);

      // Draw corner indicators
      _drawCornerMarkers(
        canvas,
        rect,
        isSelected ? primaryColor : primaryColor.withOpacity(0.6),
        isSelected ? 12 : 9,
      );

      // Draw block number
      _drawBlockNumber(
        canvas,
        rect,
        i,
        isSelected,
        primaryColor,
      );
    }
  }

  void _drawCornerMarkers(Canvas canvas, Rect rect, Color color, double size) {
    final markerPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Top-left corner
    canvas.drawLine(Offset(rect.left, rect.top), Offset(rect.left + size, rect.top), markerPaint);
    canvas.drawLine(Offset(rect.left, rect.top), Offset(rect.left, rect.top + size), markerPaint);

    // Top-right corner
    canvas.drawLine(Offset(rect.right, rect.top), Offset(rect.right - size, rect.top), markerPaint);
    canvas.drawLine(Offset(rect.right, rect.top), Offset(rect.right, rect.top + size), markerPaint);

    // Bottom-left corner
    canvas.drawLine(Offset(rect.left, rect.bottom), Offset(rect.left + size, rect.bottom), markerPaint);
    canvas.drawLine(Offset(rect.left, rect.bottom), Offset(rect.left, rect.bottom - size), markerPaint);

    // Bottom-right corner
    canvas.drawLine(Offset(rect.right, rect.bottom), Offset(rect.right - size, rect.bottom), markerPaint);
    canvas.drawLine(Offset(rect.right, rect.bottom), Offset(rect.right, rect.bottom - size), markerPaint);
  }

  void _drawBlockNumber(Canvas canvas, Rect rect, int index, bool isSelected, Color baseColor) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: '${index + 1}',
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.white70,
          fontSize: isSelected ? 14 : 12,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              offset: const Offset(1, 1),
              blurRadius: 2,
              color: Colors.black.withOpacity(0.7),
            ),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    final badgeSize = isSelected ? 28.0 : 24.0;
    final badgeCenter = Offset(
      (rect.left + 12).clamp(badgeSize / 2, rect.right - badgeSize / 2),
      (rect.top + 12).clamp(badgeSize / 2, rect.bottom - badgeSize / 2),
    );

    // Draw badge background with full opacity
    final badgePaint = Paint()
      ..color = isSelected ? baseColor : baseColor.withOpacity(0.85)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(badgeCenter, badgeSize / 2, badgePaint);

    // Draw badge border with stronger visibility
    final badgeBorderPaint = Paint()
      ..color = Colors.white.withOpacity(isSelected ? 1.0 : 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(badgeCenter, badgeSize / 2, badgeBorderPaint);

    // Draw number
    textPainter.paint(
      canvas,
      Offset(
        badgeCenter.dx - textPainter.width / 2,
        badgeCenter.dy - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(TextBlockPainter oldDelegate) =>
      oldDelegate.selectedIndices != selectedIndices ||
      oldDelegate.textBlocks != textBlocks ||
      oldDelegate.imageDimensions != imageDimensions;
}

