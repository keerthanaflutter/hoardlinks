import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hoardlinks/data/models/profile_model.dart';
import 'package:http/http.dart' as http;

class ProfileProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  ProfileResponse? _profileResponse;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  ProfileResponse? get profileResponse => _profileResponse;

  Future<void> fetchProfile() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token =
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYiLCJyb2xlX3R5cGUiOiJBR0VOQ1kiLCJpYXQiOjE3NjYzODUxNzAsImV4cCI6MTc2NjQ3MTU3MH0.M-2YbZe-3S9jOuvwzojtmi9mmOdjaMMaqBCy_bw7vhc";

      print("✅ TOKEN: $token");

      final response = await http.post(
        Uri.parse(
          'https://hoardlinks-backend.onrender.com/api/v1/profile/get',
        ),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "access_token": token, // ✅ MUST be here
        }),
      );

      print("📡 STATUS CODE: ${response.statusCode}");
      print("📡 RESPONSE: ${response.body}");

      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200 && decoded["success"] == true) {
        _profileResponse = ProfileResponse.fromJson(decoded);

        print("👤 LOGIN ID: ${_profileResponse!.data.loginId}");
        print("📱 MOBILE: ${_profileResponse!.data.mobileNumber}");
        print("🎭 ROLE: ${_profileResponse!.data.roleType}");
      } else {
        _errorMessage = decoded["message"] ?? "Authorization failed";
        print("❌ ERROR: $_errorMessage");
      }
    } catch (e) {
      _errorMessage = "Exception: $e";
      print("🔥 EXCEPTION: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}
