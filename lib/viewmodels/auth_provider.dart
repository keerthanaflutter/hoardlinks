// ignore_for_file: unused_field

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hoardlinks/core/constants/loginToken_constant.dart';
import 'package:hoardlinks/data/models/login_response.dart';
import 'package:http/http.dart' as http;

class AuthProvider extends ChangeNotifier {
  final String _loginUrl = "http://hoardlinks.controlroom.cordsinnovations.com/api/v1/auth/login";

  bool _isLoading = false;
  bool _isLoggedIn = false;
  String? _errorMessage;

  String? _accessToken;
  String? _message;
  String? _roleType;
  UserModel? _user;

  // GETTERS
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  String? get errorMessage => _errorMessage;
  String? get roleType => _roleType;
  UserModel? get user => _user;
  String? get accessToken => _accessToken;

  // ---------------- LOGIN ----------------
  Future<bool> login({
    required String loginId,
    required String password,
    required String deviceId,
    required String fcmToken,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    if (fcmToken.isEmpty) {
      _errorMessage = "FCM token not available";
      _isLoading = false;
      notifyListeners();
      return false;
    }

    try {
      final response = await http.post(
        Uri.parse(_loginUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "login_id": loginId,
          "password": password,
          "device_id": deviceId,
          "device_type": "M",
          "FCM_token": fcmToken,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _accessToken = data['access_token'];
        _message = data['message'];
        _roleType = data['role_type'];
        _user = UserModel.fromJson(data['user']);

        // 🔐 SAVE TO SECURE STORAGE
        await AuthStorage.saveAccessToken(_accessToken!);
        await AuthStorage.saveStateId(_user!.stateId.toString());
        await AuthStorage.saveDistrictId(_user!.districtId.toString());

        _isLoggedIn = true;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = data['message'] ?? "Login failed";
      }
    } catch (e) {
      _errorMessage = "Network error";
    }

    _isLoggedIn = false;
    _isLoading = false;
    notifyListeners();
    return false;
  }
// ---------------- LOGOUT ----------------
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      // 1. Clear Local Storage (Tokens, IDs, FCM, etc.)
      await AuthStorage.clearAll(); 
      
      // 2. If you are using Firebase Messaging, you can delete the token from the server
      // try { await FirebaseMessaging.instance.deleteToken(); } catch (e) {}

      // 3. Reset local variables
      _accessToken = null;
      _user = null;
      _roleType = null;
      _isLoggedIn = false;
      _errorMessage = null;

      debugPrint("User logged out and tokens cleared successfully");
    } catch (e) {
      debugPrint("Error during logout: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  
  // ---------------- SPLASH CHECK ----------------
  Future<void> checkLoginStatus() async {
    final token = await AuthStorage.getAccessToken();

    if (token != null && token.isNotEmpty) {
      _accessToken = token;
      _isLoggedIn = true;
      // Optional: If you saved the user role/data, load it here too
    } else {
      _isLoggedIn = false;
    }

    notifyListeners();
  }
}
