import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hoardlinks/core/constants/loginToken_constant.dart';
import 'package:hoardlinks/data/models/chittylist_model.dart';
import 'package:http/http.dart' as http;

class ChittyProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  ChittyResponseModel? _chittyResponse;

  bool get isLoading => _isLoading;
  String? get error => _error;
  ChittyResponseModel? get chittyResponse => _chittyResponse;

  get errorMessage => null;

  Future<void> fetchAllChitty() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    const url =
        'https://hoardlinks-backend.onrender.com/api/v1/chitty/getAllChitty';

    try {
      /// ✅ GET TOKEN FROM STORAGE
      final token = await AuthStorage.getAccessToken();

      if (token == null) {
        _error = "Token not found. Please login again.";
        _isLoading = false;
        notifyListeners();
        return;
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "access_token": token, // ✅ DYNAMIC TOKEN
        },
      );

      print('STATUS CODE: ${response.statusCode}');
      print('RAW RESPONSE: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        _chittyResponse = ChittyResponseModel.fromJson(decoded);

        /// 🔥 DEBUG PRINTS
        print('MESSAGE: ${_chittyResponse!.message}');
        print('OPEN COUNT: ${_chittyResponse!.open.length}');
        print('RUNNING COUNT: ${_chittyResponse!.running.length}');
        print('CLOSED COUNT: ${_chittyResponse!.closed.length}');
      } else if (response.statusCode == 401) {
        _error = "Session expired. Please login again.";
      } else {
        _error = "Failed to fetch chitty list";
      }
    } catch (e) {
      _error = e.toString();
      print('ERROR: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}
