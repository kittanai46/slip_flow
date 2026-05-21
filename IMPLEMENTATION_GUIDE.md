# MVVM Implementation Guide

This guide explains how to implement and use the MVVM architecture for the Slip Flow app.

## Quick Start

### 1. Directory Structure
```
lib/
├── config/          # App configuration
├── constants/       # Constants and dimensions
├── models/          # Data models
├── services/        # Business logic services
├── repositories/    # Data access layer
├── view_models/     # ViewModel classes (extends ChangeNotifier)
├── views/           # UI Screens
├── utils/           # Helper utilities
└── main.dart        # App entry point
```

### 2. Main Components

#### Models (lib/models/)
- Define data structures with `toJson()` and `fromJson()` methods
- Example: `Slip`, `ScanResult`

#### Services (lib/services/)
- **CameraService**: Handle camera operations
- **OCRService**: Extract text from images
- **StorageService**: Local data persistence

#### Repositories (lib/repositories/)
- **SlipRepository**: Abstract data access methods
- Depend on services for data operations
- Used by ViewModels

#### ViewModels (lib/view_models/)
- Extend `ChangeNotifier` for state management
- Contain business logic for UI
- Methods trigger UI updates via `notifyListeners()`
- Example: `SlipListViewModel`, `SlipScanViewModel`

#### Views (lib/views/)
- Stateless/Stateful widgets
- Use `Consumer<ViewModel>()` to rebuild on state changes
- Call ViewModel methods on user interactions

## Implementation Steps

### Step 1: Initialize Services

In `main.dart`:

```dart
import 'package:provider/provider.dart';
import 'lib/services/camera_service.dart';
import 'lib/services/ocr_service.dart';
import 'lib/services/storage_service.dart';
import 'lib/repositories/slip_repository.dart';
import 'lib/view_models/slip_list_view_model.dart';
import 'lib/view_models/slip_scan_view_model.dart';

void main() {
  // Initialize services
  final storageService = StorageServiceImpl();
  final cameraService = CameraServiceImpl();
  final ocrService = OCRServiceImpl();
  
  // Create repository
  final slipRepository = SlipRepositoryImpl(
    storageService: storageService,
  );

  runApp(
    MyApp(
      slipRepository: slipRepository,
      cameraService: cameraService,
      ocrService: ocrService,
    ),
  );
}
```

### Step 2: Setup Provider

Wrap your app with multiple `ChangeNotifierProvider`:

```dart
class MyApp extends StatelessWidget {
  final SlipRepository slipRepository;
  final CameraService cameraService;
  final OCRService ocrService;

  const MyApp({
    required this.slipRepository,
    required this.cameraService,
    required this.ocrService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SlipListViewModel(repository: slipRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => SlipScanViewModel(
            repository: slipRepository,
            cameraService: cameraService,
            ocrService: ocrService,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Slip Flow',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
```

### Step 3: Use ViewModel in Widgets

#### Using Consumer for rebuilds:

```dart
Consumer<SlipListViewModel>(
  builder: (context, viewModel, child) {
    if (viewModel.isLoading) {
      return const CircularProgressIndicator();
    }
    
    if (viewModel.errorMessage != null) {
      return Text('Error: ${viewModel.errorMessage}');
    }
    
    return ListView.builder(
      itemCount: viewModel.slips.length,
      itemBuilder: (context, index) {
        final slip = viewModel.slips[index];
        return ListTile(
          title: Text(slip.storeName),
          subtitle: Text('฿${slip.amount}'),
        );
      },
    );
  },
)
```

#### Calling ViewModel methods:

```dart
ElevatedButton(
  onPressed: () {
    context.read<SlipListViewModel>().loadSlips();
  },
  child: const Text('Load Receipts'),
)
```

### Step 4: Create Custom ViewModels

Example of creating a new ViewModel:

```dart
class SlipDetailViewModel extends ChangeNotifier {
  final SlipRepository _repository;
  
  Slip? _slip;
  bool _isLoading = false;
  String? _errorMessage;

  SlipDetailViewModel({required SlipRepository repository})
    : _repository = repository;

  // Getters
  Slip? get slip => _slip;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Methods
  Future<void> loadSlip(String id) async {
    try {
      _setLoading(true);
      _slip = await _repository.getSlip(id);
    } catch (e) {
      _errorMessage = 'Failed to load slip: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateSlip(Slip updatedSlip) async {
    try {
      await _repository.updateSlip(updatedSlip);
      _slip = updatedSlip;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to update slip: $e';
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
```

