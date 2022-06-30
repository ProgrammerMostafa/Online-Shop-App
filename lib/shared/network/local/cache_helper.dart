import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferences sharedPre;

  ///////////// Initialize SharedPreferences //////////////////////////////
  static Future init() async {
    sharedPre = await SharedPreferences.getInstance();
  }

  ////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////
  static Future<bool> saveDataInSharedPreferences({
    required String key,
    required dynamic value,
  }) async {
    if (value is bool) {
      return await sharedPre.setBool(key, value);
    }
    if (value is String) {
      return await sharedPre.setString(key, value);
    }
    if (value is int) {
      return await sharedPre.setInt(key, value);
    }

    return await sharedPre.setDouble(key, value);
  }

  ////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////
  static dynamic getDataFromSharedPreferences({
    required String key,
  }) {
    return sharedPre.get(key);
  }

  ////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////
  static Future<bool> removeDataFromSharedPreferences({
    required String key,
  }) async {
    return await sharedPre.remove(key);
  }
}
