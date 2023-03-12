
import 'package:lang_log_b/data/models/user_detail_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSharedData {

  AppSharedData._privateConstructor();

  static final AppSharedData _instance = AppSharedData._privateConstructor();
  UserDetailInfo userInfo;
  bool isLoggedIn;
  bool isSecondStart;

  factory AppSharedData() {
    return _instance;
  }

  Future<bool> isPremium() async {
    if (userInfo != null) {   //user is logged in
      return userInfo.isPremium;
    } else {                                  //user is not logged in
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getBool('isPremium') != null) {
          return prefs.getBool('isPremium');
      }
    }
    return false;
  }
}