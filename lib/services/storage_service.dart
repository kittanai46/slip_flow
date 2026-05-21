import '../models/slip_model.dart';
import '../utils/logger.dart';

abstract class StorageService {
  Future<void> saveSlip(Slip slip);
  Future<void> deleteSlip(String id);
  Future<Slip?> getSlip(String id);
  Future<List<Slip>> getAllSlips();
  Future<void> updateSlip(Slip slip);
}

class StorageServiceImpl implements StorageService {
  @override
  Future<void> saveSlip(Slip slip) async {
    try {
      Logger.info('Saving slip: ${slip.id}');
      // TODO: Implement local storage (Hive, SharedPreferences, SQLite)
    } catch (e) {
      Logger.error('Failed to save slip', e);
      rethrow;
    }
  }

  @override
  Future<void> deleteSlip(String id) async {
    try {
      Logger.info('Deleting slip: $id');
      // TODO: Implement deletion logic
    } catch (e) {
      Logger.error('Failed to delete slip', e);
      rethrow;
    }
  }

  @override
  Future<Slip?> getSlip(String id) async {
    try {
      Logger.info('Fetching slip: $id');
      // TODO: Implement fetch logic
      return null;
    } catch (e) {
      Logger.error('Failed to fetch slip', e);
      return null;
    }
  }

  @override
  Future<List<Slip>> getAllSlips() async {
    try {
      Logger.info('Fetching all slips');
      // TODO: Implement fetch all logic
      return [];
    } catch (e) {
      Logger.error('Failed to fetch all slips', e);
      return [];
    }
  }

  @override
  Future<void> updateSlip(Slip slip) async {
    try {
      Logger.info('Updating slip: ${slip.id}');
      // TODO: Implement update logic
    } catch (e) {
      Logger.error('Failed to update slip', e);
      rethrow;
    }
  }
}
