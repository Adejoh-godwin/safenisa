import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'profile.dart';

class ListContact extends StatelessWidget {
  final TextStyle dropdownMenuItem =
      TextStyle(color: Colors.black, fontSize: 18);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      home: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.pink,
            elevation: 0,
            title: Text('Emmergency Contacts'),
            centerTitle: true,
            automaticallyImplyLeading: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, false),
            )),
        body: Farmers(dropdownMenuItem: dropdownMenuItem),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.pinkAccent,
            child: Icon(Icons.add_circle),
            onPressed: () async {
              Navigator.pushNamed(context, 'addContact');
            }),
      ),
    );
  }
}

class Farmers extends StatelessWidget {
  const Farmers({
    Key key,
    @required this.dropdownMenuItem,
  }) : super(key: key);

  final TextStyle dropdownMenuItem;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(top: 85),
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                child: MainListView()),
            Container(
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30))),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[],
                ),
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: TextField(
                        // controller: TextEditingController(text: locations[0]),
                        cursorColor: Theme.of(context).primaryColor,
                        style: dropdownMenuItem,
                        decoration: InputDecoration(
                            hintText: "Search",
                            hintStyle:
                                TextStyle(color: Colors.black38, fontSize: 16),
                            prefixIcon: Material(
                              elevation: 0.0,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              child: Icon(Icons.search),
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 13)),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Studentdata {
  dynamic name;
  dynamic phone;
  dynamic email;
  dynamic image;
  dynamic userId;
  dynamic bio;

  Studentdata({
    this.name,
    this.phone,
    this.email,
    this.image,
    this.userId,
    this.bio,
  });

  factory Studentdata.fromJson(Map<String, dynamic> json) {
    return Studentdata(
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      userId: json['userId'],
      bio: json['bio'],
      image:
          'https://firebasestorage.googleapis.com/v0/b/quickpower-4556c.appspot.com/o/profiledefault.jpg?alt=media&token=8a061fcb-bb88-4396-b5e1-3f85a90abf6c',
    );
  }
}

class MainListView extends StatefulWidget {
  MainListViewState createState() => MainListViewState();
}

class MainListViewState extends State {
  final primary = Color(0xff696b9e);
  final secondary = Color(0xfff29a94);
  final String apiURL = 'https://quickpower.deproseducation.com/select.php';

  Future<List<Studentdata>> fetchStudents() async {
    var response = await http.get(apiURL);

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<Studentdata> studentList = items.map<Studentdata>((json) {
        return Studentdata.fromJson(json);
      }).toList();

      return studentList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  navigateToNextActivity(BuildContext context, Studentdata data) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Profile(data)));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Studentdata>>(
      future: fetchStudents(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        return ListView(
          children: snapshot.data
              .map((data) => Column(
                    children: <Widget>[
                      Ink(
                        child: InkWell(
                          splashColor: Colors.orange,
                          onTap: () {
                            navigateToNextActivity(context, data);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.white,
                            ),
                            width: double.infinity,
                            height: 110,
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                data.image == ''
                                    ? Container(
                                        width: 50,
                                        height: 50,
                                        margin: EdgeInsets.only(right: 15),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          border: Border.all(
                                              width: 3,
                                              color: Colors.pinkAccent),
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  "https://cdn.pixabay.com/photo/2017/03/16/21/18/logo-2150297_960_720.png"),
                                              fit: BoxFit.fill),
                                        ),
                                      )
                                    : Container(
                                        width: 50,
                                        height: 50,
                                        margin: EdgeInsets.only(right: 15),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          border: Border.all(
                                              width: 3,
                                              color: Colors.pinkAccent),
                                          image: DecorationImage(
                                              image: NetworkImage(data.image),
                                              fit: BoxFit.fill),
                                        ),
                                      ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        data.name,
                                        style: TextStyle(
                                            color: primary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.phone,
                                            color: primary,
                                            size: 20,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(data.phone.toString(),
                                              style: TextStyle(
                                                  color: primary,
                                                  fontSize: 13,
                                                  letterSpacing: .3)),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.location_on,
                                            color: primary,
                                            size: 20,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(data.email,
                                              style: TextStyle(
                                                  color: primary,
                                                  fontSize: 13,
                                                  letterSpacing: .3)),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ))
              .toList(),
        );
      },
    );
  }
}
