import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hoardlinks/core/constants/loginToken_constant.dart';
import 'package:hoardlinks/data/models/autionid_get_model.dart';
import 'package:http/http.dart' as http;

class AuctionIdProvider with ChangeNotifier {
  ChittyAuctionBid? _bidData;
  bool _isLoading = false;
  String? _errorMessage;

  ChittyAuctionBid? get bidData => _bidData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchAuctionBid(int chittyId, int cycleId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final url =
        'http://hoardlinks.controlroom.cordsinnovations.com/api/v1/chitty/get/chittyAuctionBidId/$chittyId/$cycleId';

    try {
      final token = await AuthStorage.getAccessToken();
      print('Access Token: $token');
      print('Request URL: $url');
      print('ChittyId: $chittyId, CycleId: $cycleId');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "access_token": token ?? "",
        },
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}'); // This will print the response body in the terminal

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['success'] == true && data['data'] != null && data['data'].isNotEmpty) {
          _bidData = ChittyAuctionBid.fromJson(data['data'][0]);  // Get the first item from the data array
        } else {
          _errorMessage = "No auction bid data found";
        }
      } else {
        _errorMessage = "Failed to load data: ${response.statusCode}";
      }
    } catch (e) {
      _errorMessage = "An error occurred: $e";
      print('Error: $e'); // Log any errors in the terminal
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
