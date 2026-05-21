# Slip Flow MVVM Architecture

This project uses the **MVVM (Model-View-ViewModel)** architecture pattern for Flutter.

## Project Structure

```
lib/
├── main.dart                          # App entry point
├── config/
│   └── app_config.dart               # App configuration
├── constants/
│   └── app_constants.dart            # App-wide constants and dimensions
├── models/                            # Data models
│   ├── slip_model.dart               # Receipt/Slip model
│   └── scan_result_model.dart        # OCR scan result model
├── services/                          # Business logic services
│   ├── camera_service.dart           # Camera functionality
│   ├── ocr_service.dart              # OCR (Optical Character Recognition)
│   └── storage_service.dart          # Local data storage
├── repositories/                      # Data access layer
│   └── slip_repository.dart          # Repository for Slip data
├── view_models/                       # Business logic for UI
│   ├── slip_list_view_model.dart    # ViewModel for receipt list
│   └── slip_scan_view_model.dart    # ViewModel for scanning
├── views/                             # UI screens
│   ├── home_screen.dart              # Home screen
│   ├── scan_screen.dart              # Receipt scanning screen
│   └── slip_list_screen.dart         # Receipt list screen
└── utils/                             # Utility functions
    ├── logger.dart                   # Logging utility
    └── date_formatter.dart           # Date/number formatting
```

## Architecture Layers

### 1. **Models**
Data classes that represent the structure of data in the application.
- `Slip`: Represents a receipt/slip with store name, amount, date, category, etc.
- `ScanResult`: Represents OCR extraction results

### 2. **Services**
Low-level business logic and external integrations:
- `CameraService`: Handles camera operations (capture photos)
- `OCRService`: Handles text extraction from images using ML Kit
- `StorageService`: Handles local data persistence (Hive, SQLite, SharedPreferences)

### 3. **Repositories**
Data access layer that abstracts storage details:
- `SlipRepository`: Provides methods to create, read, update, delete slips
- Filters slips by date range or category

### 4. **ViewModels**
Business logic tied to UI:
- `SlipListViewModel`: Manages receipt list state and operations
- `SlipScanViewModel`: Manages camera and image processing state

### 5. **Views**
UI screens built with Flutter widgets:
- `HomeScreen`: Main dashboard
- `ScanScreen`: Camera interface for capturing receipts
- `SlipListScreen`: Display list of saved receipts

### 6. **Constants**
App-wide constants:
- `AppConstants`: App name, categories, error/success messages
- `AppDimensions`: Padding, radius, and icon sizes

### 7. **Utils**
Helper functions:
- `Logger`: Debugging and logging
- `DateFormatter`: Date and currency formatting

## Data Flow

```
View (UI Layer)
    ↓
ViewModel (Business Logic)
    ↓
Repository (Data Access)
    ↓
Service (External Integrations)
    ↓
Model (Data Structure)
```

## Setup Instructions

### 1. Add Dependencies

Add these to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.0              # State management
  camera: ^0.10.0               # Camera access
  google_mlkit_text_recognition: ^0.8.0  # OCR
  hive: ^2.2.0                  # Local storage
  uuid: ^4.0.0                  # Generate unique IDs
  intl: ^0.18.0                 # Internationalization/formatting

dev_dependencies:
  hive_generator: ^2.0.0
  build_runner: ^2.3.0
```

Run: `flutter pub get`

### 2. Initialize Services

In `main.dart`, set up dependency injection with Provider:

```dart
void main() {
  // Initialize services
  final storageService = StorageServiceImpl();
  final cameraService = CameraServiceImpl();
  final ocrService = OCRServiceImpl();
  final slipRepository = SlipRepositoryImpl(storageService: storageService);

  runApp(MyApp(
    slipRepository: slipRepository,
    cameraService: cameraService,
    ocrService: ocrService,
  ));
}
```

### 3. Use Providers in Widgets

```dart
ChangeNotifierProvider(
  create: (_) => SlipListViewModel(repository: slipRepository),
  child: const SlipListScreen(),
)
```

## Features to Implement

### Core Features
- [ ] Camera integration with `camera` plugin
- [ ] OCR text extraction with Google ML Kit
- [ ] Local storage with Hive or SQLite
- [ ] Receipt detail screen with edit functionality
- [ ] Statistics/analytics screen
- [ ] Export receipts to CSV/PDF

### Additional Features
- [ ] Search functionality
- [ ] Receipt image gallery
- [ ] Expense reports
- [ ] Multi-language support
- [ ] Dark theme support
- [ ] Cloud sync (Firebase/Supabase)

## Best Practices

1. **Separation of Concerns**: Each layer has a specific responsibility
2. **Testability**: Services and ViewModels can be easily unit tested
3. **Reusability**: Services can be shared across multiple ViewModels
4. **Maintainability**: Changes to one layer don't affect others
5. **Scalability**: Easy to add new features without modifying existing code

## State Management with Provider

The app uses the `provider` package for state management:
- ViewModels extend `ChangeNotifier`
- Widgets consume ViewModels using `Consumer` or `Provider.of()`
- Automatic UI rebuild when ViewModel state changes

## Error Handling

- Try-catch blocks in services
- Error messages stored in ViewModels
- User-friendly error dialogs in UI
- Logging for debugging

## Future Enhancements

- [ ] Implement proper error boundary widgets
- [ ] Add offline sync capability
- [ ] Implement caching strategy
- [ ] Add unit and widget tests
- [ ] Implement analytics
- [ ] Add backup/restore functionality
