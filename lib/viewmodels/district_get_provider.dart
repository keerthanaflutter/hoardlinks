import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hoardlinks/data/models/disrict_get_model.dart';
import 'package:http/http.dart' as http;

class DistrictGetProvider with ChangeNotifier {
  List<DistrictModel> _districts = [];
  bool _isLoading = false;
  String? _error;

  List<DistrictModel> get districts => _districts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchDistricts() async {
    _isLoading = true;
    _error = null;
    // We notify listeners immediately to show the loading spinner in the UI
    notifyListeners();

    final url = Uri.parse("http://hoardlinks.controlroom.cordsinnovations.com/api/v1/district/getAll");

    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedData = jsonDecode(response.body);
        final districtResponse = DistrictResponse.fromJson(decodedData);
        _districts = districtResponse.data;
      } else {
        _error = "Failed to load districts. Server returned: ${response.statusCode}";
      }
    } catch (e) {
      _error = "An unexpected error occurred: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}