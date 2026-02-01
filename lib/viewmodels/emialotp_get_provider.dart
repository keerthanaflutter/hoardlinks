import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EmailOtpGetProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<String?> getOtp(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final url = Uri.parse("http://hoardlinks.controlroom.cordsinnovations.com/api/v1/auth/get/otp");
    final body = jsonEncode({"email": email});

    // 🔥 PRINT REQUEST DETAILS
    debugPrint("-------------------------------");
    debugPrint("🚀 SENDING OTP REQUEST");
    debugPrint("🔗 URL: $url");
    debugPrint("📦 BODY: $body");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      // 🔥 PRINT RAW RESPONSE
      debugPrint("📩 STATUS CODE: ${response.statusCode}");
      debugPrint("📄 RAW RESPONSE: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        _isLoading = false;
        notifyListeners();
        
        debugPrint("✅ TOKEN RECEIVED: ${data['resetToken']}");
        debugPrint("-------------------------------");
        return data['resetToken']; 
      } else {
        _errorMessage = data['message'] ?? "Failed to get OTP";
        _isLoading = false;
        notifyListeners();
        
        debugPrint("⚠️ API ERROR MESSAGE: $_errorMessage");
        debugPrint("-------------------------------");
        return null;
      }
    } catch (e) {
      _errorMessage = "An error occurred: $e";
      _isLoading = false;
      notifyListeners();
      
      debugPrint("❌ EXCEPTION CAUGHT: $e");
      debugPrint("-------------------------------");
      return null;
    }
  }
}