import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeBoxName = 'theme_preferences';
  static const String _themeModeKey = 'themeMode';
  static const String _seedColorKey = 'seedColor';

  late Box<int> _themeBox;
  ThemeMode _themeMode = ThemeMode.system;
  Color _seedColor = Colors.blue;

  // Available theme colors
  static const List<Color> themeColors = [
    Color.fromARGB(255, 24, 112, 184),
    Color.fromARGB(255, 2, 129, 117),
    Color.fromARGB(255, 27, 116, 30),
    Color.fromARGB(255, 212, 139, 28),
    Color.fromARGB(255, 160, 52, 45),
    Color.fromARGB(255, 82, 22, 93),
    Color.fromARGB(255, 214, 90, 131),
    Colors.indigo,
  ];

  ThemeProvider() {
    _initializeTheme();
  }

  Future<void> _initializeTheme() async {
    try {
      _themeBox = await Hive.openBox<int>(_themeBoxName);
      final savedModeValue = _themeBox.get(_themeModeKey);
      final savedColorValue = _themeBox.get(_seedColorKey, defaultValue: Colors.blue.value);
      
      if (savedModeValue != null && savedModeValue >= 0 && savedModeValue < ThemeMode.values.length) {
        _themeMode = ThemeMode.values[savedModeValue];
      } else {
        _themeMode = ThemeMode.system;
      }
      
      _seedColor = Color(savedColorValue ?? Colors.blue.value);
    } catch (e) {
      _themeMode = ThemeMode.system;
      _seedColor = Colors.blue;
    }
    notifyListeners();
  }

  ThemeMode get themeMode => _themeMode;
  Color get seedColor => _seedColor;

  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      return false;
    }
    return _themeMode == ThemeMode.dark;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode != mode) {
      _themeMode = mode;
      try {
        await _themeBox.put(_themeModeKey, mode.index);
      } catch (e) {
        debugPrint('Error saving theme mode: $e');
      }
      notifyListeners();
    }
  }

  Future<void> setSeedColor(Color color) async {
    if (_seedColor != color) {
      _seedColor = color;
      try {
        await _themeBox.put(_seedColorKey, color.value);
      } catch (e) {
        debugPrint('Error saving seed color: $e');
      }
      notifyListeners();
    }
  }

  ThemeData getLightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _seedColor,
        brightness: Brightness.light,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: _seedColor,
        foregroundColor: Colors.white,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _seedColor,
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _seedColor,
          foregroundColor: Colors.white,
          textStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  ThemeData getDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _seedColor,
        brightness: Brightness.dark,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(
        GoogleFonts.poppinsTextTheme().apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: _seedColor.withOpacity(0.8),
        foregroundColor: Colors.white,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _seedColor,
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _seedColor,
          foregroundColor: Colors.white,
          textStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
