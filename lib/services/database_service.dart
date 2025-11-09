import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/reflection_entry.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('betterday.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE reflections (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        what_made_better TEXT NOT NULL,
        what_to_improve TEXT NOT NULL,
        mood INTEGER,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');
  }

  Future<ReflectionEntry> createEntry(ReflectionEntry entry) async {
    final db = await database;
    final now = DateTime.now();
    final newEntry = entry.copyWith(
      createdAt: now,
      updatedAt: now,
    );

    final id = await db.insert('reflections', newEntry.toMap());
    return newEntry.copyWith(id: id);
  }

  Future<ReflectionEntry?> getEntry(int id) async {
    final db = await database;
    final maps = await db.query(
      'reflections',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return ReflectionEntry.fromMap(maps.first);
    }
    return null;
  }

  Future<List<ReflectionEntry>> getAllEntries() async {
    final db = await database;
    final maps = await db.query(
      'reflections',
      orderBy: 'created_at DESC',
    );

    return maps.map((map) => ReflectionEntry.fromMap(map)).toList();
  }

  Future<List<ReflectionEntry>> getEntriesByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final db = await database;
    final maps = await db.query(
      'reflections',
      where: 'created_at >= ? AND created_at <= ?',
      whereArgs: [
        start.toIso8601String(),
        end.toIso8601String(),
      ],
      orderBy: 'created_at DESC',
    );

    return maps.map((map) => ReflectionEntry.fromMap(map)).toList();
  }

  Future<List<ReflectionEntry>> getEntriesByMonth(int year, int month) async {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 0, 23, 59, 59);
    return getEntriesByDateRange(start, end);
  }

  Future<List<ReflectionEntry>> getEntriesByWeek(DateTime date) async {
    final weekday = date.weekday;
    final start = date.subtract(Duration(days: weekday - 1));
    final end = start.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));
    return getEntriesByDateRange(start, end);
  }

  Future<ReflectionEntry?> getEntryByDate(DateTime date) async {
    final db = await database;
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));

    final maps = await db.query(
      'reflections',
      where: 'created_at >= ? AND created_at < ?',
      whereArgs: [
        start.toIso8601String(),
        end.toIso8601String(),
      ],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return ReflectionEntry.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateEntry(ReflectionEntry entry) async {
    final db = await database;
    final updatedEntry = entry.copyWith(updatedAt: DateTime.now());

    return await db.update(
      'reflections',
      updatedEntry.toMap(),
      where: 'id = ?',
      whereArgs: [entry.id],
    );
  }

  Future<int> deleteEntry(int id) async {
    final db = await database;
    return await db.delete(
      'reflections',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> getStreak() async {
    final today = DateTime.now();
    var currentDate = DateTime(today.year, today.month, today.day);
    var streak = 0;

    while (true) {
      final entry = await getEntryByDate(currentDate);
      if (entry == null) {
        // Jika hari ini tidak ada entry, cek apakah hari ini
        if (currentDate.isAtSameMomentAs(DateTime(today.year, today.month, today.day))) {
          // Hari ini belum ada entry, cek kemarin
          currentDate = currentDate.subtract(const Duration(days: 1));
          continue;
        } else {
          // Bukan hari ini dan tidak ada entry, streak berakhir
          break;
        }
      } else {
        streak++;
        currentDate = currentDate.subtract(const Duration(days: 1));
      }
    }

    return streak;
  }

  Future<List<ReflectionEntry>> getEntriesWithMood() async {
    final db = await database;
    final maps = await db.query(
      'reflections',
      where: 'mood IS NOT NULL',
      orderBy: 'created_at ASC',
    );

    return maps.map((map) => ReflectionEntry.fromMap(map)).toList();
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}

