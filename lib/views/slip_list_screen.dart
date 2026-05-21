import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../view_models/slip_list_view_model.dart';
import '../constants/app_constants.dart';
import 'scan_screen.dart';

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
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.receipt_long, size: 24),
            const SizedBox(width: 8),
            Text(l10n.scanned_slips),
          ],
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterMenu,
          ),
        ],
      ),
      body: Consumer<SlipListViewModel>(
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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.receipt_long, size: 64, color: Colors.grey),
                  const SizedBox(height: AppDimensions.paddingMedium),
                  Text(l10n.no_slips),
                  const SizedBox(height: AppDimensions.paddingMedium),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ScanScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: Text(l10n.scan),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            itemCount: viewModel.slips.length,
            itemBuilder: (context, index) {
              final slip = viewModel.slips[index];
              return Card(
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusSmall),
                    child: Container(
                      width: 50,
                      height: 50,
                      color: Colors.grey[300],
                      child: const Icon(Icons.receipt),
                    ),
                  ),
                  title: Text(slip.storeName),
                  subtitle: Text(slip.category),
                  trailing: Text(
                    '฿${slip.amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  onTap: () {
                    // TODO: Navigate to detail screen
                  },
                  onLongPress: () {
                    _showDeleteDialog(context, slip.id, viewModel);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ScanScreen(),
            ),
          );
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
