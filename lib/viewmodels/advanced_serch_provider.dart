// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:hoardlinks/core/constants/loginToken_constant.dart';
// import 'package:http/http.dart' as http;

// class AdvanceSearchProvider with ChangeNotifier {
//   bool _isLoading = false;
//   String? _error;
//   List<dynamic> _searchResults = [];

//   bool get isLoading => _isLoading;
//   String? get error => _error;
//   List<dynamic> get searchResults => _searchResults;

//   // Add this method to reset the provider data
//   void clearSearch() {
//     _searchResults = [];
//     _error = null;
//     _isLoading = false;
//     notifyListeners();
//   }

//   Future<void> performAdvancedSearch({
//     String? queryName,
//     int? customDistrictId,
//   }) async {
//     _isLoading = true;
//     _error = null;
//     notifyListeners();

//     try {
//       final token = await AuthStorage.getAccessToken();
//       final stateId = await AuthStorage.getStateId();
//       final districtId = customDistrictId ?? await AuthStorage.getDistrictId();

//       if (stateId == null || districtId == null) {
//         throw Exception('State or District information is missing');
//       }

//       String baseUrl = 'https://hoardlinks-backend.onrender.com/api/v1/agency/agencies/state/$stateId/district/$districtId?';
//       String queryParams = "";

//       if (queryName != null && queryName.trim().isNotEmpty) {
//         queryParams += "q=${Uri.encodeComponent(queryName.trim())}&";
//       }
//       queryParams += "page=1&limit=20";

//       final String finalUrl = baseUrl + queryParams;

//       final response = await http.get(
//         Uri.parse(finalUrl), 
//         headers: {
//           "Content-Type": "application/json",
//           "access_token": token ?? "",
//         }
//       );

//       if (response.statusCode == 200) {
//         final jsonResponse = json.decode(response.body);
//         _searchResults = jsonResponse['data'] ?? [];
//       } else {
//         _error = 'Error ${response.statusCode}: Failed to fetch data';
//       }
//     } catch (e) {
//       _error = 'Connection Error: $e';
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
// }

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hoardlinks/core/constants/loginToken_constant.dart';
import 'package:hoardlinks/data/models/chitty_agency_district_model.dart';
import 'package:http/http.dart' as http;

class AdvanceSearchProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  List<Agency> _searchResults = []; // 🔥 Use Agency model

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Agency> get searchResults => _searchResults;

  void clearSearch() {
    _searchResults = [];
    _error = null;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> performAdvancedSearch({
    String? queryName,
    int? customDistrictId,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final token = await AuthStorage.getAccessToken();
      final stateId = await AuthStorage.getStateId();
      final districtId = customDistrictId ?? await AuthStorage.getDistrictId();

      if (stateId == null || districtId == null) {
        throw Exception('State or District information is missing');
      }

      String baseUrl = 'https://hoardlinks-backend.onrender.com/api/v1/agency/agencies/state/$stateId/district/$districtId?';
      String queryParams = "";

      if (queryName != null && queryName.trim().isNotEmpty) {
        queryParams += "q=${Uri.encodeComponent(queryName.trim())}&";
      }
      queryParams += "page=1&limit=20";

      final response = await http.get(
        Uri.parse(baseUrl + queryParams), 
        headers: {
          "Content-Type": "application/json",
          "access_token": token ?? "",
        }
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        // 🔥 Use the ApiResponse model for parsing
        final apiResponse = ApiResponse.fromJson(jsonResponse);
        _searchResults = apiResponse.data;
      } else {
        _error = 'Error ${response.statusCode}: Failed to fetch data';
      }
    } catch (e) {
      _error = 'Connection Error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}