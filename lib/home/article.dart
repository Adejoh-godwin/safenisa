import 'package:flutter/material.dart';
import 'package:safenisa/core/presentation/res/assets.dart';
import 'package:safenisa/src/widgets/network_image.dart';
import '../models/blogModel.dart';

class ArticleTwoPage extends StatelessWidget {
  final BlogModel blogModel;
  static final String path = "lib/src/pages/blog/article2.dart";
  ArticleTwoPage({this.blogModel});
  @override
  Widget build(BuildContext context) {
    String image = images[1];
    return Scaffold(
      appBar: AppBar(
        title: Text(blogModel.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Stack(
            children: <Widget>[
              Container(
                  height: 300,
                  width: double.infinity,
                  child: PNetworkImage(
                    blogModel.imageUrl,
                    fit: BoxFit.cover,
                  )),
              Container(
                margin: EdgeInsets.fromLTRB(16.0, 250.0, 16.0, 16.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0)),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      blogModel.title,
                      // ignore: deprecated_member_use
                      style: Theme.of(context).textTheme.title,
                    ),
                    SizedBox(height: 10.0),
                    Text("Oct 21, 2017 By DLohani"),
                    SizedBox(height: 10.0),
                    Divider(),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.favorite_border),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text("20.2k"),
                        SizedBox(
                          width: 16.0,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      blogModel.content,
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: 10.0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
