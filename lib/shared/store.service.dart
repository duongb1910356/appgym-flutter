import 'package:shared_preferences/shared_preferences.dart';

class Store {
  const Store._();
  static const String _accessTokenKey = "accessToken";
  static const String _refreshTokenKey = "refreshToken";
  static const String _permission = "permission";

  static Future<void> setToken(String token) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_accessTokenKey, token);
  }

  static Future<void> setPermission(bool status) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_permission, status);
  }

  static Future<void> removeKey(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  static Future<String?> getToken() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_accessTokenKey);
  }

  static Future<bool?> getPermission() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_permission);
  }

  static Future<void> setRefreshToken(String token) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_refreshTokenKey, token);
  }

  static Future<String?> getRefreshToken() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_refreshTokenKey);
  }

  static Future<void> clear() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }
}
