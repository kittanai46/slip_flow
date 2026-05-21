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
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.settings, size: 24),
            const SizedBox(width: 8),
            Text(l10n.settings),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Language Selection
            _SectionHeader(
              icon: Icons.language,
              title: l10n.language,
            ),
            const SizedBox(height: 12),
            _LanguageSelector(
              currentLocale: localeProvider.locale.languageCode,
              onChanged: (language) {
                localeProvider.setLocale(language);
              },
            ),
            const SizedBox(height: 32),

            // Theme Mode Selection
            _SectionHeader(
              icon: Icons.brightness_4,
              title: l10n.theme,
            ),
            const SizedBox(height: 12),
            _ThemeModeSelector(
              currentMode: themeProvider.themeMode,
              onChanged: (mode) {
                themeProvider.setThemeMode(mode);
              },
              l10n: l10n,
            ),
            const SizedBox(height: 32),

            // Theme Color Selection
            _SectionHeader(
              icon: Icons.palette,
              title: 'Color Theme',
            ),
            const SizedBox(height: 12),
            _ColorSelector(
              currentColor: themeProvider.seedColor,
              onChanged: (color) {
                themeProvider.setSeedColor(color);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionHeader({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 24),
        const SizedBox(width: 12),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
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
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected
            ? Theme.of(context).primaryColor
            : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(label),
        ],
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
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: ThemeProvider.themeColors.length,
      itemBuilder: (context, index) {
        final color = ThemeProvider.themeColors[index];
        final isSelected = currentColor.value == color.value;
        return GestureDetector(
          onTap: () => onChanged(color),
          child: Container(
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(color: Colors.white, width: 4)
                  : Border.all(color: Colors.grey, width: 1),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: color.withOpacity(0.5),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
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
