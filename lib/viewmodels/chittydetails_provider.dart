import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hoardlinks/core/constants/loginToken_constant.dart';
import 'package:hoardlinks/data/models/chittydetails_model.dart';
import 'package:http/http.dart' as http;

class ChittyDetailsProvider extends ChangeNotifier {
  bool isLoading = false;
  String? error;
  ChittyDetailsModel? chittyDetails;

  Future<void> fetchChittyDetails(int chittyId) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      /// ✅ GET TOKEN FROM STORAGE
      final token = await AuthStorage.getAccessToken();

      if (token == null) {
        error = "Session expired. Please login again.";
        isLoading = false;
        notifyListeners();
        return;
      }

      final response = await http.get(
        Uri.parse(
          "http://hoardlinks.controlroom.cordsinnovations.com/api/v1/chitty/getChitty/$chittyId",
        ),
        headers: {
          "Content-Type": "application/json",
          "access_token": token, // ✅ dynamic token
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        chittyDetails = ChittyDetailsModel.fromJson(jsonData);
      } else if (response.statusCode == 401) {
        error = "Unauthorized. Please login again.";
      } else {
        error = "Failed to load chitty details";
      }
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  /// 🔁 Reset when leaving screen
  void clear() {
    chittyDetails = null;
    error = null;
  }
}
