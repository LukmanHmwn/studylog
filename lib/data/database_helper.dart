import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../providers/catatan_store.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'studylog.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE catatan (
            id TEXT PRIMARY KEY,
            mata_kuliah TEXT NOT NULL,
            judul TEXT NOT NULL,
            isi TEXT NOT NULL,
            tanggal TEXT NOT NULL,
            deadline TEXT,
            is_selesai INTEGER NOT NULL DEFAULT 0
          )
        ''');
      },
    );
  }

  Future<List<CatatanModel>> getAllCatatan() async {
    if (kIsWeb) return [];
    final db = await database;
    final maps = await db.query('catatan');
    return maps.map((map) => CatatanModel.fromMap(map)).toList();
  }

  Future<int> insertCatatan(CatatanModel catatan) async {
    if (kIsWeb) return 0;
    final db = await database;
    return await db.insert(
      'catatan',
      catatan.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateCatatan(CatatanModel catatan) async {
    if (kIsWeb) return 0;
    final db = await database;
    return await db.update(
      'catatan',
      catatan.toMap(),
      where: 'id = ?',
      whereArgs: [catatan.id],
    );
  }

  Future<int> deleteCatatan(String id) async {
    if (kIsWeb) return 0;
    final db = await database;
    return await db.delete(
      'catatan',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
