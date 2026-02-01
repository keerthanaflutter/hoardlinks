
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hoardlinks/core/constants/loginToken_constant.dart';
import 'package:hoardlinks/data/models/chitty_agency_district_model.dart';
import 'package:http/http.dart' as http;

class AdvanceSearchProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  List<Agency> _searchResults = [];

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
    String? queryName, // General query (q)
    String? tradeName, // Added trade_name
    String? legalName, // Added legal_name
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

      // Base URL
      String baseUrl = 'http://hoardlinks.controlroom.cordsinnovations.com/api/v1/agency/agencies/state/$stateId/district/$districtId?';
      
      // Build query parameters dynamically
      List<String> params = [];

      // 1. General query 'q'
      if (queryName != null && queryName.trim().isNotEmpty) {
        params.add("q=${Uri.encodeComponent(queryName.trim())}");
      }

      // 2. Trade Name param
      if (tradeName != null && tradeName.trim().isNotEmpty) {
        params.add("trade_name=${Uri.encodeComponent(tradeName.trim())}");
      }

      // 3. Legal Name param
      if (legalName != null && legalName.trim().isNotEmpty) {
        params.add("legal_name=${Uri.encodeComponent(legalName.trim())}");
      }

      // 4. Default Pagination
      params.add("page=1");
      params.add("limit=20");

      // Join all params with '&'
      String finalUrl = baseUrl + params.join("&");

      final response = await http.get(
        Uri.parse(finalUrl), 
        headers: {
          "Content-Type": "application/json",
          "access_token": token ?? "",
        }
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
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
