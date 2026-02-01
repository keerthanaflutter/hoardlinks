import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hoardlinks/core/constants/loginToken_constant.dart';
import 'package:http/http.dart' as http;

class PasswordUpdateProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  /// Updated to use HTTP PUT and returns success status
  Future<bool> updatePassword(String oldPassword, String newPassword) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      // 1. Get Token from your storage helper
      final token = await AuthStorage.getAccessToken();

      if (token == null) {
        _errorMessage = "Token not found. Please login again.";
        return false;
      }

      // 2. API Call using PUT
      final url = Uri.parse("http://hoardlinks.controlroom.cordsinnovations.com/api/v1/profile/update/password");
      
      final response = await http.put( // ✅ Changed from patch to put
        url,
        headers: {
          "Content-Type": "application/json",
          "access_token": token,
        },
        body: jsonEncode({
          "oldPassword": oldPassword,
          "newPassword": newPassword,
        }),
      );

      // 3. Handle Response
      debugPrint("Response Status: ${response.statusCode}");
      debugPrint("Response Body: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        _successMessage = data['message'] ?? "Password updated successfully!";
        return true;
      } else {
        _errorMessage = data['message'] ?? "Failed to update password";
        return false;
      }
    } catch (e) {
      _errorMessage = "An error occurred: $e";
      debugPrint("Error updating password: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }
}