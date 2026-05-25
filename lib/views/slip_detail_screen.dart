import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../l10n/app_localizations.dart';
import '../models/slip_model.dart';
import '../view_models/slip_list_view_model.dart';

class SlipDetailScreen extends StatelessWidget {
  final Slip slip;

  const SlipDetailScreen({required this.slip, super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dateStr =
        '${slip.createdAt.day}/${slip.createdAt.month}/${slip.createdAt.year}';
    final timeStr =
        '${slip.createdAt.hour.toString().padLeft(2, '0')}:${slip.createdAt.minute.toString().padLeft(2, '0')}';

    return Scaffold(

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with back button and delete button
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.paddingMedium),
                  Icon(
                    Icons.receipt_long,
                    size: 24,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.receipt_details,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _showDeleteDialog(context, l10n),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.paddingMedium),
            // Image with enhanced styling
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                child: File(slip.imagePath).existsSync()
                    ? Image.file(
                        File(slip.imagePath),
                        width: double.infinity,
                        height: 240,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: double.infinity,
                        height: 240,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                        ),
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          size: 64,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: AppDimensions.paddingMedium),

            // Date & time card
            Container(
              padding: const EdgeInsets.all(AppDimensions.paddingMedium),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                    ),
                    child: Icon(
                      Icons.access_time,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Date & Time',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$dateStr  $timeStr',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.paddingMedium),

            // Scanned text card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimensions.paddingMedium),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.3),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                        ),
                        child: Icon(
                          Icons.text_snippet_outlined,
                          size: 20,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Scanned Text',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.primary,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.paddingMedium),
                  Divider(
                    height: 1,
                    color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.3),
                  ),
                  const SizedBox(height: AppDimensions.paddingMedium),
                  SelectableText(
                    slip.notes.isNotEmpty ? slip.notes : l10n.no_text,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.7,
                      color: slip.notes.isNotEmpty
                          ? Theme.of(context).colorScheme.onSurface
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.delete_receipt),
        content: Text(l10n.delete_receipt_confirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              await context
                  .read<SlipListViewModel>()
                  .deleteSlip(slip.id);
              if (context.mounted) Navigator.pop(context);
            },
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }
}
