import 'package:sqflite/sqflite.dart' as sql;

// MEMBUAT TABEL DATABASE
class SQLHelper{
  static Future<void> createTables(sql.Database database) async{
    await database.execute("""CREATE TABLE data(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      title TEXT,
      username TEXT,
      password TEXT,
      desc TEXT,
      createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )""");
  }

  static Future<sql.Database> db() async{
    return sql.openDatabase("database_name.db", version: 1,
      onCreate: (sql.Database database, int version) async{
      await createTables(database);
      }
    );
  }

  static Future<int> createData(String title, String username, String password, String? desc) async{
    final db = await SQLHelper.db();

    final data = {'title' : title, 'username' : username, 'password' : password, 'desc' : desc};
    final id = await db.insert('data', data,conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getData() async {
    final db = await SQLHelper.db();
    return db.query('data', orderBy: 'id');
  }

  static Future<List<Map<String, dynamic>>> getSingelData(int id) async{
    final db = await SQLHelper.db();
    return db.query('data', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> updateData(int id, String title, String username, String password, String? desc) async{
    final db = await SQLHelper.db();
    final data = {
      'title': title,
      'username': username,
      'password': password,
      'desc': desc,
      'createdAt': DateTime.now().toString()
    };
    final result = 
    await db.update('data', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteData(int id) async{
    final db = await SQLHelper.db();
    try {
      await db.delete('data', where: "id = ?", whereArgs: [id]);
    } catch (e) {}
  }
}