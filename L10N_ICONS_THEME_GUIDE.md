# L10n, Icons, and Theme Guide

## Overview
This guide explains how to use localization (l10n), add icons to your UI, and customize themes in your Flutter application.

---

## 1. LOCALIZATION (L10n) - Thai & English

### What was set up:
- `lib/l10n/` - Localization files directory
  - `app_en.arb` - English translations
  - `app_th.arb` - Thai translations
- `l10n.yaml` - Localization configuration
- `LocaleProvider` - Provider for managing language switching

### How to use translations in your code:

```dart
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appName),  // Will show "Slip Flow" or "สลิป ไฟโล"
      ),
      body: Column(
        children: [
          Text(l10n.scan),           // "Scan" or "สแกน"
          Text(l10n.settings),       // "Settings" or "การตั้งค่า"
          Text(l10n.home),           // "Home" or "หน้าแรก"
        ],
      ),
    );
  }
}
```

### Adding new translations:

1. Open `lib/l10n/app_en.arb` and add a new key:
```json
{
  "myNewString": "Hello World"
}
```

2. Open `lib/l10n/app_th.arb` and add the Thai translation:
```json
{
  "myNewString": "สวัสดีชาวโลก"
}
```

3. Run this command to generate the localization files:
```bash
flutter gen-l10n
```

4. Use it in your code:
```dart
final l10n = AppLocalizations.of(context);
print(l10n.myNewString);  // Automatically uses current language
```

### Switching language:

```dart
final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
localeProvider.setLocale('th');  // Switch to Thai
localeProvider.setLocale('en');  // Switch to English
```

---

## 2. ICONS - Adding Icons Next to Text

### Icon with Text (Basic):
```dart
Row(
  children: [
    const Icon(Icons.home),
    const SizedBox(width: 8),
    Text(l10n.home),
  ],
)
```

### ElevatedButton with Icon:
```dart
// Option 1: Custom Row
ElevatedButton(
  onPressed: () {},
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      const Icon(Icons.camera),
      const SizedBox(width: 8),
      Text(l10n.scan),
    ],
  ),
)

// Option 2: Built-in (easier)
ElevatedButton.icon(
  onPressed: () {},
  icon: const Icon(Icons.add),
  label: Text(l10n.add),
)
```

### TextButton with Icon:
```dart
TextButton.icon(
  onPressed: () {},
  icon: const Icon(Icons.arrow_back),
  label: Text(l10n.back),
)
```

### ListTile with Icon:
```dart
ListTile(
  leading: const Icon(Icons.image),
  title: const Text('Gallery'),
  trailing: const Icon(Icons.arrow_forward_ios),
  onTap: () {},
)
```

### Icon with Background:
```dart
Container(
  width: 56,
  height: 56,
  decoration: BoxDecoration(
    color: Colors.blue,
    borderRadius: BorderRadius.circular(8),
  ),
  child: const Icon(Icons.check, color: Colors.white),
)
```

### Icon Badge (with number):
```dart
Stack(
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
)
```

### AppBar with Icon and Title:
```dart
AppBar(
  title: Row(
    children: [
      const Icon(Icons.settings),
      const SizedBox(width: 8),
      Text(l10n.settings),
    ],
  ),
)
```

### Available Material Icons:
- `Icons.home` - Home
- `Icons.settings` - Settings
- `Icons.camera` - Camera
- `Icons.add` - Plus
- `Icons.delete` - Delete
- `Icons.edit` - Edit
- `Icons.arrow_back` - Back arrow
- `Icons.arrow_forward` - Forward arrow
- `Icons.language` - Language
- `Icons.brightness_4` - Dark mode
- `Icons.brightness_3` - Night
- `Icons.wb_sunny` - Light/Sunny
- `Icons.check` - Checkmark
- `Icons.close` - Close/X
- `Icons.search` - Search
- `Icons.menu` - Menu
- `Icons.more_vert` - More options
- `Icons.download` - Download
- `Icons.share` - Share
- `Icons.favorite` - Heart/Favorite
- `Icons.star` - Star

