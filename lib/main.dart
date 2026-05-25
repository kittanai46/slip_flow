import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'config/app_config.dart';
import 'l10n/app_localizations.dart';
import 'providers/theme_provider.dart';
import 'providers/locale_provider.dart';
import 'services/camera_service.dart';
import 'services/ocr_service.dart';
import 'services/storage_service.dart';
import 'repositories/slip_repository.dart';
import 'view_models/slip_list_view_model.dart';
import 'view_models/slip_scan_view_model.dart';
import 'views/home_screen.dart';

void main() async {
  // Initialize Hive
  await Hive.initFlutter();
  await StorageServiceImpl.openBox();

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
        // Theme provider
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
        // Locale provider
        ChangeNotifierProvider(
          create: (_) => LocaleProvider(),
        ),
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
      child: Consumer2<ThemeProvider, LocaleProvider>(
        builder: (context, themeProvider, localeProvider, _) {
          return MaterialApp(
            title: AppConfig.appName,
            debugShowCheckedModeBanner: false,
            theme: themeProvider.getLightTheme(),
            darkTheme: themeProvider.getDarkTheme(),
            themeMode: themeProvider.themeMode,
            // Localization settings
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: localeProvider.supportedLocales,
            locale: localeProvider.locale,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
