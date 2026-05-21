# OCR Integration Guide

## Current Status ✅
The app now builds successfully with a **mock OCR implementation**. The OCRService currently returns dummy data to allow development to proceed.

## How to Integrate Real OCR

### Option 1: Google ML Kit Text Recognition (Recommended)

**Status**: The package has namespace issues in older versions. Use version 0.7.0 or wait for newer fixes.

**Steps:**
1. Update `pubspec.yaml`:
```yaml
dependencies:
  google_mlkit_text_recognition: ^0.7.0  # Use older stable version
```

2. Update `lib/services/ocr_service.dart`:
```dart
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OCRServiceImpl implements OCRService {
  late TextRecognizer _textRecognizer;

  @override
  Future<ScanResult> extractTextFromImage(String imagePath) async {
    try {
      _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
      
      final inputImage = InputImage.fromFilePath(imagePath);
      final recognizedText = await _textRecognizer.processImage(inputImage);
      
      final storeName = _parseStoreName(recognizedText.text);
      final amount = _parseAmount(recognizedText.text);
      final date = _parseDate(recognizedText.text);
      
      return ScanResult(
        storeName: storeName,
        amount: amount,
        date: date,
        rawText: recognizedText.text,
        isSuccessful: true,
      );
    } catch (e) {
      Logger.error('Failed to extract text', e);
      return ScanResult(rawText: '', isSuccessful: false);
    } finally {
      _textRecognizer.close();
    }
  }
}
```

### Option 2: Firebase ML Kit

**Setup:**
1. Add to `pubspec.yaml`:
```yaml
dependencies:
  firebase_core: ^2.0.0
  firebase_ml_vision: ^0.7.0
```

2. Configure Firebase in your project (requires Firebase Console setup)

### Option 3: Tesseract OCR

**Setup:**
1. Add to `pubspec.yaml`:
```yaml
dependencies:
  tesseract_ocr: ^0.3.11
```

2. Simpler setup, no API keys needed

### Option 4: AWS Textract (for advanced features)

**Setup:**
1. Add to `pubspec.yaml`:
```yaml
dependencies:
  aws_textract: ^1.0.0
```

2. Requires AWS credentials and backend integration

## Text Parsing Functions

Replace the TODO methods in `ocr_service.dart`:

### Parse Store Name
```dart
String? _parseStoreName(String text) {
  final lines = text.split('\n');
  // Usually the store name is in the first few lines
  if (lines.isNotEmpty) {
    return lines.first.trim();
  }
  return null;
}
```

### Parse Amount
```dart
double? _parseAmount(String text) {
  // Look for currency symbols and numbers
  final regex = RegExp(r'฿\s*([\d,]+\.?\d*)');
  final match = regex.firstMatch(text);
  
  if (match != null) {
    final amount = match.group(1)?.replaceAll(',', '');
    return double.tryParse(amount ?? '');
  }
  return null;
}
```

### Parse Date
```dart
DateTime? _parseDate(String text) {
  // Look for common date formats
  final regex = RegExp(
    r'(\d{1,2})[/-](\d{1,2})[/-](\d{2,4})',
  );
  final match = regex.firstMatch(text);
  
  if (match != null) {
    try {
      final day = int.parse(match.group(1) ?? '1');
      final month = int.parse(match.group(2) ?? '1');
      final year = int.parse(match.group(3) ?? '2026');
      
      return DateTime(year, month, day);
    } catch (e) {
      Logger.error('Error parsing date', e);
    }
  }
  return null;
}
```

## Testing the Mock OCR

The current implementation returns mock data:
- **Store Name**: "Sample Store"
- **Amount**: ฿299.50
- **Date**: Current date
- **Transaction ID**: "TXN-123456"

To test the flow:
1. Navigate to Scan Screen
2. Click camera button
3. The mock OCR will extract "Sample Store" and ฿299.50
4. Edit the details if needed
5. Save the receipt

## Recommended OCR Service Comparison

| Service | Pros | Cons | Cost |
|---------|------|------|------|
| **Google ML Kit** | Fast, offline, good accuracy | Setup can be complex | Free |
| **Firebase ML Kit** | Easy setup with Firebase | Requires Firebase | Free tier available |
| **Tesseract** | No API keys, simple | Slower, less accurate | Free |
| **AWS Textract** | Highest accuracy, advanced features | Slower, requires backend | $0.015 per page |

## Integration Checklist

- [ ] Choose OCR service
- [ ] Add dependency to `pubspec.yaml`
- [ ] Configure platform-specific settings (if needed)
- [ ] Implement `_parseStoreName()` method
- [ ] Implement `_parseAmount()` method
- [ ] Implement `_parseDate()` method
- [ ] Test with real receipts
- [ ] Handle edge cases and errors
- [ ] Optimize for performance

## Current Mock Implementation

**File**: `lib/services/ocr_service.dart`

The mock implementation:
- ✅ Validates image file exists
- ✅ Returns proper ScanResult structure
- ✅ Has TODO markers for real implementation
- ✅ Includes error handling
- ✅ Logs operations for debugging

## Troubleshooting

### Common Issues

**Issue**: "Image file not found"
- **Solution**: Ensure camera service properly saves the image file

**Issue**: Namespace error in Google ML Kit
- **Solution**: Use version 0.7.0 or check for updates

**Issue**: OCR taking too long
- **Solution**: Process on background thread, show loading spinner

**Issue**: Poor text recognition accuracy
- **Solution**: Try different OCR services, preprocess image (contrast, rotation)

## Next Steps

1. **Choose an OCR service** from the options above
2. **Update pubspec.yaml** with the chosen package
3. **Run `flutter pub get`**
4. **Implement the parsing functions** for your receipt format
5. **Test with real receipts**
6. **Monitor performance** and adjust if needed

## Performance Tips

- Cache the text recognizer instance if using ML Kit
- Process images in a background isolate for large images
- Compress images before OCR for faster processing
- Add a timeout to prevent hanging

## Resources

- [Google ML Kit Documentation](https://developers.google.com/ml-kit/text-recognition)
- [Firebase ML Kit Guide](https://firebase.flutter.dev/docs/ml-kit/overview)
- [Tesseract Flutter Package](https://pub.dev/packages/tesseract_ocr)
- [AWS Textract Documentation](https://docs.aws.amazon.com/textract/)
