import 'package:jarvis_internship_project/myDB.dart';

class User {
  int id;
  String firstname, lastname, avatar,email;
  User(this.id, this.firstname, this.lastname, this.avatar,this.email);

  User.fromJson(Map <String,dynamic> json){
    this.id = json[Mydb.id];
    this.firstname = json[Mydb.firstname];
    this.lastname = json[Mydb.lastname];
    this.avatar = json[Mydb.avatar];
    this.email = json[Mydb.email];
  }
  
}