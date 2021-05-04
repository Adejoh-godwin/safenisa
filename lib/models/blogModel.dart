import 'package:cloud_firestore/cloud_firestore.dart';

class BlogModel {
  String title;
  String content;
  Timestamp publishedDate;
  String imageUrl;
  String shortDescription;

  BlogModel({
    this.title,
    this.content,
    this.imageUrl,
    this.shortDescription,
  });

  BlogModel.fromJson(Map<String, dynamic> json()) {
    title = json()['title'];
    content = json()['content'];
    imageUrl = json()['imageUrl'];
    shortDescription = json()['shortDescription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['content'] = this.content;
    data['imageUrl'] = this.imageUrl;
    data['shortDescription'] = this.shortDescription;
    return data;
  }
}

class PublishedDate {
  String date;

  PublishedDate({this.date});

  PublishedDate.fromJson(Map<String, dynamic> json) {
    date = json['$date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$date'] = this.date;
    return data;
  }
}
