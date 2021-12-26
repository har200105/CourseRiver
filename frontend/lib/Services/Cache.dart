import 'package:shared_preferences/shared_preferences.dart';

class Cache {
  
  readCache(String key) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var cache =  sharedPreferences.getString(key);
    return cache;
  }

  writeCache({String key, String value}) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
     sharedPreferences.setString(key, value);
  }

  removeCache({String key}) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    await sharedPreferences.remove(key);
  }

}
