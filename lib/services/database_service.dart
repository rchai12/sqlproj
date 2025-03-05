import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();

  final String _foldersTablename = "Folders";
  final String _foldersIdColumnName = "id";
  final String _foldersContentColumnName = "folder name";
  final String _foldersTimeStampColumnName = "time stamp";

  DatabaseService._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "main_db.db");
    final database = await openDatabase(
      databasePath,
      onCreate:(db, version) {
        db.execute('''
        CREATE TABLE: $_foldersTablename (
          $_foldersIdColumnName INTEGER PRIMARY KEY,
          $_foldersContentColumnName TEXT NOT NULL,
          $_foldersTimeStampColumnName TEXT NOT NULL,
        )
        ''');
      }
    ); 
    return database;
  }
}