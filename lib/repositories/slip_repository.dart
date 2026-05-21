import '../models/slip_model.dart';
import '../services/storage_service.dart';

abstract class SlipRepository {
  Future<void> createSlip(Slip slip);
  Future<void> deleteSlip(String id);
  Future<Slip?> getSlip(String id);
  Future<List<Slip>> getAllSlips();
  Future<void> updateSlip(Slip slip);
  Future<List<Slip>> getSlipsByDateRange(DateTime startDate, DateTime endDate);
  Future<List<Slip>> getSlipsByCategory(String category);
}

class SlipRepositoryImpl implements SlipRepository {
  final StorageService storageService;

  SlipRepositoryImpl({required this.storageService});

  @override
  Future<void> createSlip(Slip slip) async {
    await storageService.saveSlip(slip);
  }

  @override
  Future<void> deleteSlip(String id) async {
    await storageService.deleteSlip(id);
  }

  @override
  Future<Slip?> getSlip(String id) async {
    return await storageService.getSlip(id);
  }

  @override
  Future<List<Slip>> getAllSlips() async {
    return await storageService.getAllSlips();
  }

  @override
  Future<void> updateSlip(Slip slip) async {
    await storageService.updateSlip(slip);
  }

  @override
  Future<List<Slip>> getSlipsByDateRange(DateTime startDate, DateTime endDate) async {
    final slips = await storageService.getAllSlips();
    return slips
        .where((slip) =>
            slip.date.isAfter(startDate) && slip.date.isBefore(endDate))
        .toList();
  }

  @override
  Future<List<Slip>> getSlipsByCategory(String category) async {
    final slips = await storageService.getAllSlips();
    return slips.where((slip) => slip.category == category).toList();
  }
}
