import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safenisa/core/presentation/res/assets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safenisa/Widget/myFunction.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

class AddContact extends StatefulWidget {
  AddContact();
  @override
  _AddContactState createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  String imageUrl = "";
  File _imageFile;
  final image = avatars[1];
  Toastmsg toastmsg = Toastmsg();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController bio = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 16.0),
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(16.0),
                          margin: EdgeInsets.only(top: 16.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.0)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(left: 96.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Add Contact",
                                      // ignore: deprecated_member_use
                                      style: Theme.of(context).textTheme.title,
                                    ),
                                    ListTile(
                                      contentPadding: EdgeInsets.all(0),
                                      title: Text("Product Designer"),
                                      subtitle: Text("Kathmandu"),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10.0),
                            ],
                          ),
                        ),
                        _imageFile != null
                            ? Container(
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    image: DecorationImage(
                                        image: FileImage(_imageFile),
                                        fit: BoxFit.cover)),
                                margin: EdgeInsets.only(left: 16.0),
                              )
                            : Container(
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Icon(Icons.add_photo_alternate,
                                    color: Colors.grey),
                                margin: EdgeInsets.only(left: 16.0),
                              ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            title: Text('User details'),
                          ),
                          Divider(),
                          ListTile(
                            subtitle: Input(controller: name, hint: 'Name'),
                            leading: Icon(Icons.person),
                          ),
                          ListTile(
                            subtitle: Input(
                                controller: phone, hint: '+2349037016221'),
                            leading: Icon(Icons.phone),
                          ),
                          ListTile(
                            subtitle: Input(
                                controller: email,
                                hint: 'godwinadejoh@gmail.com'),
                            leading: Icon(Icons.email),
                          ),
                          ListTile(
                            subtitle:
                                Input(controller: bio, hint: 'About', maxl: 8),
                            leading: Icon(Icons.person),
                          ),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(30.0),
                            child: RaisedButton(
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                              color: Colors.pink,
                              onPressed: () {
                                if (!email.text.contains("@")) {
                                  Toastmsg().displayToastMessage(
                                      "Email address is not Valid.", context);
                                } else if (name.text.isEmpty ||
                                    email.text.isEmpty ||
                                    phone.text.isEmpty ||
                                    bio.text.isEmpty) {
                                  toastmsg.displayToastMessage(
                                      "All fields are mandatory.", context);
                                } else {
                                  submitContact(context);
                                }
                              },
                              elevation: 11,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40.0))),
                              child: Text("Submit",
                                  style: TextStyle(color: Colors.white70)),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
              )
            ],
          ),
        ),
      ),
    );
  }

  final firestoreInstance = FirebaseFirestore.instance;

  void submitContact(BuildContext context) {
    showDialog(
        context: context,
        builder: (c) {
          return Center(
            child: SpinKitChasingDots(
              color: Colors.amber,
              size: 50.0,
            ),
          );
        });

    var firebaseUser = FirebaseAuth.instance.currentUser;

    firestoreInstance
        .collection("emergency contact")
        .doc(firebaseUser.uid)
        .set({
      "name": name.text.trim(),
      "phone": phone.text,
      "email": email.text,
      "bio": bio.text
    }).then((_) {
      webCall();
    });
  }

  Future webCall() async {
    //API URL
    var url = 'https://quickpower.deproseducation.com/semira.php';
    // Store all data with Param Name.
    var data = {
      'phone': phone.text.trim(),
      'email': email.text.trim(),
      'name': name.text.trim(),
      'bio': bio.text.trim(),
    };
    // Starting Web Call with data.
    var response = await http.post(url, body: json.encode(data));
    var message = jsonDecode(response.body);

    print(message);
    //If Web call Success than Hide the CircularProgressIndicator.
    if (response.statusCode == 200) {
      toastmsg.displayToastMessage("User has been Added", context);
      Navigator.pushNamed(context, 'listcontact');
    }
  }
}

class Input extends StatelessWidget {
  const Input({
    Key key,
    @required this.controller,
    @required this.hint,
    this.maxl,
  }) : super(key: key);

  final TextEditingController controller;
  final String hint;
  final int maxl;

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: maxl,
      decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.black26),
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(40.0)),
          ),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0)),
      controller: controller,
    );
  }
}
