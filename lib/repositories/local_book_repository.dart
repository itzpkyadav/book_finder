import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/saved_book.dart';

/// Repository for local SQLite storage of saved books.
/// Handles CRUD operations for SavedBook objects.
class LocalBookRepository {
  static Database? _db;
  static const String _table = 'saved_books';

  /// Gets the database instance, initializing if needed.
  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  /// Initializes the SQLite database and creates the saved_books table.
  Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'books.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_table (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            key TEXT,
            title TEXT,
            authors TEXT,
            firstPublishYear INTEGER,
            coverId TEXT
          )
        ''');
      },
    );
  }

  /// Inserts a SavedBook into the database (replaces if exists).
  Future<int> insert(SavedBook book) async {
    final database = await db;
    return database.insert(_table, book.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Returns all saved books from the database.
  Future<List<SavedBook>> getAll() async {
    final database = await db;
    final maps = await database.query(_table);
    return maps.map((e) => SavedBook.fromMap(e)).toList();
  }

  /// Deletes a saved book by its id.
  Future<int> delete(int id) async {
    final database = await db;
    return database.delete(_table, where: 'id = ?', whereArgs: [id]);
  }

  /// Checks if a book with the given key is already saved.
  Future<bool> isBookSaved(String key) async {
    final database = await db;
    final result = await database.query(_table, where: 'key = ?', whereArgs: [key]);
    return result.isNotEmpty;
  }
} 