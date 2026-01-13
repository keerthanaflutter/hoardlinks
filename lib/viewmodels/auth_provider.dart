// ignore_for_file: unused_field

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hoardlinks/core/constants/loginToken_constant.dart';
import 'package:hoardlinks/data/models/login_response.dart';
import 'package:http/http.dart' as http;

class AuthProvider extends ChangeNotifier {
  final String _loginUrl =
      "https://hoardlinks-backend.onrender.com/api/v1/auth/login";

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

  // ---------------- LOGIN ----------------
  Future<bool> login({
    required String loginId,
    required String password,
    required String deviceId,
    required String fcmToken, // ✅ FROM UI
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    /// 🔴 SAFETY CHECK (same as UI)
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

      debugPrint("STATUS CODE: ${response.statusCode}");
      debugPrint("RESPONSE BODY: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _accessToken = data['access_token'];
        _message = data['message'];
        _roleType = data['role_type'];
        _user = UserModel.fromJson(data['user']);

        // 🔐 SAVE TOKEN and STATE/DISTRICT IDs
        await AuthStorage.saveAccessToken(_accessToken!);
        await AuthStorage.saveStateId(
          _user!.stateId.toString(),
        ); // Save stateId as String
        await AuthStorage.saveDistrictId(
          _user!.districtId.toString(),
        ); // Save districtId as String

        _isLoggedIn = true;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = data['message'] ?? "Login failed";
      }
    } catch (e) {
      debugPrint("LOGIN ERROR: $e");
      _errorMessage = "Network error";
    }

    _isLoggedIn = false;
    _isLoading = false;
    notifyListeners();
    return false;
  }

  // ---------------- SPLASH CHECK ----------------
  Future<void> checkLoginStatus() async {
    final token = await AuthStorage.getAccessToken();

    if (token != null && token.isNotEmpty) {
      _accessToken = token;
      _isLoggedIn = true;
    } else {
      _isLoggedIn = false;
    }

    notifyListeners();
  }
}
