import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hoardlinks/core/constants/loginToken_constant.dart';
import 'package:hoardlinks/data/models/chittylist_model.dart';
import 'package:http/http.dart' as http;
class ChittyProvider extends ChangeNotifier {
  bool _isLoading = false;
  ChittyResponseModel? _chittyResponse;
  String? _error;

  bool get isLoading => _isLoading;
  ChittyResponseModel? get chittyResponse => _chittyResponse;
  String? get error => _error;

  Future<void> fetchAllChitty() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    const url = 'http://hoardlinks.controlroom.cordsinnovations.com/api/v1/chitty/getAllChitty';

    try {
      final token = await AuthStorage.getAccessToken();
      if (token == null) {
        _error = "Token not found";
        _isLoading = false;
        notifyListeners();
        return;
      }

      // 🔥 Force the UI to wait for at least 3 seconds 
      // even if the API responds instantly.
      final results = await Future.wait([
        http.get(Uri.parse(url), headers: {
          "Content-Type": "application/json",
          "access_token": token,
        }),
        Future.delayed(const Duration(seconds: 3)), // The 3s shimmer lock
      ]);

      final response = results[0] as http.Response;

      if (response.statusCode == 200) {
        _chittyResponse = ChittyResponseModel.fromJson(jsonDecode(response.body));
      } else {
        _error = "Failed to fetch data";
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}