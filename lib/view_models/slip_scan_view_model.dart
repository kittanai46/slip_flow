import 'package:flutter/material.dart';
import '../models/slip_model.dart';
import '../repositories/slip_repository.dart';
import '../services/camera_service.dart';
import '../services/ocr_service.dart';
import '../utils/logger.dart';
import 'package:uuid/uuid.dart';

class SlipScanViewModel extends ChangeNotifier {
  final SlipRepository _repository;
  final CameraService _cameraService;
  final OCRService _ocrService;

  String? _imagePath;
  bool _isProcessing = false;
  String? _errorMessage;
  Slip? _currentSlip;

  SlipScanViewModel({
    required SlipRepository repository,
    required CameraService cameraService,
    required OCRService ocrService,
  })  : _repository = repository,
        _cameraService = cameraService,
        _ocrService = ocrService;

  // Getters
  String? get imagePath => _imagePath;
  bool get isProcessing => _isProcessing;
  String? get errorMessage => _errorMessage;
  Slip? get currentSlip => _currentSlip;

  // Setters
  set imagePath(String? path) {
    _imagePath = path;
    notifyListeners();
  }

  // Methods
  Future<void> initializeCamera() async {
    try {
      await _cameraService.initialize();
      Logger.info('Camera initialized');
    } catch (e) {
      _errorMessage = 'Failed to initialize camera: $e';
      Logger.error('Failed to initialize camera', e);
    }
    notifyListeners();
  }

  Future<void> takePhoto() async {
    try {
      _setProcessing(true);
      if (_imagePath == null) {
        _errorMessage = 'No image captured';
        _setProcessing(false);
        return;
      }
      await _processImage(_imagePath!);
      Logger.info('Photo taken and processed: $_imagePath');
    } catch (e) {
      _errorMessage = 'Failed to take photo: $e';
      Logger.error('Failed to take photo', e);
    } finally {
      _setProcessing(false);
    }
  }

  Future<void> _processImage(String imagePath) async {
    try {
      final scanResult = await _ocrService.extractTextFromImage(imagePath);
      if (scanResult.isSuccessful) {
        _currentSlip = Slip(
          id: const Uuid().v4(),
          imagePath: imagePath,
          storeName: scanResult.storeName ?? 'Unknown Store',
          amount: scanResult.amount ?? 0.0,
          date: scanResult.date ?? DateTime.now(),
          category: 'Other',
          notes: scanResult.rawText,
          createdAt: DateTime.now(),
        );
        Logger.info('Image processed successfully');
      } else {
        _errorMessage = 'Failed to extract information from image';
      }
    } catch (e) {
      _errorMessage = 'Error processing image: $e';
      Logger.error('Error processing image', e);
    }
    notifyListeners();
  }

  Future<void> saveSlip({
    required String storeName,
    required double amount,
    required DateTime date,
    required String category,
    String notes = '',
  }) async {
    try {
      _setProcessing(true);
      if (_imagePath == null) {
        throw Exception('No image captured');
      }

      final slip = Slip(
        id: const Uuid().v4(),
        imagePath: _imagePath!,
        storeName: storeName,
        amount: amount,
        date: date,
        category: category,
        notes: notes,
        createdAt: DateTime.now(),
      );

      await _repository.createSlip(slip);
      _imagePath = null;
      _currentSlip = null;
      Logger.info('Slip saved successfully');
    } catch (e) {
      _errorMessage = 'Failed to save slip: $e';
      Logger.error('Failed to save slip', e);
    } finally {
      _setProcessing(false);
    }
    notifyListeners();
  }

  void reset() {
    _imagePath = null;
    _currentSlip = null;
    _errorMessage = null;
    notifyListeners();
  }

  void _setProcessing(bool value) {
    _isProcessing = value;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  Future<void> dispose() async {
    await _cameraService.dispose();
    super.dispose();
  }
}
