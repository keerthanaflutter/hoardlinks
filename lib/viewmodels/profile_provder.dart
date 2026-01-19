import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hoardlinks/core/constants/loginToken_constant.dart';
import 'package:hoardlinks/data/models/profile_get_model.dart';
import 'package:http/http.dart' as http;

class ProfileProvider with ChangeNotifier {
  Profile? _profile;
  bool _isLoading = false;
  String _error = "";

  Profile? get profile => _profile;
  bool get isLoading => _isLoading;
  String get error => _error;

  // Fetch Profile Data
  Future<void> fetchProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      final String? token = await AuthStorage.getAccessToken();

      // Setup Headers
      final headers = {
        "Content-Type": "application/json",
        "access_token": token ?? "", // Providing fallback empty string if null
      };

      // API Request
      final response = await http.get(
        Uri.parse('https://hoardlinks-backend.onrender.com/api/v1/profile/get'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        _profile = Profile.fromJson(jsonResponse['data']);
        print('Profile fetched successfully: ${_profile?.loginId}'); // Print response in terminal
      } else {
        _error = "Failed to load profile.";
        print('Error: ${response.body}');
      }
    } catch (e) {
      _error = "An error occurred: $e";
      print('Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
