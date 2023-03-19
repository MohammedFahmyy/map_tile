import 'package:shared_preferences/shared_preferences.dart';

// CacheHelper is used to handle cache

class CacheHelper {
  static SharedPreferences? sharedPreferences;
  // Initialize
  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }
  // Function to save data in Cache
  static Future<bool> saveData({
    required String key,
    required dynamic value,
  }) async {
    if (value is double) {
      return await sharedPreferences!.setDouble(key, value);
    } else if (value is int) {
      return await sharedPreferences!.setInt(key, value);
    } else if (value is bool) {
      return await sharedPreferences!.setBool(key, value);
    } else{
      return await sharedPreferences!.setString(key, value);
    }
  } 

  // Function to get data from cache
  static dynamic getData({
    required String key,
  }) {
    return sharedPreferences!.get(key);
  }

  // Function to remove data from cache
  static Future<bool> removeData({
    required String key,
  }) async {
      return await sharedPreferences!.remove(key);
  }

  // Function to get data from cache
  static Future<bool> clearData() async {
      return await sharedPreferences!.clear();
  } 

}
