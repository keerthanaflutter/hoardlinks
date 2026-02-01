import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  Future<bool> resetPassword({
    required String resetToken,
    required String newPassword,
    required String code,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    final url = Uri.parse("http://hoardlinks.controlroom.cordsinnovations.com/api/v1/auth/verifyotp/resetpassword");

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "resetToken": resetToken,
          "newPassword": newPassword,
          "code": code,
        }),
      );

      debugPrint("📩 RESET STATUS: ${response.statusCode}");
      debugPrint("📄 RESET RESPONSE: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        _successMessage = data['message'] ?? "Password reset successfully!";
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = data['message'] ?? "Failed to reset password";
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = "Connection error: $e";
      debugPrint("❌ RESET API ERROR: $e");
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Helper to clear messages after they are shown in UI
  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
  }
}