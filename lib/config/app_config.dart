import 'package:flutter/foundation.dart';

class AppConfig {
  static const String appName = 'SlipFlow';
  static const String appVersion = '1.0.0';
  static const String appBuild = '1';

  // Environment
  static const bool isProduction = bool.fromEnvironment('PROD', defaultValue: false);
  static const bool isDebug = kDebugMode;

  // API Configuration (if needed)
  static const String apiBaseUrl =
      String.fromEnvironment('API_URL', defaultValue: 'https://api.example.com');

  // Feature flags
  static const bool enableAnalytics = true;
  static const bool enableCrashReporting = true;
}
