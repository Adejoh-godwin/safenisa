import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HogeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // <1> Use StreamBuilder
    return StreamBuilder<QuerySnapshot>(
        // <2> Pass `Stream<QuerySnapshot>` to stream
        stream: FirebaseFirestore.instance.collection('security').snapshots(),
        // ignore: missing_return
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // <3> Retrieve `List<DocumentSnapshot>` from snapshot
            final List<DocumentSnapshot> documents = snapshot.data.docs;
            return ListView(
                children: documents
                    .map((doc) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              margin: EdgeInsets.all(20.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5.0),
                                child: Container(
                                  child: Material(
                                    elevation: 5.0,
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: Colors.white,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Stack(
                                          children: <Widget>[
                                            Image.network(doc['imageUrl']),
                                            Positioned(
                                              right: 10,
                                              top: 10,
                                              child: Icon(
                                                Icons.star,
                                                color: Colors.grey.shade800,
                                                size: 20.0,
                                              ),
                                            ),
                                            Positioned(
                                              right: 8,
                                              top: 8,
                                              child: Icon(
                                                Icons.star_border,
                                                color: Colors.white,
                                                size: 24.0,
                                              ),
                                            ),
                                            Positioned(
                                              bottom: 20.0,
                                              right: 10.0,
                                              child: Container(
                                                padding: EdgeInsets.all(10.0),
                                                color: Colors.white,
                                                child: Text("\$40"),
                                              ),
                                            )
                                          ],
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(16.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                doc['content'],
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              Text(doc['title']),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.star,
                                                    color: Colors.green,
                                                  ),
                                                  Icon(
                                                    Icons.star,
                                                    color: Colors.green,
                                                  ),
                                                  Icon(
                                                    Icons.star,
                                                    color: Colors.green,
                                                  ),
                                                  Icon(
                                                    Icons.star,
                                                    color: Colors.green,
                                                  ),
                                                  Icon(
                                                    Icons.star,
                                                    color: Colors.green,
                                                  ),
                                                  SizedBox(
                                                    width: 5.0,
                                                  ),
                                                  Text(
                                                    "(220 reviews)",
                                                    style: TextStyle(
                                                        color: Colors.grey),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ))
                    .toList());
          } else if (snapshot.hasError) {
            return Text('It\'s Error!');
          }
        });
  }
}
