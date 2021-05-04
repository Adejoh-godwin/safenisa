import 'package:flutter/material.dart';

class ProductData {
  dynamic bid;
  dynamic pName;
  dynamic pSellingPrice;
  dynamic pCategory;
  dynamic pImage;
  dynamic pid;
  dynamic pDescription;

  ProductData({
    this.bid,
    this.pSellingPrice,
    this.pCategory,
    this.pImage,
    this.pName,
    this.pid,
    this.pDescription,
  });

  factory ProductData.fromJson(Map<dynamic, dynamic> json) {
    return ProductData(
        bid: json['bid'],
        pSellingPrice: json['pSellingPrice'],
        pCategory: json['pCategory'],
        pImage: json['pImage'],
        pid: json['id'],
        pName: json['pName'],
        pDescription: json['pDescription']);
  }
}

class PurchaseData {
  dynamic bid;
  dynamic meter;
  dynamic amount;
  dynamic date;
  dynamic unit;
  dynamic address;
  dynamic token;

  PurchaseData(
      {this.bid,
      this.amount,
      this.date,
      this.unit,
      this.meter,
      this.address,
      this.token});

  factory PurchaseData.fromJson(Map<dynamic, dynamic> json) {
    return PurchaseData(
      bid: json['bid'],
      amount: json['amount'],
      date: json['dateAdded'],
      unit: json['unit'],
      meter: json['meter'],
      address: json['meter'],
      token: json['token'],
    );
  }
}

class RefData {
  dynamic pName;
  dynamic pdate;
  dynamic pbonus;

  RefData({
    this.pName,
    this.pbonus,
    this.pdate,
  });

  factory RefData.fromJson(Map<dynamic, dynamic> json) {
    return RefData(
      pName: json['pName'],
      pbonus: json['pbonus'],
      pdate: json['pdate'],
    );
  }
}

class MenuItem {
  MenuItem(this.title, {this.iconData, this.route, this.selected = false});

  final String title;
  final IconData iconData;
  final String route;
  final bool selected;
}
