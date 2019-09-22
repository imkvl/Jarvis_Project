import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jarvis_internship_project/user.dart';
import 'db_services.dart';
import 'main.dart';

class UpdateUser extends StatefulWidget {
  final User user;
  UpdateUser({Key key, this.user}) : super(key: key);

  _UpdateUserState createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  int id;
  File img;
  String firstname, lastname, avatar, email;
  final _formKey = GlobalKey<FormState>();


  @override
  void initState() { 
    super.initState();
    img = File(widget.user.avatar);
    avatar = img.path;
  }

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
  
  updateUser(User user) async {
    int i = -1;
    if (_formKey.currentState.validate() && img!=null) {
      _formKey.currentState.save();
      user.firstname = firstname;
      user.lastname = lastname;
      user.email = email;
      user.avatar = avatar;
      int check = await DbService.updateUser(user);
      return check;
    }
    return i;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update User's Info"),
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
                    initialValue: widget.user.firstname,
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
                      initialValue: widget.user.lastname,
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
                    initialValue: widget.user.email,
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
                    child: Text("Update Image",style: TextStyle(color: Colors.white),),
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
                          "Update",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.blue,
                        onPressed: () async {
                          var check = await updateUser(widget.user);
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
