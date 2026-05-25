import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../constants/app_constants.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with back button
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
              const SizedBox(height: 16),

              // Title
              Text(
                l10n.help,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 24),

              // Introduction
              _HelpSection(
              icon: Icons.info_outline,
              title: l10n.about_app,
              description: l10n.about_app_description,
            ),
            const SizedBox(height: AppDimensions.paddingLarge),

            // 1. How to Scan
            _HelpSection(
              icon: Icons.camera_alt_rounded,
              title: l10n.how_to_scan,
              description: l10n.how_to_scan_description,
              steps: [
                l10n.step1_open_scan,
                l10n.step2_capture_receipt,
                l10n.step3_confirm_text,
              ],
            ),
            const SizedBox(height: AppDimensions.paddingLarge),

            // 2. Text Selection
            _HelpSection(
              icon: Icons.touch_app,
              title: l10n.text_selection,
              description: l10n.text_selection_description,
              steps: [
                l10n.step1_tap_select_icon,
                l10n.step2_tap_text_regions,
                l10n.step3_confirm_selection,
              ],
            ),
            const SizedBox(height: AppDimensions.paddingLarge),

            // 3. Save Receipt
            _HelpSection(
              icon: Icons.save,
              title: l10n.how_to_save,
              description: l10n.how_to_save_description,
              steps: [
                l10n.step1_edit_text,
                l10n.step2_tap_save,
                l10n.step3_saved_successfully,
              ],
            ),
            const SizedBox(height: AppDimensions.paddingLarge),

            // 4. View Receipts
            _HelpSection(
              icon: Icons.receipt_rounded,
              title: l10n.how_to_view,
              description: l10n.how_to_view_description,
              steps: [
                l10n.step1_go_to_list,
                l10n.step2_tap_receipt,
                l10n.step3_view_details,
              ],
            ),
            const SizedBox(height: AppDimensions.paddingLarge),

            // 5. Delete Receipt
            _HelpSection(
              icon: Icons.delete_outline,
              title: l10n.how_to_delete,
              description: l10n.how_to_delete_description,
              steps: [
                l10n.step1_long_press_receipt,
                l10n.step2_confirm_delete,
              ],
            ),
            const SizedBox(height: AppDimensions.paddingLarge),

            // Tips Section
            _HelpSection(
              icon: Icons.lightbulb_outline,
              title: l10n.tips_and_tricks,
              description: l10n.tips_description,
              steps: [
                l10n.tip1_good_lighting,
                l10n.tip2_clear_image,
                l10n.tip3_select_accurate,
              ],
            ),
            const SizedBox(height: AppDimensions.paddingLarge),
          ],
        ),
      ),
      ),
    );
  }
}

class _HelpSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final List<String>? steps;

  const _HelpSection({
    required this.icon,
    required this.title,
    required this.description,
    this.steps,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          border: Border.all(
            color: colorScheme.outlineVariant.withOpacity(0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Icon and Title
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colorScheme.primaryContainer,
                          colorScheme.primaryContainer.withOpacity(0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withOpacity(0.15),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      icon,
                      color: colorScheme.primary,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.paddingMedium),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.paddingMedium),

              // Description
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurface.withOpacity(0.75),
                  height: 1.6,
                ),
              ),

              // Steps (if available)
              if (steps != null && steps!.isNotEmpty) ...[
                const SizedBox(height: AppDimensions.paddingMedium),
                ...List.generate(
                  steps!.length,
                  (index) => Padding(
                    padding: EdgeInsets.only(
                      top: index == 0 ? 0 : AppDimensions.paddingSmall,
                      bottom: AppDimensions.paddingSmall,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                colorScheme.primary,
                                colorScheme.primary.withOpacity(0.8),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: colorScheme.primary.withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppDimensions.paddingMedium),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 4.0,
                            ),
                            child: Text(
                              steps![index],
                              style: TextStyle(
                                fontSize: 14,
                                color: colorScheme.onSurface.withOpacity(0.85),
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
