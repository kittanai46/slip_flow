import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LocaleProvider extends ChangeNotifier {
  static const String _localeBoxName = 'locale_preferences';
  static const String _localeKey = 'locale';

  late Box<String> _localeBox;
  Locale _locale = const Locale('en');

  LocaleProvider() {
    _initializeLocale();
  }

  Future<void> _initializeLocale() async {
    try {
      _localeBox = await Hive.openBox<String>(_localeBoxName);
      final savedLocale = _localeBox.get(_localeKey, defaultValue: 'en');
      _locale = _parseLocale(savedLocale ?? 'en');
    } catch (e) {
      _locale = const Locale('en');
    }
    notifyListeners();
  }

  Locale get locale => _locale;

  List<Locale> get supportedLocales => const [
    Locale('en'),
    Locale('th'),
  ];

  bool get isThaiLanguage => _locale.languageCode == 'th';

  Locale _parseLocale(String languageCode) {
    return Locale(languageCode);
  }

  Future<void> setLocale(String languageCode) async {
    final newLocale = _parseLocale(languageCode);
    // Compare by language code instead of Locale object
    if (_locale.languageCode != newLocale.languageCode) {
      _locale = newLocale;
      try {
        await _localeBox.put(_localeKey, languageCode);
      } catch (e) {
        debugPrint('Error saving locale: $e');
      }
      notifyListeners();
    }
  }

  String get currentLanguageName {
    return isThaiLanguage ? 'ไทย' : 'English';
  }
}
