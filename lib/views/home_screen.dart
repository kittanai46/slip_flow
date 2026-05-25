import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../l10n/app_localizations.dart';
import '../providers/locale_provider.dart';
import '../providers/theme_provider.dart';
import 'scan_screen.dart';
import 'slip_list_screen.dart';
import 'settings_screen.dart';
import 'help_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Theme and Language toggle bar
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.paddingLarge,
                AppDimensions.paddingLarge * 2,
                AppDimensions.paddingLarge,
                AppDimensions.paddingSmall/2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Language toggle
                  Consumer<LocaleProvider>(
                    builder: (context, localeProvider, _) {
                      final isEn = localeProvider.locale.languageCode == 'en';
                      return Container(
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: colorScheme.outlineVariant.withOpacity(0.3),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () {
                            localeProvider.setLocale(isEn ? 'th' : 'en');
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.translate,
                                  size: 18,
                                  color: colorScheme.primary,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  isEn ? 'EN' : 'TH',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: AppDimensions.paddingSmall),
                  // Theme toggle
                  Consumer<ThemeProvider>(
                    builder: (context, themeProvider, _) {
                      return Container(
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: colorScheme.outlineVariant.withOpacity(0.3),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          iconSize: 20,
                          constraints: const BoxConstraints(
                            minWidth: 40,
                            minHeight: 40,
                          ),
                          icon: Icon(
                            themeProvider.themeMode == ThemeMode.dark
                                ? Icons.light_mode
                                : Icons.dark_mode,
                            color: colorScheme.primary,
                          ),
                          onPressed: () {
                            final newMode =
                                themeProvider.themeMode == ThemeMode.dark
                                    ? ThemeMode.light
                                    : ThemeMode.dark;
                            themeProvider.setThemeMode(newMode);
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            // Hero banner
            Container(
              margin: const EdgeInsets.fromLTRB(
                AppDimensions.paddingMedium,
                AppDimensions.paddingSmall,
                AppDimensions.paddingMedium,
                0,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primary,
                    colorScheme.primary.withOpacity(0.65),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingLarge),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.appName,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            l10n.scripslipflowe,
                            style: TextStyle(
                              fontSize: 13,
                              color: colorScheme.onPrimary.withOpacity(0.85),
                            ),
                          ),
                          const SizedBox(height: AppDimensions.paddingMedium),
                          FilledButton.tonal(
                            style: FilledButton.styleFrom(
                              backgroundColor: colorScheme.onPrimary.withOpacity(0.9),
                              foregroundColor: colorScheme.primary,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                              ),
                            ),
                            onPressed: () {
                              _showScanSourceSheet(context);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.camera_alt, size: 18),
                                const SizedBox(width: 6),
                                Text(l10n.scan),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.receipt_long,
                      size: 60,
                      color: colorScheme.onPrimary.withOpacity(0.2),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.paddingLarge),
            // Quick actions header
            Padding(
              padding: const EdgeInsets.only(
                left: AppDimensions.paddingLarge,
                right: AppDimensions.paddingLarge,
                bottom: AppDimensions.paddingSmall/10,
              ),
              child: Text(
                l10n.menu,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            const SizedBox(height: 0),
            // Quick actions grid
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingLarge,
              ),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: AppDimensions.paddingLarge,
                mainAxisSpacing: AppDimensions.paddingMedium,
                childAspectRatio: 0.95,
                children: [
                  _buildActionCard(
                    context: context,
                    icon: Icons.camera_alt_rounded,
                    title: l10n.scan_receipt,
                    color: colorScheme.primaryContainer,
                    iconColor: colorScheme.primary,
                    onTap: () => _showScanSourceSheet(context),
                  ),
                  _buildActionCard(
                    context: context,
                    icon: Icons.receipt_rounded,
                    title: l10n.scanned_slips,
                    color: colorScheme.secondaryContainer,
                    iconColor: colorScheme.secondary,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SlipListScreen(),
                        ),
                      );
                    },
                  ),
                  _buildActionCard(
                    context: context,
                    icon: Icons.help_outline_rounded,
                    title: l10n.help,
                    color: colorScheme.tertiaryContainer,
                    iconColor: colorScheme.tertiary,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HelpScreen(),
                        ),
                      );
                    },
                  ),
                  _buildActionCard(
                    context: context,
                    icon: Icons.settings_rounded,
                    title: l10n.settings,
                    color: colorScheme.surfaceContainerHighest,
                    iconColor: colorScheme.onSurfaceVariant,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.paddingLarge),
          ],
          ),
        ),
      );
    }

  void _showScanSourceSheet(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Text(
                  l10n.scan_receipt,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: colorScheme.primaryContainer,
                    child: Icon(Icons.camera_alt_rounded, color: colorScheme.primary),
                  ),
                  title: Text(l10n.camera),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ScanScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: colorScheme.secondaryContainer,
                    child: Icon(Icons.photo_library_rounded, color: colorScheme.secondary),
                  ),
                  title: Text(l10n.gallery),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ScanScreen(fromGallery: true),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                  ),
                  child: Icon(icon, size: 40, color: iconColor),
                ),
                const SizedBox(height: AppDimensions.paddingMedium),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: iconColor,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
