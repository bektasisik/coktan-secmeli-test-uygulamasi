import 'package:sampleproject/constans.dart';
import 'package:sampleproject/models/SinavModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String tableName = 'sinavlar';
final String columnId = 'id';
final String columnTitle = 'sinavAdi';
final String columnDone = 'bitisTarihi';
final String columnExams = 'sorular';

class SinavProvider {
  Database db;

  Future<String> _getPath() async {
    var databasesPath = await getDatabasesPath();
    return join(databasesPath, databaseName);
  }

  Future open() async {
    String path = await _getPath();
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
        create table $tableName ( 
          $columnId integer primary key autoincrement, 
          $columnTitle text not null,
          $columnDone text not null,
          $columnExams text not null)
        ''');
    });
  }

  Future<List<SinavModel>> getAll() async {
    List<Map> all = await db.query(tableName);
    return all.map((q) => SinavModel.fromMap(q)).toList();
  }

  Future<SinavModel> getOne(int id) async {
    List<Map> maps = await db.query(tableName,
        columns: [columnId, columnDone, columnTitle, columnExams],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return SinavModel.fromMap(maps.first);
    }
    return null;
  }

  Future<SinavModel> add(SinavModel obj) async {
    obj.id = await db.insert(tableName, obj.toMap());
    return obj;
  }
  
  Future<int> delete(int id) async {
    return await db.delete(tableName, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(SinavModel obj) async {
    return await db.update(tableName, obj.toMap(),
        where: '$columnId = ?', whereArgs: [obj.id]);
  }

  Future close() async => db.close();
}
