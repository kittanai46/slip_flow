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

      if (text.isNotEmpty) {
        Logger.info('✅ Text recognized successfully!');
        Logger.info('Extracted text length: ${text.length} characters');
        Logger.info('===== EXTRACTED TEXT =====');
        Logger.info(text);
        Logger.info('===========================');

        return ScanResult(
          rawText: text,
          isSuccessful: true,
        );
      }

      Logger.info('⚠️ No text found in image - using manual entry mode');
      return ScanResult(
        rawText: '',
        isSuccessful: false,
      );
    } catch (e) {
      Logger.error('Failed to process image', e);
      return ScanResult(
        rawText: '',
        isSuccessful: false,
      );
    }
  }
}

