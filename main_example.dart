import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slip_flow/config/app_config.dart';
import 'package:slip_flow/repositories/slip_repository.dart';
import 'package:slip_flow/services/camera_service.dart';
import 'package:slip_flow/services/ocr_service.dart';
import 'package:slip_flow/services/storage_service.dart';
import 'package:slip_flow/view_models/slip_list_view_model.dart';
import 'package:slip_flow/view_models/slip_scan_view_model.dart';
import 'package:slip_flow/views/home_screen.dart';

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

class MyApp extends StatelessWidget {
  final SlipRepository slipRepository;
  final CameraService cameraService;
  final OCRService ocrService;

  const MyApp({
    required this.slipRepository,
    required this.cameraService,
    required this.ocrService,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ViewModel for slip list
        ChangeNotifierProvider(
          create: (_) => SlipListViewModel(repository: slipRepository),
        ),
        // ViewModel for scanning
        ChangeNotifierProvider(
          create: (_) => SlipScanViewModel(
            repository: slipRepository,
            cameraService: cameraService,
            ocrService: ocrService,
          ),
        ),
      ],
      child: MaterialApp(
        title: AppConfig.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
          ),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.dark,
          ),
        ),
        themeMode: ThemeMode.system,
        home: const HomeScreen(),
      ),
    );
  }
}

// Alternative main.dart with additional features:
// Uncomment if you want to add more ViewModels and features

/*
import 'view_models/statistics_view_model.dart';
import 'view_models/settings_view_model.dart';

void main() {
  // Initialize services
  final storageService = StorageServiceImpl();
  final cameraService = CameraServiceImpl();
  final ocrService = OCRServiceImpl();

  // Create repositories
  final slipRepository = SlipRepositoryImpl(
    storageService: storageService,
  );
  
  final statisticsRepository = StatisticsRepositoryImpl(
    storageService: storageService,
  );

  runApp(
    MyApp(
      slipRepository: slipRepository,
      statisticsRepository: statisticsRepository,
      cameraService: cameraService,
      ocrService: ocrService,
    ),
  );
}

class MyApp extends StatelessWidget {
  final SlipRepository slipRepository;
  final StatisticsRepository statisticsRepository;
  final CameraService cameraService;
  final OCRService ocrService;

  const MyApp({
    required this.slipRepository,
    required this.statisticsRepository,
    required this.cameraService,
    required this.ocrService,
    super.key,
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
        ChangeNotifierProvider(
          create: (_) => StatisticsViewModel(
            repository: statisticsRepository,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => SettingsViewModel(),
        ),
      ],
      child: MaterialApp(
        title: AppConfig.appName,
        debugShowCheckedModeBanner: !AppConfig.isProduction,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
*/
