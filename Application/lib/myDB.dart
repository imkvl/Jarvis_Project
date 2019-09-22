
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';

Database db;

class Mydb {
  static const tableName = "users_db";
  static const id = "id";
  static const firstname = "first_name";
  static const lastname = "last_name";
  static const avatar = "avatar";
  static const email = "email";

  Future<void> createTable(Database db) async {
    final mydbsql = '''create table $tableName($id INTEGER PRIMARY KEY AUTOINCREMENT,$firstname TEXT,$lastname TEXT,$avatar TEXT,$email TEXT);''';
    await db.execute(mydbsql);
  }

  Future<String> getdatabasepath(String dbname) async {
    final databasepath = await getDatabasesPath();
    final path = join(databasepath, dbname);

    if (await Directory(dirname(path)).exists()) {
      await deleteDatabase(path);
    } else {
      await Directory(dirname(path)).create(recursive: true);
    }
    return path;
  }

  Future<void> initDatabase() async {
    final path = await getdatabasepath('users_db');
    db = await openDatabase(path,version: 1,onCreate: onCreate,readOnly: false);
    print(db);
  }

  Future<void> onCreate(Database db,int version) async{
    await createTable(db); 
  }

}
