import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:safenisa/Widget/myFunction.dart';
import 'package:safenisa/home/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  static const String idScreen = "login";

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  SharedPreferences sharedPreferences;
  Toastmsg toastmsg = Toastmsg();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: 650,
            color: Colors.pink,
          ),
          ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: Container(
                  height: 400,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Login",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                              fontSize: 28.0)),
                      Card(
                        margin: EdgeInsets.only(left: 30, right: 30, top: 30),
                        elevation: 11,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(40))),
                        child: TextField(
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.mail_outline,
                                color: Colors.black26,
                              ),
                              suffixIcon: Icon(
                                Icons.check_circle,
                                color: Colors.black26,
                              ),
                              hintText: "Email",
                              hintStyle: TextStyle(color: Colors.black26),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40.0)),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 16.0)),
                          controller: emailTextEditingController,
                        ),
                      ),
                      Card(
                        margin: EdgeInsets.only(left: 30, right: 30, top: 20),
                        elevation: 11,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(40))),
                        child: TextField(
                          controller: passwordTextEditingController,
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.black26,
                              ),
                              hintText: "Password",
                              hintStyle: TextStyle(
                                color: Colors.black26,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40.0)),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 16.0)),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(30.0),
                        child: RaisedButton(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          color: Colors.pink,
                          onPressed: () {
                            if (!emailTextEditingController.text
                                .contains("@")) {
                              toastmsg.displayToastMessage(
                                  "Email address is not Valid.", context);
                            } else if (passwordTextEditingController
                                .text.isEmpty) {
                              toastmsg.displayToastMessage(
                                  "Password is mandatory.", context);
                            } else {
                              loginAndAuthenticateUser(context);
                            }
                          },
                          elevation: 11,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40.0))),
                          child: Text("Login",
                              style: TextStyle(color: Colors.white70)),
                        ),
                      ),
                      Text("Forgot your password?",
                          style: TextStyle(color: Colors.white))
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text("or, connect with"),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: 20.0,
                        ),
                        Expanded(
                          child: RaisedButton(
                            child: Text("Facebook"),
                            textColor: Colors.white,
                            color: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40)),
                            ),
                            onPressed: () {},
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: RaisedButton(
                            child: Text("Twitter"),
                            textColor: Colors.white,
                            color: Colors.indigo,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40)),
                            ),
                            onPressed: () {},
                          ),
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Dont have an account?"),
                        FlatButton(
                          child: Text("Sign up"),
                          textColor: Colors.indigo,
                          onPressed: () {
                            Navigator.pushNamed(context, 'register');
                          },
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void loginAndAuthenticateUser(BuildContext context) async {
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

    final User firebaseUser = (await _firebaseAuth
            .signInWithEmailAndPassword(
                email: emailTextEditingController.text.trim(),
                password: passwordTextEditingController.text.trim())
            .catchError((errMsg) {
      Navigator.pop(context);
      toastmsg.displayToastMessage("Error: " + errMsg.toString(), context);
    }))
        .user;

    if (firebaseUser != null) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(firebaseUser.uid)
          .get()
          .then((value) {
        shared(firebaseUser);
      });

      Navigator.pushNamedAndRemoveUntil(
          context, Home.idScreen, (route) => false);
      toastmsg.displayToastMessage("you are logged-in now.", context);
    } else {
      Navigator.pop(context);
      toastmsg.displayToastMessage(
          "Error Occured, can not be Signed-in.", context);
    }
  }

  Future shared(User fbUser) async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(fbUser.uid)
        .get()
        .then((dataSnapshot) async {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.setString('email', dataSnapshot.data()['email']);
      await sharedPreferences.setString('name', dataSnapshot.data()['name']);
      await sharedPreferences.setString('phone', dataSnapshot.data()['phone']);

      print(sharedPreferences.getString("name"));
    });
  }
}
