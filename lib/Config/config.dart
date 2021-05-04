import 'package:shared_preferences/shared_preferences.dart';

class EApp {
  static const String appName = 'e-Shop';

  static SharedPreferences sharedPreferences;

  static String collectionUser = "users";
  static String collectionOrders = "orders";
  static String userCartList = 'userCart';
  static String subCollectionAddress = 'userAddress';

  static final String userName = 'name';
  static final String userEmail = 'email';
  static final String userPhone = 'phone';
  static final String userPhotoUrl = 'image';
  static final String userUID = 'id';
  static final String userAvatarUrl = 'url';

  static final String addressID = 'addressID';
  static final String totalAmount = 'totalAmount';
  static final String productID = 'productIDs';
  static final String paymentDetails = 'paymentDetails';
  static final String orderTime = 'orderTime';
  static final String isSuccess = 'isSuccess';
}
