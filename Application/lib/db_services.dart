import 'package:jarvis_internship_project/user.dart';
import 'myDB.dart';

class DbService {
  
  static Future<List<User>> getallUsers() async {
    final sql = '''select * from ${Mydb.tableName}''';
    final data = await db.rawQuery(sql);
    List<User> users = List();

    for (final row in data) {
      final user = User.fromJson(row);
      users.add(user);
    }
    return users;
  }

  static Future<User> getUser(int id) async {
    final sql = '''SELECT * FROM ${Mydb.tableName} WHERE ${Mydb.id} = ?''';
    List<dynamic> params = [id];
    final data = await db.rawQuery(sql, params);

    final user = User.fromJson(data.first);
    return user;
  }

  static Future<void> addUser(User user) async {
    final sql = '''INSERT INTO ${Mydb.tableName} (${Mydb.firstname},${Mydb.lastname},${Mydb.avatar},${Mydb.email}) VALUES (?,?,?,?)''';
    List<dynamic> params = [      
      user.firstname,
      user.lastname,
      user.avatar,
      user.email
    ];
    final result = await db.rawInsert(sql, params);
    print(result);
  }

  static Future<void> deleteUser(User user) async {
    final sql = '''DELETE FROM ${Mydb.tableName} WHERE ${Mydb.id} = ?''';
    List<dynamic> params = [user.id];
    final result = await db.rawDelete(sql, params);
    print(result);
  }

  static Future<int> updateUser(User user) async {
    final sql = '''UPDATE ${Mydb.tableName} SET ${Mydb.firstname} = ?,${Mydb.lastname} = ?,${Mydb.avatar} = ?,${Mydb.email} = ? WHERE ${Mydb.id} = ?''';
    List<dynamic> params = [user.firstname,user.lastname,user.avatar,user.email, user.id];
    final result = await db.rawUpdate(sql, params);
    print(result);
    return result;
  }

  static Future<int> getcount() async {
    final data =
        await db.rawQuery('''SELECT COUNT(*) FROM ${Mydb.tableName}''');

    int count = data[0].values.elementAt(0);
    return count;
  }
  
}
