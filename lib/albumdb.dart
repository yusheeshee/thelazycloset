import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'album.dart';

class AlbumDB {
  static final AlbumDB instance = AlbumDB._init();
  static Database? _database;

  AlbumDB._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('albums.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const strType = 'STRING NOT NULL';

    await db.execute('''
CREATE TABLE $tableAlbums (
  ${AlbumFields.id} $idType,
  ${AlbumFields.name} $strType,
  ${AlbumFields.images} $strType
  )''');
  }

  Future<Album> create(Album album) async {
    final db = await instance.database;
    final id = await db.insert(tableAlbums, album.toJson());
    return album.copy(id: id);
  }

  Future<Album> readAlbum(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableAlbums,
      columns: AlbumFields.values,
      where: '${AlbumFields.id} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Album.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Album>> readAllAlbums() async {
    final db = await instance.database;
    final result = await db.query(tableAlbums);
    return result.map((json) => Album.fromJson(json)).toList();
  }

  Future<int> update(Album album) async {
    final db = await instance.database;
    return db.update(
      tableAlbums,
      album.toJson(),
      where: '${AlbumFields.id} = ?',
      whereArgs: [album.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      tableAlbums,
      where: '${AlbumFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
