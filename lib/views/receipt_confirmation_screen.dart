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
  late TextEditingController _storeNameController;
  late TextEditingController _amountController;
  late TextEditingController _dateController;
  late TextEditingController _notesController;
  String? _selectedCategory = 'Other';

  @override
  void initState() {
    super.initState();
    final viewModel = context.read<SlipScanViewModel>();
    final slip = viewModel.currentSlip;
    
    // Use scanned data if available, otherwise use current slip or empty
    final storeName = widget.scannedData?.storeName ?? slip?.storeName ?? '';
    final amount = widget.scannedData?.amount ?? slip?.amount ?? 0.0;
    final date = widget.scannedData?.date ?? slip?.date ?? DateTime.now();
    final category = slip?.category ?? 'Other';
    // Include raw OCR text in notes if available but extraction failed
    final rawOcrText = widget.scannedData?.rawText ?? '';
    final notes = slip?.notes ?? '';
    final combinedNotes = rawOcrText.isNotEmpty && widget.scannedData != null && !widget.scannedData!.isSuccessful
        ? '$rawOcrText\n\n$notes'
        : notes;

    _storeNameController = TextEditingController(text: storeName);
    _amountController = TextEditingController(text: amount.toString());
    _dateController = TextEditingController(
      text: date.toString().split(' ')[0], // Format: YYYY-MM-DD
    );
    _selectedCategory = category;
    _notesController = TextEditingController(text: combinedNotes);
  }

  @override
  void dispose() {
    _storeNameController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.check_circle, size: 24),
            const SizedBox(width: 8),
            Text(l10n.scan_receipt),
          ],
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              context.read<SlipScanViewModel>().reset();
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
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // OCR Status Indicator
            if (widget.scannedData != null)
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingMedium,
                  vertical: AppDimensions.paddingSmall,
                ),
                padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                decoration: BoxDecoration(
                  color: widget.scannedData!.isSuccessful
                      ? Colors.green.withOpacity(0.1)
                      : Colors.orange.withOpacity(0.1),
                  border: Border.all(
                    color: widget.scannedData!.isSuccessful
                        ? Colors.green
                        : Colors.orange,
                  ),
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusMedium),
                ),
                child: Row(
                  children: [
                    Icon(
                      widget.scannedData!.isSuccessful
                          ? Icons.check_circle
                          : Icons.info,
                      color: widget.scannedData!.isSuccessful
                          ? Colors.green
                          : Colors.orange,
                    ),
                    const SizedBox(width: AppDimensions.paddingMedium),
                    Expanded(
                      child: Text(
                        widget.scannedData!.isSuccessful
                            ? 'OCR extraction successful'
                            : 'OCR extraction failed - please fill in details manually',
                        style: TextStyle(
                          color: widget.scannedData!.isSuccessful
                              ? Colors.green
                              : Colors.orange,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            // Edit form
            _buildEditForm(context, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildEditForm(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _storeNameController,
            decoration: InputDecoration(
              labelText: 'Store Name',
              prefixIcon: const Icon(Icons.store),
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          TextField(
            controller: _amountController,
            decoration: InputDecoration(
              labelText: 'Amount',
              prefixIcon: const Icon(Icons.attach_money),
              prefixText: '฿ ',
              border: const OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          TextField(
            controller: _dateController,
            decoration: InputDecoration(
              labelText: 'Date (YYYY-MM-DD)',
              prefixIcon: const Icon(Icons.calendar_today),
              border: const OutlineInputBorder(),
            ),
            readOnly: true,
            onTap: () async {
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null) {
                _dateController.text =
                    pickedDate.toString().split(' ')[0];
              }
            },
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            decoration: InputDecoration(
              labelText: 'Category',
              prefixIcon: const Icon(Icons.category),
              border: const OutlineInputBorder(),
            ),
            items: AppConstants.slipCategories
                .map((category) => DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedCategory = value;
              });
            },
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          TextField(
            controller: _notesController,
            decoration: InputDecoration(
              labelText: 'Notes',
              prefixIcon: const Icon(Icons.note),
              border: const OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: AppDimensions.paddingLarge),
          ElevatedButton.icon(
            onPressed: () => _saveSlip(context),
            icon: const Icon(Icons.save),
            label: Text(l10n.save),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  void _saveSlip(BuildContext context) async {
    if (_storeNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter store name')),
      );
      return;
    }

    if (_amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter amount')),
      );
      return;
    }

    try {
      final viewModel = context.read<SlipScanViewModel>();
      await viewModel.saveSlip(
        storeName: _storeNameController.text,
        amount: double.parse(_amountController.text),
        date: DateTime.parse(_dateController.text),
        category: _selectedCategory ?? 'Other',
        notes: _notesController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Receipt saved successfully!')),
        );
        Navigator.pop(context);
        Navigator.pop(context); // Go back to scan screen
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
