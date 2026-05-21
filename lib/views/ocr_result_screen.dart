import 'dart:io';
import 'package:flutter/material.dart';
import '../models/scan_result_model.dart';
import '../constants/app_constants.dart';

class OCRResultScreen extends StatefulWidget {
  final String imagePath;
  final ScanResult scannedData;

  const OCRResultScreen({
    required this.imagePath,
    required this.scannedData,
    super.key,
  });

  @override
  State<OCRResultScreen> createState() => _OCRResultScreenState();
}

class _OCRResultScreenState extends State<OCRResultScreen> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    // Show extracted text if successful, otherwise empty for manual entry
    final initialText = widget.scannedData.isSuccessful 
        ? widget.scannedData.rawText 
        : '';
    _textController = TextEditingController(text: initialText);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isManualEntry = !widget.scannedData.isSuccessful;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(isManualEntry ? 'Enter Receipt Details' : 'OCR Result'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image preview
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
            // Status indicator
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingMedium,
                vertical: AppDimensions.paddingSmall,
              ),
              padding: const EdgeInsets.all(AppDimensions.paddingMedium),
              decoration: BoxDecoration(
                color: isManualEntry
                    ? Colors.blue.withOpacity(0.1)
                    : Colors.green.withOpacity(0.1),
                border: Border.all(
                  color: isManualEntry ? Colors.blue : Colors.green,
                ),
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              ),
              child: Row(
                children: [
                  Icon(
                    isManualEntry ? Icons.edit : Icons.check_circle,
                    color: isManualEntry ? Colors.blue : Colors.green,
                  ),
                  const SizedBox(width: AppDimensions.paddingMedium),
                  Expanded(
                    child: Text(
                      isManualEntry
                          ? 'Please review the image and enter details'
                          : 'Text detected successfully',
                      style: TextStyle(
                        color: isManualEntry ? Colors.blue : Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Instructions or extracted text info
            if (widget.scannedData.rawText.isNotEmpty && isManualEntry)
              Container(
                margin: const EdgeInsets.all(AppDimensions.paddingMedium),
                padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                  border: Border.all(
                    color: Colors.blue.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  widget.scannedData.rawText,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: Colors.black87,
                  ),
                ),
              ),
            // Text field for review/editing
            Container(
              margin: const EdgeInsets.all(AppDimensions.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isManualEntry ? 'Receipt Details (Manual Entry)' : 'Extracted Text from Image',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isManualEntry ? Colors.orange : Colors.green,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingSmall),
                  TextField(
                    controller: _textController,
                    maxLines: 8,
                    readOnly: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusMedium,
                        ),
                        borderSide: BorderSide(
                          color: isManualEntry ? Colors.orange : Colors.green,
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusMedium,
                        ),
                        borderSide: BorderSide(
                          color: isManualEntry ? Colors.orange : Colors.green,
                          width: 2,
                        ),
                      ),
                      hintText: isManualEntry
                          ? 'Enter receipt text or details...'
                          : 'Extracted text from receipt...',
                      contentPadding: const EdgeInsets.all(
                        AppDimensions.paddingMedium,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Action Buttons
            Container(
              margin: const EdgeInsets.all(AppDimensions.paddingMedium),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Retake'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppDimensions.paddingMedium,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.paddingMedium),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context, _textController.text);
                      },
                      icon: const Icon(Icons.check),
                      label: const Text('Confirm'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppDimensions.paddingMedium,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
