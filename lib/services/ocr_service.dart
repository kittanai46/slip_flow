import 'dart:io';
import 'package:ocr_scan/ocr_scan.dart';
import '../models/scan_result_model.dart';
import '../utils/logger.dart';

abstract class OCRService {
  Future<ScanResult> extractTextFromImage(String imagePath);
  Future<void> dispose();
}

class OCRServiceImpl implements OCRService {
  final TextRecognizer _textRecognizer = TextRecognizer();
  bool _disposed = false;

  @override
  Future<void> dispose() async {
    _disposed = true;
    await _textRecognizer.close();
  }

  @override
  Future<ScanResult> extractTextFromImage(String imagePath) async {
    if (_disposed) {
      throw Exception('OCR service has been disposed');
    }

    try {
      Logger.info('Extracting text from image: $imagePath');

      final file = File(imagePath);
      if (!await file.exists()) {
        throw Exception('Image file not found');
      }

      final inputImage = InputImage.fromFilePath(imagePath);
      final recognizedText = await _textRecognizer.processImage(inputImage);
      final text = recognizedText.text.trim();

      // Extract text blocks with bounding boxes
      final textBlocks = <ScannedTextBlock>[];
      for (final block in recognizedText.blocks) {
        final boundingBox = block.boundingBox;
        textBlocks.add(
          ScannedTextBlock(
            text: block.text.trim(),
            left: boundingBox.left.toDouble(),
            top: boundingBox.top.toDouble(),
            right: boundingBox.right.toDouble(),
            bottom: boundingBox.bottom.toDouble(),
          ),
        );
      }

      if (text.isNotEmpty) {
        Logger.info('✅ Text recognized successfully!');
        Logger.info('Extracted text length: ${text.length} characters');
        Logger.info('Text blocks found: ${textBlocks.length}');
        Logger.info('===== EXTRACTED TEXT =====');
        Logger.info(text);
        Logger.info('===========================');

        return ScanResult(
          rawText: text,
          isSuccessful: true,
          textBlocks: textBlocks,
        );
      }

      Logger.info('⚠️ No text found in image - using manual entry mode');
      return ScanResult(
        rawText: '',
        isSuccessful: false,
        textBlocks: [],
      );
    } catch (e) {
      Logger.error('Failed to process image', e);
      return ScanResult(
        rawText: '',
        isSuccessful: false,
        textBlocks: [],
      );
    }
  }
}


