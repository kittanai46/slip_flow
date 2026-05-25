import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/locale_provider.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeProvider = Provider.of<LocaleProvider>(context, listen: true);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 20,
          ),
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
              const SizedBox(height: 20),

              // Title
              Text(
                l10n.settings,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 24),

              // Language Selection Card
              _SettingCard(
              icon: Icons.language,
              title: l10n.language,
              child: _LanguageSelector(
                currentLocale: localeProvider.locale.languageCode,
                onChanged: (language) {
                  localeProvider.setLocale(language);
                },
              ),
            ),
            const SizedBox(height: 24),

            // Theme Mode Selection Card
            _SettingCard(
              icon: Icons.brightness_4,
              title: l10n.theme,
              child: _ThemeModeSelector(
                currentMode: themeProvider.themeMode,
                onChanged: (mode) {
                  themeProvider.setThemeMode(mode);
                },
                l10n: l10n,
              ),
            ),
            const SizedBox(height: 24),

            // Theme Color Selection Card
            _SettingCard(
              icon: Icons.palette,
              title: 'Color Theme',
              child: _ColorSelector(
                currentColor: themeProvider.seedColor,
                onChanged: (color) {
                  themeProvider.setSeedColor(color);
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      ),
    );
  }
}

class _SettingCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const _SettingCard({
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.outlineVariant.withOpacity(0.3),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      size: 24,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  final String currentLocale;
  final Function(String) onChanged;

  const _LanguageSelector({
    required this.currentLocale,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _LanguageButton(
            label: 'English',
            isSelected: currentLocale == 'en',
            onPressed: () => onChanged('en'),
            icon: Icons.language,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _LanguageButton(
            label: 'ไทย',
            isSelected: currentLocale == 'th',
            onPressed: () => onChanged('th'),
            icon: Icons.language,
          ),
        ),
      ],
    );
  }
}

class _LanguageButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;
  final IconData icon;

  const _LanguageButton({
    required this.label,
    required this.isSelected,
    required this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: isSelected ? colorScheme.primary : colorScheme.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? colorScheme.primary : colorScheme.outlineVariant.withOpacity(0.3),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: isSelected ? Colors.white : colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : colorScheme.onSurface,
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

class _ThemeModeSelector extends StatelessWidget {
  final ThemeMode currentMode;
  final Function(ThemeMode) onChanged;
  final AppLocalizations? l10n;

  const _ThemeModeSelector({
    required this.currentMode,
    required this.onChanged,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ThemeModeButton(
          icon: Icons.wb_sunny,
          label: l10n?.light_mode ?? 'Light',
          isSelected: currentMode == ThemeMode.light,
          onPressed: () => onChanged(ThemeMode.light),
        ),
        const SizedBox(height: 12),
        _ThemeModeButton(
          icon: Icons.brightness_3,
          label: l10n?.dark_mode ?? 'Dark',
          isSelected: currentMode == ThemeMode.dark,
          onPressed: () => onChanged(ThemeMode.dark),
        ),
        const SizedBox(height: 12),
        _ThemeModeButton(
          icon: Icons.brightness_auto,
          label: l10n?.system_mode ?? 'System',
          isSelected: currentMode == ThemeMode.system,
          onPressed: () => onChanged(ThemeMode.system),
        ),
      ],
    );
  }
}

class _ThemeModeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  const _ThemeModeButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: Colors.green)
          : const Icon(Icons.circle_outlined),
      onTap: onPressed,
      selected: isSelected,
    );
  }
}

class _ColorSelector extends StatelessWidget {
  final Color currentColor;
  final Function(Color) onChanged;

  const _ColorSelector({
    required this.currentColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemCount: ThemeProvider.themeColors.length,
      itemBuilder: (context, index) {
        final color = ThemeProvider.themeColors[index];
        final isSelected = currentColor.value == color.value;
        return GestureDetector(
          onTap: () => onChanged(color),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(
                      color: Colors.white,
                      width: 3,
                    )
                  : Border.all(
                      color: Colors.grey.withOpacity(0.3),
                      width: 1,
                    ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: color.withOpacity(0.6),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: isSelected
                ? const Center(
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 24,
                    ),
                  )
                : null,
          ),
        );
      },
    );
  }
}
