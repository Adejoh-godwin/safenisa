import 'package:safenisa/models/nearByAvailableDrivers.dart';

class GeoFireAssistant {
  //this helps us to get all,the key for the nearby drivers
  static List<NearByAvailableDrivers> nearByAvailableDriversList = [];

  //for when a driver is not available

  static void removeDriverFromList(String key) {
    int index =
        nearByAvailableDriversList.indexWhere((element) => element.key == key);
    nearByAvailableDriversList.remove(index);
  }

  static void updateDriverNearbyLocation(NearByAvailableDrivers driver) {
    int index = nearByAvailableDriversList
        .indexWhere((element) => element.key == driver.key);
    nearByAvailableDriversList[index].longitude = driver.longitude;
    nearByAvailableDriversList[index].latitude = driver.latitude;
  }
}