[View more icons here](https://fonts.google.com/icons)

---

## 3. THEME - Colors and Styling

### How to change theme mode:

```dart
final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

// Change to light mode
themeProvider.setThemeMode(ThemeMode.light);

// Change to dark mode
themeProvider.setThemeMode(ThemeMode.dark);

// Change to system mode
themeProvider.setThemeMode(ThemeMode.system);
```

### How to change theme color:

```dart
final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

// Change to blue (default)
themeProvider.setSeedColor(Colors.blue);

// Change to red
themeProvider.setSeedColor(Colors.red);

// Change to green
themeProvider.setSeedColor(Colors.green);

// Or any custom color
themeProvider.setSeedColor(const Color(0xFF6200EE));
```

### Available theme colors:
- `Colors.blue`
- `Colors.teal`
- `Colors.green`
- `Colors.orange`
- `Colors.red`
- `Colors.purple`
- `Colors.pink`
- `Colors.indigo`

### Using theme in widgets:

```dart
// Get primary color
Theme.of(context).primaryColor

// Get background color
Theme.of(context).scaffoldBackgroundColor

// Get text theme
Theme.of(context).textTheme.titleLarge
Theme.of(context).textTheme.bodyMedium
Theme.of(context).textTheme.labelSmall

// Check if dark mode
MediaQuery.of(context).platformBrightness == Brightness.dark
```

### Custom theme example:

```dart
Container(
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Theme.of(context).primaryColor.withOpacity(0.2),
    borderRadius: BorderRadius.circular(8),
  ),
  child: Text(
    'Themed Container',
    style: TextStyle(
      color: Theme.of(context).primaryColor,
      fontWeight: FontWeight.bold,
    ),
  ),
)
```

---

## 4. SETTINGS SCREEN

A complete settings screen has been created at `lib/views/settings_screen.dart` with:
- Language switcher (English/Thai)
- Theme mode selector (Light/Dark/System)
- Color theme picker (8 colors to choose from)

To navigate to it:
```dart
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (context) => const SettingsScreen(),
  ),
)
```

---

## 5. ICONS EXAMPLE SCREEN

An example screen showing all icon usage patterns has been created at `lib/views/icons_example_screen.dart`.

To view it:
```dart
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (context) => const IconsExampleScreen(),
  ),
)
```

---

## 6. NEXT STEPS

### Generate l10n files:
```bash
cd /Users/kittanai46/Desktop/one_resume/slip_flow/slip_flow
flutter gen-l10n
```

### Get dependencies:
```bash
flutter pub get
```

### Run the app:
```bash
flutter run
```

### Add more translations:
1. Edit `lib/l10n/app_en.arb` and `lib/l10n/app_th.arb`
2. Run `flutter gen-l10n`
3. Use in code: `l10n.yourNewKey`

---

## 7. FILE STRUCTURE

```
lib/
  l10n/
    app_en.arb           # English translations
    app_th.arb           # Thai translations
    app_localizations.dart  # Generated (auto)
    app_localizations_en.dart  # Generated (auto)
    app_localizations_th.dart  # Generated (auto)
  providers/
    locale_provider.dart  # Language switcher
    theme_provider.dart   # Theme switcher (enhanced)
  views/
    settings_screen.dart  # Settings UI
    icons_example_screen.dart  # Icon examples
  main.dart             # Updated with l10n
```

---

## 8. EXAMPLE: Using Everything Together

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';

class CompleteExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Provider.of<ThemeProvider>(context);
    final locale = Provider.of<LocaleProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.home),
            const SizedBox(width: 8),
            Text(l10n.home),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Show current language
            Text('Language: ${locale.currentLanguageName}'),
            const SizedBox(height: 16),

            // Show current theme color
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: theme.seedColor,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 24),

            // Button with icon
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.settings),
              label: Text(l10n.settings),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 9. TROUBLESHOOTING

**Problem: "AppLocalizations.of(context) returns null"**
- Make sure you've run `flutter gen-l10n`
- The build context must be inside MaterialApp

**Problem: "Changes to translations not showing"**
- Run `flutter gen-l10n` again
- Restart the app (hot reload may not work for l10n changes)

**Problem: "Theme changes not persisting"**
- Changes are automatically saved to Hive storage
- They persist after app restart

**Problem: "Language changes not persisting"**
- Language is automatically saved to Hive storage
- It persists after app restart

