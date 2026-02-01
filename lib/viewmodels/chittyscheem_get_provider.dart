import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hoardlinks/core/constants/loginToken_constant.dart';
import 'package:http/http.dart' as http;// Import your AuthStorage class
import 'package:hoardlinks/data/models/chitty_agency_district_model.dart'; // Your model for the agency data

class AgencyProvider with ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage = '';
  List<Agency> _agencies = [];

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  List<Agency> get agencies => _agencies;

  // Fetch Agencies using dynamic stateId and districtId from AuthStorage
  Future<void> fetchAgencies() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Fetch the dynamic token from AuthStorage
      final token = await AuthStorage.getAccessToken();

      // Check if token is null (session expired or not logged in)
      if (token == null) {
        _errorMessage = "Session expired. Please login again.";
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Fetch stateId and districtId from AuthStorage
      final stateId = await AuthStorage.getStateId();
      final districtId = await AuthStorage.getDistrictId();

      if (stateId == null || districtId == null) {
        _errorMessage = "State ID or District ID is missing.";
        _isLoading = false;
        notifyListeners();
        return;
      }

      final headers = {
        "Content-Type": "application/json",
        "access_token": token,
      };

      final url =
          'http://hoardlinks.controlroom.cordsinnovations.com/api/v1/agency/agencies/state/$stateId/district/$districtId?page=1&limit=20';
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final apiResponse = ApiResponse.fromJson(jsonResponse);
        _agencies = apiResponse.data;

        // Log the response data in the terminal for debugging
        print('Response Data: ${response.body}');
        _errorMessage = '';
      } else {
        _errorMessage = 'Failed to load agencies: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
    }

    _isLoading = false;
    notifyListeners();
  }
}
