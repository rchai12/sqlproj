import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static const _databaseName = "CardsDatabase.db";
  static const _databaseVersion = 1;

  static const foldersTable = 'folders';
  static const cardsTable = 'cards';

  static const columnId = 'id';
  static const columnName = 'name';
  static const columnTimestamp = 'timestamp';
  static const columnSuit = 'suit';
  static const columnImageUrl = 'imageUrl';
  static const columnFolderId = 'folderId';
  static const columnFolderImageUrl = 'folderImageUrl';

  late Database _db;

  Future<void> init() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    _db = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
    await _prepopulateData();
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE $foldersTable (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnName TEXT NOT NULL,
        $columnTimestamp TEXT DEFAULT CURRENT_TIMESTAMP,
        $columnFolderImageUrl TEXT NOT NULL
    )''');

    await db.execute('''CREATE TABLE $cardsTable (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnName TEXT NOT NULL,
        $columnSuit TEXT NOT NULL,
        $columnImageUrl TEXT NOT NULL,
        $columnFolderId INTEGER,
        FOREIGN KEY ($columnFolderId) REFERENCES $foldersTable($columnId)
    )''');
  }

  Future<void> _prepopulateData() async {
    final suits = ['Diamonds', 'Clubs', 'Hearts', 'Spades'];
    final folderImages = [
      'https://upload.wikimedia.org/wikipedia/commons/thumb/d/db/SuitDiamonds.svg/800px-SuitDiamonds.svg.png',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8a/SuitClubs.svg/800px-SuitClubs.svg.png',
      'https://upload.wikimedia.org/wikipedia/commons/a/a0/Naipe_copas.png',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5b/SuitSpades.svg/800px-SuitSpades.svg.png'
    ];
    final cardImages = [
      'https://upload.wikimedia.org/wikipedia/commons/thumb/2/21/01_of_diamonds_A.svg/800px-01_of_diamonds_A.svg.png', 
      'https://upload.wikimedia.org/wikipedia/commons/thumb/e/ea/02_of_diamonds.svg/800px-02_of_diamonds.svg.png',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/0/00/03_of_diamonds.svg/800px-03_of_diamonds.svg.png',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/8/80/04_of_diamonds.svg/800px-04_of_diamonds.svg.png',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2e/05_of_diamonds.svg/800px-05_of_diamonds.svg.png',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c6/06_of_diamonds.svg/800px-06_of_diamonds.svg.png',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/9/95/07_of_diamonds.svg/800px-07_of_diamonds.svg.png',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/4/42/08_of_diamonds.svg/800px-08_of_diamonds.svg.png', 
      'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/09_of_diamonds.svg/800px-09_of_diamonds.svg.png',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ae/10_of_diamonds_-_David_Bellot.svg/800px-10_of_diamonds_-_David_Bellot.svg.png',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/2/27/Jack_of_diamonds_fr.svg/800px-Jack_of_diamonds_fr.svg.png',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/0/00/Queen_of_diamonds_fr.svg/800px-Queen_of_diamonds_fr.svg.png',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f7/King_of_diamonds_fr.svg/800px-King_of_diamonds_fr.svg.png',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/3/34/01_of_clubs_A.svg/800px-01_of_clubs_A.svg.png',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d7/02_of_clubs.svg/800px-02_of_clubs.svg.png',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f9/03_of_clubs.svg/800px-03_of_clubs.svg.png',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ab/04_of_clubs.svg/800px-04_of_clubs.svg.png',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/05_of_clubs.svg/800px-05_of_clubs.svg.png',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/b/be/06_of_clubs.svg/800px-06_of_clubs.svg.png',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/7/7e/07_of_clubs.svg/800px-07_of_clubs.svg.png',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/8/88/08_of_clubs.svg/800px-08_of_clubs.svg.png',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1f/09_of_clubs.svg/800px-09_of_clubs.svg.png',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/b/bb/10_of_clubs_-_David_Bellot.svg/800px-10_of_clubs_-_David_Bellot.svg.png',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/d/df/Jack_of_clubs_fr.svg/800px-Jack_of_clubs_fr.svg.png',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f9/Queen_of_clubs_fr.svg/800px-Queen_of_clubs_fr.svg.png',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/d/dd/King_of_clubs_fr.svg/800px-King_of_clubs_fr.svg.png',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/f/fc/01_of_hearts_A.svg/800px-01_of_hearts_A.svg.png',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/7/74/02_of_hearts.svg/800px-02_of_hearts.svg.png',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/f/fc/03_of_hearts.svg/800px-03_of_hearts.svg.png',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/2/26/04_of_hearts.svg/800px-04_of_hearts.svg.png',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d1/05_of_hearts.svg/800px-05_of_hearts.svg.png',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0c/06_of_hearts.svg/800px-06_of_hearts.svg.png',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3f/07_of_hearts.svg/800px-07_of_hearts.svg.png',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/3/37/08_of_hearts.svg/800px-08_of_hearts.svg.png',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e7/09_of_hearts.svg/800px-09_of_hearts.svg.png',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e1/10_of_hearts_-_David_Bellot.svg/800px-10_of_hearts_-_David_Bellot.svg.png',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/0/00/Jack_of_hearts_fr.svg/800px-Jack_of_hearts_fr.svg.png',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/3/36/Queen_of_hearts_fr.svg/800px-Queen_of_hearts_fr.svg.png',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/f/fa/King_of_hearts_fr.svg/800px-King_of_hearts_fr.svg.png',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ab/01_of_spades_A.svg/800px-01_of_spades_A.svg.png',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/4/40/02_of_spades.svg/800px-02_of_spades.svg.png',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/6/62/03_of_spades.svg/800px-03_of_spades.svg.png',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/7/7a/04_of_spades.svg/800px-04_of_spades.svg.png',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/1/16/05_of_spades.svg/800px-05_of_spades.svg.png',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6e/06_of_spades.svg/800px-06_of_spades.svg.png',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/0/06/07_of_spades.svg/800px-07_of_spades.svg.png',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/d/dc/08_of_spades.svg/800px-08_of_spades.svg.png',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/4/4f/09_of_spades.svg/800px-09_of_spades.svg.png',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b7/10_of_spades_-_David_Bellot.svg/800px-10_of_spades_-_David_Bellot.svg.png',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/3/31/Jack_of_spades_fr.svg/800px-Jack_of_spades_fr.svg.png',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/0/06/Queen_of_spades_fr.svg/800px-Queen_of_spades_fr.svg.png',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/0/03/King_of_spades_fr.svg/800px-King_of_spades_fr.svg.png'
    ];

    deleteAllCards();
    deleteAllFolders();
    int imageIndex = 0;
    List<Map<String, dynamic>> folders = await queryAllRows();
    if (folders.isEmpty) {
      for (var i = 0; i < suits.length; i++) {
        String suit = suits[i];
        String folderImageUrl = folderImages[i];
        int folderId = await insertFolder(suit, folderImageUrl);

        print('Inserted folder: $suit with id $folderId');
        for (var rank = 1; rank <= 13; rank++) {
          String cardName = _getCardName(rank);
          await insertCard({
            columnName: '$cardName of $suit',
            columnSuit: suit,
            columnImageUrl: cardImages[imageIndex],
            columnFolderId: folderId,
          });
          print('Inserted card: $cardName with id $suit and folder $folderId');
          imageIndex++;
        }
      }
    }
  }

  String _getCardName(int rank) {
    switch (rank) {
      case 1:
        return 'Ace';
      case 11:
        return 'Jack';
      case 12:
        return 'Queen';
      case 13:
        return 'King';
      default:
        return rank.toString();
    }
  }

  // Insert folder into the database
  Future<int> insertFolder(String name, String imageUrl) async {
    return await _db.insert(foldersTable, {
      columnName: name,
      columnFolderImageUrl: imageUrl
    });
  }

  Future<int> insertCard(Map<String, dynamic> row) async {
    return await _db.insert(cardsTable, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    return await _db.query(foldersTable);
  }

  Future<List<Map<String, dynamic>>> query(int folderId) async {
    print('Looking for cards of folder $folderId');
    return await _db.query(
      cardsTable,
      where: '$columnFolderId = ?',
      whereArgs: [folderId],
    );
  }

  Future<int> delete(int id) async {
    return await _db.delete(
      cardsTable,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> queryAllCards() async {
    return await _db.query(cardsTable);
  }

  Future<void> close() async {
    await _db.close();
  }

  Future<int> deleteAllFolders() async {
    return await _db.delete(foldersTable);
  }

  Future<int> deleteAllCards() async {
    return await _db.delete(cardsTable);
  }
  
}