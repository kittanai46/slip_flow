import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../view_models/slip_list_view_model.dart';
import '../constants/app_constants.dart';
import 'scan_screen.dart';
import 'slip_detail_screen.dart';

class SlipListScreen extends StatefulWidget {
  const SlipListScreen({super.key});

  @override
  State<SlipListScreen> createState() => _SlipListScreenState();
}

class _SlipListScreenState extends State<SlipListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SlipListViewModel>().loadSlips();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button and title
            Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingMedium),
              child: Row(
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
                      l10n.scanned_slips,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: _showFilterMenu,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Consumer<SlipListViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: AppDimensions.paddingMedium),
                  Text(viewModel.errorMessage ?? ''),
                  const SizedBox(height: AppDimensions.paddingMedium),
                  ElevatedButton(
                    onPressed: () => viewModel.loadSlips(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (viewModel.slips.isEmpty) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1),
                    Theme.of(context).colorScheme.primaryContainer.withOpacity(0.05),
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
                        color: Theme.of(context).colorScheme.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.receipt_long,
                        size: 64,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingLarge),
                    Text(
                      l10n.no_slips,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingSmall),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMedium),
                      child: Text(
                        'Start by scanning your first receipt',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingLarge),
                    FilledButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ScanScreen(),
                          ),
                        ).then((_) {
                          if (context.mounted) {
                            context.read<SlipListViewModel>().loadSlips();
                          }
                        });
                      },
                      icon: const Icon(Icons.camera_alt),
                      label: Text(l10n.scan),
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

          return ListView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingMedium,
              vertical: AppDimensions.paddingMedium,
            ),
            itemCount: viewModel.slips.length,
            itemBuilder: (context, index) {
              final slip = viewModel.slips[index];
              final dateStr =
                  '${slip.createdAt.day}/${slip.createdAt.month}/${slip.createdAt.year}';
              final previewText = slip.notes.isNotEmpty
                  ? slip.notes.replaceAll('\n', ' ').trim()
                  : '-';
              return Padding(
                padding: const EdgeInsets.only(bottom: AppDimensions.paddingMedium),
                child: Material(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                  elevation: 1,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SlipDetailScreen(slip: slip),
                        ),
                      );
                    },
                    onLongPress: () {
                      _showDeleteDialog(context, slip.id, viewModel);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                        border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .outlineVariant
                              .withOpacity(0.3),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                        child: Row(
                          children: [
                            // Receipt icon box with gradient background
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                    Theme.of(context)
                                        .colorScheme
                                        .primaryContainer
                                        .withOpacity(0.7),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(
                                    AppDimensions.radiusSmall),
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.2),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.receipt_long,
                                color:
                                    Theme.of(context).colorScheme.primary,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: AppDimensions.paddingMedium),
                            // Text content
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    dateStr,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      color:
                                          Theme.of(context).colorScheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    previewText.length > 50
                                        ? '${previewText.substring(0, 50)}...'
                                        : previewText,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Arrow with color
                            Icon(
                              Icons.chevron_right,
                              color: Theme.of(context).colorScheme.primary,
                              size: 22,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ScanScreen(),
            ),
          ).then((_) {
            if (context.mounted) {
              context.read<SlipListViewModel>().loadSlips();
            }
          });
        },
        icon: const Icon(Icons.camera),
        label: Text(AppLocalizations.of(context)!.scan),
      ),
    );
  }

  void _showFilterMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Filter by Category'),
              onTap: () {
                Navigator.pop(context);
                _showCategoryFilter();
              },
            ),
            ListTile(
              title: const Text('Filter by Date Range'),
              onTap: () {
                Navigator.pop(context);
                _showDateRangeFilter();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCategoryFilter() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Category'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            itemCount: AppConstants.slipCategories.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(AppConstants.slipCategories[index]),
                onTap: () {
                  context
                      .read<SlipListViewModel>()
                      .filterByCategory(AppConstants.slipCategories[index]);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showDateRangeFilter() {
    // TODO: Implement date range filter
  }

  void _showDeleteDialog(BuildContext context, String slipId,
      SlipListViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Receipt'),
        content: const Text('Are you sure you want to delete this receipt?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              viewModel.deleteSlip(slipId);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
