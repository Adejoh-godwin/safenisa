import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:safenisa/Login/login.dart';
import 'package:safenisa/Login/register.dart';
import 'package:safenisa/home/home.dart';
import 'package:safenisa/home/listOfContact.dart';
import 'core/presentation/pages/home.dart';
import 'package:safenisa/home/add-contact.dart';
import 'Config/config.dart';
import 'home/test.dart';
import 'home/tips.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  EApp.sharedPreferences = await SharedPreferences.getInstance();
  runApp(MyApp());
}

DatabaseReference usersRef =
    FirebaseDatabase.instance.reference().child("users");
DatabaseReference driversRef =
    FirebaseDatabase.instance.reference().child("drivers");
DatabaseReference rideRequestRef =
    FirebaseDatabase.instance.reference().child("Ride Requests");

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Safe Nisa',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute:
          FirebaseAuth.instance.currentUser == null ? '/login' : Home.idScreen,
      //initialRoute: '/HogeApp',
      routes: {
        Login.idScreen: (context) => Login(),
        Register.idScreen: (context) => Register(),
        Home.idScreen: (context) => Home(),
        '/login': (context) => Login(),
        '/HogeApp': (context) => HogeApp(),
        'listcontact': (context) => ListContact(),
        "challenge_home": (_) => HomePage(),
        "addContact": (_) => AddContact(),
        "tips": (_) => Tips(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
