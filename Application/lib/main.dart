import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker_saver/image_picker_saver.dart';
import 'package:jarvis_internship_project/db_services.dart';
import 'package:jarvis_internship_project/myDB.dart';
import 'package:jarvis_internship_project/user.dart';
import 'add_new_user.dart';
import 'update_user.dart';
import 'package:http/http.dart' as http;

void main() async {
  await Mydb().initDatabase();
  fetchuser();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "User's List",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Splashscreen(),
    );
  }
}

class Splashscreen extends StatefulWidget {
  Splashscreen({Key key}) : super(key: key);

  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 12),
        () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => HomePage()),
            ModalRoute.withName('/homepage')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            color: Colors.blue,
          ),
          Align(
            alignment: Alignment(0, 0.8),
            child: Text(
              "Fetching Data....",
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.greenAccent,
            ),
          )
        ],
      ),
    );
  }
}

Future<String> _saveImg(path) async {
  var response = await http.get(path);

  debugPrint(response.statusCode.toString());
  var filePath = await ImagePickerSaver.saveFile(fileData: response.bodyBytes);
  // print("file_path is : "+filePath);
  var savedFile = File.fromUri(Uri.file(filePath));
  Future<File>.sync(() => savedFile);
  return filePath.toString();
}

Future<List<User>> fetchuser() async {
  final response = await http.get('https://reqres.in/api/users?page=1');
  if (response.statusCode == 200) {
    var res = json.decode(response.body);
    res = res['data'];
    List<User> users = [];
    for (var u in res) {
      print(u['avatar']);
      u['avatar'] = await _saveImg(u['avatar']);
      users.add(User.fromJson(u));
      await DbService.addUser(User.fromJson(u));
    }
    // print(users[0].avatar);
    return users;
  } else {
    throw Exception('Failed to load post');
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int id;  
  String firstname, lastname, avatar;

  deleteUser(User user) async {
    await DbService.deleteUser(user);    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User's List"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: "Add User",
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => AddNewUser()),
              );
        },
      ),
      body: SafeArea(
        child: Container(
          child: FutureBuilder(
            future: DbService.getallUsers(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Dismissible(
                      key: Key(UniqueKey().toString() +
                          snapshot.data[index].toString()),
                      background: Container(
                        color: Colors.lightGreen,
                      ),
                      onDismissed: (direction) {
                        deleteUser(snapshot.data[index]);
                      },
                      child: UserTile(
                        user: snapshot.data[index],
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class UserTile extends StatelessWidget {
  final User user;
  const UserTile({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipOval(
        child: Image.file(File('${user.avatar}')),
      ),
      trailing: IconButton(
        tooltip: "Update Info.",
        icon: Icon(
          Icons.system_update_alt,
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => UpdateUser(user: user)),
              );
        },
      ),
      title: Text('${user.firstname} ${user.lastname}'),
      subtitle: Text('${user.email}'),
    );
  }
}
