import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDatabaseHelper {
  static const _databaseName = "fav.db";
  static const _databaseVersion = 4;

  // final int id;
  // final String nameAr;
  // final String nameEng;
  // final String aboutAr;
  // final String aboutEng;
  // final int order;
  // final String logoImage;
  // final int categoryId;
  // final int fieldId;
  // final String phone;
  // final String email;
  // final String images;
  // final String link;
  // final int status;
  // final int cardId;
  // final double discount;
  // final double rate;
  // final String createdAt;

  static const table = 'markets';
  static const columnId = 'id';
  static const columnMarketId = 'marketId';
  static const columnNameAr = 'nameAr';
  static const columnNameEng = 'nameEng';
  static const columnAbouteAr = 'abouteAr';
  static const columnAbouteEng = 'abouteEng';
  static const columnLogoImage = 'logoImage';
  static const columnPhone = 'phone';
  static const columnLink = 'link';
  static const columnEmail = 'email';
  static const columnImages = 'images';
  static const columnImageCard = 'imageCard';
  static const columnCardId = 'cardIds';

  Database? _db;

  Future<Database?> get database async {
    print(_db);

    if (_db != null) {
      return _db;
    }
    _db = await createDataBase();

    print(_db);

    return _db;
  }

  Future<Database> createDataBase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        // When the database is first created, create a table to store dogs.
        onCreate: _onCreate,
        version: _databaseVersion);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId  INTEGER PRIMARY KEY,
              $columnMarketId INTEGER NOT NULL ,
            $columnNameAr TEXT NOT NULL,
             $columnNameEng TEXT NOT NULL,
          $columnAbouteAr TEXT NOT NULL,
             $columnAbouteEng TEXT NOT NULL,
             
                       $columnPhone TEXT NOT NULL,
             $columnLink TEXT NOT NULL,
              $columnEmail TEXT NOT NULL,
                       $columnImages TEXT NOT NULL,
             $columnImageCard TEXT NOT NULL,
              $columnLogoImage TEXT NOT NULL,
            $columnCardId TEXT NOT NULL
          )
          ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    final Database db = await database as Database;
    return await db.insert(table, row);
  }

  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    final Database db = await database as Database;
    return await db.query(table);
  }

  Future<int> queryRowCount() async {
    final results = await _db!.rawQuery('SELECT COUNT(*) FROM $table');
    return Sqflite.firstIntValue(results) ?? 0;
  }

  Future<int> delete(int id) async {
    final Database db = await database as Database;
    return await db.delete(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }
}

class MarketTable {
  final int id;
  final int marketId;
  final String nameAr;
  final String nameEng;
  final String abouteAr;
  final String abouteEng;
  final String phone;
  final String link;
  final String email;
  final String images;
  final String imageCard;

  final String logoImage;

  final String cardIds;

  const MarketTable({
    required this.abouteAr,
    required this.abouteEng,
    required this.phone,
    required this.link,
    required this.email,
    required this.images,
    required this.imageCard,
    required this.id,
    required this.marketId,
    required this.nameAr,
    required this.nameEng,
    required this.logoImage,
    required this.cardIds,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'marketId': marketId,
      'nameAr': nameAr,
      'nameEng': nameEng,
      'logoImage': logoImage,
      'cardIds': cardIds,
      'imageCard': imageCard,
      'abouteAr': abouteAr,
      'abouteEng': abouteEng,
      'link': link,
      'phone': phone,
      'email': email,
      'images': images,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Market{id: $id,marketId: $marketId, nameAr: $nameAr, nameEng: $nameEng, logoImage: $logoImage, cardId: $cardIds}';
  }
}
