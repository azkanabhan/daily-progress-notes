import 'package:flutter/foundation.dart';
import '../models/reflection_entry.dart';
import '../services/database_service.dart';

class ReflectionProvider with ChangeNotifier {
  final DatabaseService _dbService = DatabaseService.instance;
  List<ReflectionEntry> _entries = [];
  bool _isLoading = false;

  List<ReflectionEntry> get entries => _entries;
  bool get isLoading => _isLoading;

  Future<void> loadEntries() async {
    _isLoading = true;
    notifyListeners();

    try {
      _entries = await _dbService.getAllEntries();
    } catch (e) {
      debugPrint('Error loading entries: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addEntry(ReflectionEntry entry) async {
    try {
      final newEntry = await _dbService.createEntry(entry);
      _entries.insert(0, newEntry);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding entry: $e');
      rethrow;
    }
  }

  Future<void> updateEntry(ReflectionEntry entry) async {
    try {
      await _dbService.updateEntry(entry);
      final index = _entries.indexWhere((e) => e.id == entry.id);
      if (index != -1) {
        _entries[index] = entry;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating entry: $e');
      rethrow;
    }
  }

  Future<void> deleteEntry(int id) async {
    try {
      await _dbService.deleteEntry(id);
      _entries.removeWhere((e) => e.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting entry: $e');
      rethrow;
    }
  }

  Future<ReflectionEntry?> getEntryByDate(DateTime date) async {
    try {
      return await _dbService.getEntryByDate(date);
    } catch (e) {
      debugPrint('Error getting entry by date: $e');
      return null;
    }
  }

  Future<List<ReflectionEntry>> getEntriesByMonth(int year, int month) async {
    try {
      return await _dbService.getEntriesByMonth(year, month);
    } catch (e) {
      debugPrint('Error getting entries by month: $e');
      return [];
    }
  }

  Future<List<ReflectionEntry>> getEntriesByWeek(DateTime date) async {
    try {
      return await _dbService.getEntriesByWeek(date);
    } catch (e) {
      debugPrint('Error getting entries by week: $e');
      return [];
    }
  }

  Future<int> getStreak() async {
    try {
      return await _dbService.getStreak();
    } catch (e) {
      debugPrint('Error getting streak: $e');
      return 0;
    }
  }

  Future<List<ReflectionEntry>> getEntriesWithMood() async {
    try {
      return await _dbService.getEntriesWithMood();
    } catch (e) {
      debugPrint('Error getting entries with mood: $e');
      return [];
    }
  }
}

