import 'package:hive_flutter/hive_flutter.dart';
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
  static const String _boxName = 'slips';

  Box<Map> get _box => Hive.box<Map>(_boxName);

  static Future<void> openBox() async {
    await Hive.openBox<Map>(_boxName);
  }

  @override
  Future<void> saveSlip(Slip slip) async {
    try {
      Logger.info('Saving slip: ${slip.id}');
      await _box.put(slip.id, slip.toJson());
    } catch (e) {
      Logger.error('Failed to save slip', e);
      rethrow;
    }
  }

  @override
  Future<void> deleteSlip(String id) async {
    try {
      Logger.info('Deleting slip: $id');
      await _box.delete(id);
    } catch (e) {
      Logger.error('Failed to delete slip', e);
      rethrow;
    }
  }

  @override
  Future<Slip?> getSlip(String id) async {
    try {
      Logger.info('Fetching slip: $id');
      final data = _box.get(id);
      if (data == null) return null;
      return Slip.fromJson(Map<String, dynamic>.from(data));
    } catch (e) {
      Logger.error('Failed to fetch slip', e);
      return null;
    }
  }

  @override
  Future<List<Slip>> getAllSlips() async {
    try {
      Logger.info('Fetching all slips');
      return _box.values
          .map((data) => Slip.fromJson(Map<String, dynamic>.from(data)))
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      Logger.error('Failed to fetch all slips', e);
      return [];
    }
  }

  @override
  Future<void> updateSlip(Slip slip) async {
    try {
      Logger.info('Updating slip: ${slip.id}');
      await _box.put(slip.id, slip.toJson());
    } catch (e) {
      Logger.error('Failed to update slip', e);
      rethrow;
    }
  }
}
