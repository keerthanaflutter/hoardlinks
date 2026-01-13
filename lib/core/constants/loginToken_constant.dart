import 'package:shared_preferences/shared_preferences.dart';


class AuthStorage {
  static const _accessTokenKey = 'access_token';
  static const _fcmTokenKey = 'fcm_token';
  static const _stateIdKey = "state_id";
  static const _districtIdKey = "district_id";

  // ---------------- ACCESS TOKEN ----------------
  static Future<void> saveAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, token);
  }

  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  static Future<void> clearAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
  }

  // ---------------- STATE & DISTRICT IDs ----------------
  /// ✅ Save both State and District IDs
  static Future<void> saveLocationIds({required String stateId, required String districtId}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_stateIdKey, stateId);
    await prefs.setString(_districtIdKey, districtId);
  }

  /// ✅ Save State ID
  static Future<void> saveStateId(String stateId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_stateIdKey, stateId);
  }

  /// ✅ Retrieve State ID
  static Future<String?> getStateId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_stateIdKey);
  }

  /// ✅ Save District ID
  static Future<void> saveDistrictId(String districtId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_districtIdKey, districtId);
  }

  /// ✅ Retrieve District ID
  static Future<String?> getDistrictId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_districtIdKey);
  }

  // ---------------- FCM TOKEN ----------------
  static Future<void> saveFcmToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_fcmTokenKey, token);
  }

  static Future<String?> getFcmToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_fcmTokenKey);
  }

  static Future<void> clearFcmToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_fcmTokenKey);
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_stateIdKey);
    await prefs.remove(_districtIdKey);
  
  }
}