## Data Flow Example

### Adding a New Receipt:

1. **View**: User taps "Add Receipt" button → calls `viewModel.takePhoto()`

2. **ViewModel** (`SlipScanViewModel`):
   - Calls `cameraService.takePicture()`
   - Calls `ocrService.extractTextFromImage(imagePath)`
   - Creates `Slip` object

3. **Service** (`CameraService`, `OCRService`):
   - Accesses device camera
   - Processes image and extracts text

4. **ViewModel** continues:
   - Calls `repository.createSlip(slip)`

5. **Repository** (`SlipRepository`):
   - Calls `storageService.saveSlip(slip)`

6. **Service** (`StorageService`):
   - Persists data locally (Hive/SQLite)

7. **ViewModel**:
   - Calls `notifyListeners()` to update UI

8. **View**:
   - `Consumer` rebuilds with new state
   - Shows success message

## Dependency Injection Pattern

This MVVM setup uses the Repository and Service Locator pattern:

```
UI Layer (Views)
    ↓ uses
ViewModel Layer (Business Logic)
    ↓ uses
Repository Layer (Data Access)
    ↓ uses
Service Layer (External Integrations)
    ↓ uses
Model Layer (Data Structures)
```

Each layer depends only on the layer below it, promoting loose coupling.

## Adding New Features

### To add a feature, follow these steps:

1. **Create a Model** in `lib/models/` if needed
2. **Create a Service** in `lib/services/` for external integration
3. **Create a Repository** in `lib/repositories/` for data access
4. **Create a ViewModel** in `lib/view_models/` for business logic
5. **Create a View/Screen** in `lib/views/` for UI
6. **Add Provider** to main.dart
7. **Use Consumer** in widgets

### Example: Adding Statistics Feature

```
1. lib/models/statistics_model.dart
   - class DailyExpense
   - class MonthlyStatistics

2. lib/repositories/statistics_repository.dart
   - interface with methods like:
     - getMonthlyStats()
     - getDailyStats()
     - getTotalExpense()

3. lib/view_models/statistics_view_model.dart
   - extends ChangeNotifier
   - methods to load stats

4. lib/views/statistics_screen.dart
   - displays the statistics

5. Update main.dart with new provider
```

## Common Patterns

### Loading State with UI States:

```dart
Future<void> loadSlips() async {
  try {
    _setLoading(true);
    _errorMessage = null;
    _slips = await _repository.getAllSlips();
  } catch (e) {
    _errorMessage = e.toString();
  } finally {
    _setLoading(false);
  }
}
```

### Error Handling:

```dart
if (viewModel.errorMessage != null) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(viewModel.errorMessage!)),
  );
  viewModel.clearError();
}
```

### Refresh Data:

```dart
Future<void> refreshSlips() async {
  await loadSlips();
}
```

## Testing

### Unit Test for ViewModel:

```dart
test('loadSlips should load all slips', () async {
  final mockRepository = MockSlipRepository();
  final viewModel = SlipListViewModel(repository: mockRepository);
  
  await viewModel.loadSlips();
  
  expect(viewModel.slips, isNotEmpty);
  expect(viewModel.isLoading, isFalse);
});
```

## Best Practices

1. ✅ Keep ViewModels focused on business logic only
2. ✅ Use abstract classes for services (easier to mock/test)
3. ✅ Always handle errors in try-catch
4. ✅ Use `notifyListeners()` to trigger UI updates
5. ✅ Keep views simple and UI-focused
6. ✅ Use Provider for dependency injection
7. ✅ Create separate ViewModels for different features
8. ✅ Log important operations for debugging

## Resources

- [Provider Package](https://pub.dev/packages/provider)
- [MVVM Pattern](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93viewmodel)
- [Dart Best Practices](https://dart.dev/guides/language/effective-dart)
- [Flutter Architecture](https://flutter.dev/docs/development/best-practices)
