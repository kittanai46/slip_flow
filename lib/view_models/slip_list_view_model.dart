import 'package:flutter/material.dart';
import '../models/slip_model.dart';
import '../repositories/slip_repository.dart';
import '../utils/logger.dart';

class SlipListViewModel extends ChangeNotifier {
  final SlipRepository _repository;

  List<Slip> _slips = [];
  bool _isLoading = false;
  String? _errorMessage;

  SlipListViewModel({required SlipRepository repository}) : _repository = repository;

  // Getters
  List<Slip> get slips => _slips;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Methods
  Future<void> loadSlips() async {
    try {
      _setLoading(true);
      _errorMessage = null;
      _slips = await _repository.getAllSlips();
      Logger.info('Loaded ${_slips.length} slips');
    } catch (e) {
      _errorMessage = 'Failed to load slips: $e';
      Logger.error('Failed to load slips', e);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteSlip(String id) async {
    try {
      await _repository.deleteSlip(id);
      _slips.removeWhere((slip) => slip.id == id);
      Logger.info('Deleted slip: $id');
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to delete slip: $e';
      Logger.error('Failed to delete slip', e);
    }
  }

  Future<void> filterByCategory(String category) async {
    try {
      _setLoading(true);
      _slips = await _repository.getSlipsByCategory(category);
      Logger.info('Filtered by category: $category');
    } catch (e) {
      _errorMessage = 'Failed to filter slips: $e';
      Logger.error('Failed to filter slips', e);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> filterByDateRange(DateTime startDate, DateTime endDate) async {
    try {
      _setLoading(true);
      _slips = await _repository.getSlipsByDateRange(startDate, endDate);
      Logger.info('Filtered by date range');
    } catch (e) {
      _errorMessage = 'Failed to filter slips: $e';
      Logger.error('Failed to filter slips', e);
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
