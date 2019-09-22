import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'db_services.dart';
import 'main.dart';
import 'user.dart';

class AddNewUser extends StatefulWidget {
  const AddNewUser({Key key}) : super(key: key);

  @override
  _AddNewUserState createState() => _AddNewUserState();
}

class _AddNewUserState extends State<AddNewUser> {
  int id;
  File img;
  String firstname, lastname, avatar, email;
  final _formKey = GlobalKey<FormState>();

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery,maxHeight: 128,maxWidth: 128);

    setState(() {
      if (image != null) {
        img = image;
        avatar = img.path;
        // print(img.path);
      }
    });
  }

  createUser() async {
    int i = -1;
    if (_formKey.currentState.validate() && avatar!=null) {
      _formKey.currentState.save();
      int count = await DbService.getcount();
      final user = User(count + 1, firstname, lastname, avatar, email);
      await DbService.addUser(user);
      // print(user.id);
      return user.id;
    }
    return i;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New User"),
      ),
      body: Container(
        child: SingleChildScrollView(
          controller: ScrollController(keepScrollOffset: true),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Firstname',
                      fillColor: Colors.grey[300],
                      filled: true,
                    ),
                    validator: (val) {
                      if (val.isEmpty) {
                        return 'Please Enter Firstname';
                      }
                      return null;
                    },
                    onSaved: (val) {
                      firstname = val;
                    },
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Lastname',
                        fillColor: Colors.grey[300],
                        filled: true,
                      ),
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'Please Enter Lastname';
                        }
                        return null;
                      },
                      onSaved: (val) {
                        lastname = val;
                      },
                    )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Email',
                      fillColor: Colors.grey[300],
                      filled: true,
                    ),
                    validator: (val) {
                      if (val.isEmpty) {
                        return 'Please Enter Email';
                      }
                      return null;
                    },
                    onSaved: (val) {
                      email = val;
                    },
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: img == null
                      ? Text("No Image Found!")
                      : Image.file(
                          img,
                          height: 128,width: 128,
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FlatButton(
                    color: Colors.lightGreen,
                    child: Text("Add Image",style: TextStyle(color: Colors.white),),
                    onPressed: getImage,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Spacer(),
                      FlatButton(
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.blue,
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      HomePage()),
                              ModalRoute.withName('/'));
                        },
                      ),
                      Spacer(),
                      FlatButton(
                        child: Text(
                          "Add",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.blue,
                        onPressed: () async {
                          var check = await createUser();
                          if (check >= 0) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        HomePage()),
                                ModalRoute.withName('/'));
                          }
                        },
                      ),
                      Spacer()
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
