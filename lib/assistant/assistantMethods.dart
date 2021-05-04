import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safenisa/Widget/configMaps.dart';
import 'package:safenisa/assistant/requestAssistant.dart';
import 'package:safenisa/models/address.dart';
import 'package:safenisa/models/allUsers.dart';
import 'package:safenisa/models/directionDetails.dart';

class AssistantMethods {
  static Future<String> searchCoordinateAddres(Position position) async {
    //String st1, st2, st3, st4;
    String placeAddress = '';
    String url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey';

    var response = await RequestAssitant.getRequest(url);

    if (response != "failed") {
      placeAddress = response['results'][0]['formatted_address'];

      Address userPickUpAddress = new Address();
      userPickUpAddress.latitude = position.latitude;
      userPickUpAddress.longitude = position.longitude;
      userPickUpAddress.placeName = placeAddress;

      // Provider.of<AppData>(context, listen: false)
      //     .updatePickupLocationAddress(userPickUpAddress);
    }
    return placeAddress;
  }

  static Future<DirectionDetails> obtainPlaceDirection(
      LatLng initalPosition, LatLng finalDestination) async {
    String directionUrl =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${initalPosition.latitude},${initalPosition.longitude}&destination=${finalDestination.latitude},${finalDestination.longitude}&key=$mapKey';

    var res = await RequestAssitant.getRequest(directionUrl);

    if (res == 'failed') {
      return null;
    }

    DirectionDetails directionDetails = DirectionDetails();

    directionDetails.encodedPoints =
        res['routes'][0]['overview_polyline']["points"];
    directionDetails.distanceText =
        res['routes'][0]['legs'][0]["distance"]["text"];
    directionDetails.distanceValue =
        res['routes'][0]['legs'][0]["distance"]["value"];
    directionDetails.distanceText =
        res['routes'][0]['legs'][0]["duration"]["text"];
    directionDetails.durationValue =
        res['routes'][0]['legs'][0]["duration"]["value"];

    return directionDetails;
  }

  static int calculateFare(DirectionDetails directionDetails) {
    double timeTraveledFare = (directionDetails.durationValue / 60) * 0.2;
    double distanceTraveledfare =
        (directionDetails.distanceValue / 1000) * 0.20;
    double totalFareAmount = timeTraveledFare + distanceTraveledfare;

    return totalFareAmount.truncate();
  }

  static getCurrentOnlineUserInfo() async {
    firebaseUser = await FirebaseAuth.instance.currentUser;
    String userId = firebaseUser.uid;

    DatabaseReference reference =
        FirebaseDatabase.instance.reference().child('users').child(userId);

    reference.once().then((DataSnapshot dataSnapShot) {
      if (dataSnapShot.value != null) {
        //we are passing the data to our users clas
        usersCurrentInfo = Users.fromSnapshot(dataSnapShot);
      }
    });
  }

  static double createRandomNumber(int num) {
    var random = Random();
    int radNumber = random.nextInt(num);
    return radNumber.toDouble();
  }
}
