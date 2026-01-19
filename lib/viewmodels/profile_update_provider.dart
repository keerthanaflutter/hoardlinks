import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hoardlinks/core/constants/loginToken_constant.dart';
import 'package:http/http.dart' as http;

class ProfileUpdateProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  bool _isSuccess = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSuccess => _isSuccess;

  void clearStatus() {
    _isSuccess = false;
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> updateProfile(String mobileNumber) async {
    _isLoading = true;
    _errorMessage = null;
    _isSuccess = false;
    notifyListeners();

    final url = Uri.parse("https://hoardlinks-backend.onrender.com/api/v1/profile/update");

    try {
      final token = await AuthStorage.getAccessToken();

      if (token == null) {
        _errorMessage = "Session expired. Please login again.";
        _isLoading = false;
        notifyListeners();
        return;
      }

      // 🔥 CHANGED: Now using http.put as per Postman requirements
      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "access_token": token,
        },
        body: jsonEncode({"mobile_number": mobileNumber}),
      );

      // 🔥 Detailed Terminal Logging
      debugPrint("--- Profile Update API Call ---");
      debugPrint("Method: PUT");
      debugPrint("URL: $url");
      debugPrint("Request Body: ${jsonEncode({"mobile_number": mobileNumber})}");
      debugPrint("Status Code: ${response.statusCode}");
      debugPrint("Response Body: ${response.body}");
      debugPrint("-------------------------------");

      if (response.statusCode == 200 || response.statusCode == 201) {
        _isSuccess = true;
      } else {
        final data = jsonDecode(response.body);
        _errorMessage = data['message'] ?? "Update failed: ${response.statusCode}";
      }
    } catch (e) {
      debugPrint("Error during profile update: $e");
      _errorMessage = "Network error: Please check your connection.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}