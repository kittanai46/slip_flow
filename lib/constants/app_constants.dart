class AppConstants {
  // App name
  static const String appName = 'Slip Flow';
  static const String appVersion = '1.0.0';

  // Categories
  static const List<String> slipCategories = [
    'Food & Dining',
    'Shopping',
    'Transportation',
    'Bills & Utilities',
    'Entertainment',
    'Healthcare',
    'Education',
    'Other',
  ];

  // Error messages
  static const String errorCameraAccess = 'Cannot access camera. Please check permissions.';
  static const String errorImageProcessing = 'Failed to process image.';
  static const String errorOCR = 'Failed to extract text from image.';
  static const String errorSaveSlip = 'Failed to save slip.';

  // Success messages
  static const String successSlipSaved = 'Slip saved successfully.';
  static const String successSlipDeleted = 'Slip deleted successfully.';

  // Date format
  static const String dateFormat = 'dd/MM/yyyy';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
}

class AppDimensions {
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;

  static const double radiusSmall = 4.0;
  static const double radiusMedium = 8.0;
  static const double radiusLarge = 16.0;

  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
}
