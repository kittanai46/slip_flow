import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

/// Example screen demonstrating how to add icons next to text/buttons
class IconsExampleScreen extends StatelessWidget {
  const IconsExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.star, size: 24),
            const SizedBox(width: 8),
            const Text('Icons Examples'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Icon with Text in a Row
            _ExampleSection(
              title: 'Icons with Text (Row)',
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.home),
                      const SizedBox(width: 8),
                      Text(l10n.home),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.settings),
                      const SizedBox(width: 8),
                      Text(l10n.settings),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 2. ElevatedButton with Icon
            _ExampleSection(
              title: 'ElevatedButton with Icon',
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.camera, size: 20),
                        const SizedBox(width: 8),
                        Text(l10n.scan),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add),
                    label: Text(l10n.add),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 3. TextButton with Icon
            _ExampleSection(
              title: 'TextButton with Icon',
              child: Column(
                children: [
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.arrow_back),
                    label: Text(l10n.back),
                  ),
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.delete),
                    label: Text(l10n.delete),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 4. OutlinedButton with Icon
            _ExampleSection(
              title: 'OutlinedButton with Icon',
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download),
                label: const Text('Download'),
              ),
            ),
            const SizedBox(height: 24),

            // 5. ListTile with Icon
            _ExampleSection(
              title: 'ListTile with Icon',
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.image),
                    title: const Text('Gallery'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    leading: const Icon(Icons.camera_alt),
                    title: Text(l10n.camera),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 6. Card with Icon
            _ExampleSection(
              title: 'Card with Icon',
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.receipt_long,
                          color: Theme.of(context).primaryColor,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Scanned Receipt',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            const Text('May 20, 2026'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 7. FloatingActionButton with Icon
            _ExampleSection(
              title: 'FloatingActionButton',
              child: Row(
                children: [
                  Column(
                    children: [
                      FloatingActionButton(
                        onPressed: () {},
                        child: const Icon(Icons.add),
                      ),
                      const SizedBox(height: 8),
                      const Text('FAB'),
                    ],
                  ),
                  const SizedBox(width: 24),
                  Column(
                    children: [
                      FloatingActionButton.extended(
                        onPressed: () {},
                        icon: const Icon(Icons.camera),
                        label: Text(l10n.scan),
                      ),
                      const SizedBox(height: 8),
                      const Text('Extended FAB'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 8. Icon with colored background
            _ExampleSection(
              title: 'Icon with Background',
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.check, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.done_all, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 9. Icon Badge
            _ExampleSection(
              title: 'Icon with Badge',
              child: Stack(
                children: [
                  const Icon(Icons.notifications, size: 32),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        '5',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
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

class _ExampleSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _ExampleSection({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: child,
        ),
      ],
    );
  }
}
