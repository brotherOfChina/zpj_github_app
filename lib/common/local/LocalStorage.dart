import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage{
  static save(String key,value) async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }
  static get(String key) async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    return preferences.get(key);
  }
  static remove(String key ) async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    preferences.remove(key);

  }
}