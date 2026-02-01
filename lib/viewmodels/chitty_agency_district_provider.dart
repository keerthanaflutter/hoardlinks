import 'package:flutter/material.dart';
import 'package:hoardlinks/core/constants/loginToken_constant.dart';
import 'package:hoardlinks/data/models/chitty_agency_district_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChittyDistrictAgencyProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  List<Agency> _agencies = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Agency> get agencies => _agencies;

  // Fetch agencies using stateId and districtId from AuthStorage
  Future<void> fetchAgencies() async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await AuthStorage.getAccessToken();
      if (token == null) throw Exception('Access token is missing');

      // Fetch stateId and districtId from AuthStorage
      final stateId = await AuthStorage.getStateId();
      final districtId = await AuthStorage.getDistrictId();

      if (stateId == null || districtId == null) {
        throw Exception('State ID or District ID is missing');
      }

      final headers = {
        "Content-Type": "application/json",
        "access_token": token,
      };

      final url =
          'http://hoardlinks.controlroom.cordsinnovations.com/api/v1/agency/agencies/state/$stateId/district/$districtId?page=1&limit=20';
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final apiResponse = ApiResponse.fromJson(jsonResponse);
        _agencies = apiResponse.data;
        _error = null;

        // Log the response data in the terminal for debugging
        print('Response Data: ${response.body}');
      } else {
        _error = 'Failed to load data';
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
