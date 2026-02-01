import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hoardlinks/core/constants/loginToken_constant.dart';
import 'package:hoardlinks/data/models/agency_details_model.dart';
import 'package:http/http.dart' as http;

class AgencyDetailprovider with ChangeNotifier {
  AgencyDetailModel? _agencyDetail;
  bool _isLoading = false;

  AgencyDetailModel? get agencyDetail => _agencyDetail;
  bool get isLoading => _isLoading;

  Future<void> fetchAgencyDetails(int agencyId) async {
    _isLoading = true;
    notifyListeners();

    final String url = 'http://hoardlinks.controlroom.cordsinnovations.com/api/v1/agency/get/$agencyId';

    try {
      final String? token = await AuthStorage.getAccessToken();

      final headers = {
        "Content-Type": "application/json",
        "access_token": token ?? "",
      };

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      // Printing the response in the terminal as requested
      debugPrint("API Response Status: ${response.statusCode}");
      debugPrint("API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedData = json.decode(response.body);
        _agencyDetail = AgencyDetailModel.fromJson(decodedData);
      } else {
        debugPrint("Error: Failed to fetch data");
      }
    } catch (e) {
      debugPrint("Exception caught: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}