import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hoardlinks/core/constants/loginToken_constant.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // Add intl to pubspec.yaml for date formatting


class ChittyJoinProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _responseData;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic>? get responseData => _responseData;

  Future<void> joinChitty({
    required int chittyId,
    required String remarks,
    required int numberOfReq,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    const String url = 'http://hoardlinks.controlroom.cordsinnovations.com/api/v1/chitty/JoinChitty';

    try {
      // 1. Retrieve the access token from storage
      final String? token = await AuthStorage.getAccessToken();

      // 2. Setup Headers
      final headers = {
        "Content-Type": "application/json",
        "access_token": token ?? "", // Providing fallback empty string if null
      };

      // 3. Setup Dates
      final DateTime now = DateTime.now();
      final String formattedJoinDate = DateFormat('yyyy-MM-dd').format(now);
      final String formattedExitDate = DateFormat('yyyy-MM-dd').format(now.add(const Duration(days: 30)));

      // 4. Setup Body
      final Map<String, dynamic> body = {
        "chitty_id": chittyId,
        "remarks": remarks,
        "number_of_req": numberOfReq,
        "join_date": formattedJoinDate,
        "exit_date": formattedExitDate,
      };

      print("--- Sending Authenticated Join Request ---");
      print("Headers: $headers");
      print("Payload: ${jsonEncode(body)}");

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      _responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("--- Success Response ---");
        print(_responseData);
        _errorMessage = null;
      } else {
        print("--- Error Response (${response.statusCode}) ---");
        print(_responseData);
        _errorMessage = _responseData?['message'] ?? "Failed to join chitty";
      }
    } catch (e) {
      print("--- Connection Error ---");
      print(e.toString());
      _errorMessage = "Network error: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}