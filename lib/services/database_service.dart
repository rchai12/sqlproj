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

  final String _cardsTablename = "Cards";
  final String _cardsIdColumnName = "id";
  final String _cardsNameColumnName = "name";
  final String _cardsSuitColumnName = "suit";
  final String _cardsImageColumnName = "image";
  final String _cardsFolderColumnname = "folder";

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
        db.execute('''
        CREATE TABLE: $_cardsTablename (
            $_cardsIdColumnName INTEGER PRIMARY KEY,
            $_cardsNameColumnName TEXT NOT NULL,
            $_cardsSuitColumnName TEXT NOT NULL,
            $_cardsImageColumnName TEXT NOT NULL,
            $_cardsFolderColumnname TEXT NOT NULL,
        )
        ''');
      }
    ); 
    return database;
  }
}