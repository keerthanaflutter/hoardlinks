import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hoardlinks/core/constants/loginToken_constant.dart';
import 'package:http/http.dart' as http;

class ChittyBidProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  bool _isBidSuccessful = false;
  String? _successMessage;

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isBidSuccessful => _isBidSuccessful;
  String? get successMessage => _successMessage;

  void resetState() {
    _isLoading = false;
    _error = null;
    _isBidSuccessful = false;
    _successMessage = null;
    notifyListeners();
  }

  Future<void> sendBid({
    required int auctionId,
    required int chittyId,
    required int memberNo,
    required int monthIndex,
    required double bidAmount,
  }) async {
    try {
      _isLoading = true;
      _isBidSuccessful = false;
      _error = null;
      notifyListeners();

      final token = await AuthStorage.getAccessToken();
      if (token == null) throw Exception('Access token is missing');

      final headers = {
        "Content-Type": "application/json",
        "access_token": token,
      };

      final body = jsonEncode({
        "auction_id": auctionId,
        "chitty_id": chittyId,
        "member_no": memberNo,
        "month_index": monthIndex,
        "bid_amount": bidAmount,
      });

      final url = Uri.parse('http://hoardlinks.controlroom.cordsinnovations.com/api/v1/chitty/chitty_auction_bid');
      
      // Print Request Details
      debugPrint("--- SENDING BID REQUEST ---");
      debugPrint("URL: $url");
      debugPrint("Body: $body");

      final response = await http.post(url, headers: headers, body: body);

      // --- Terminal Printing Logic ---
      debugPrint("--- BID API RESPONSE RECEIVED ---");
      debugPrint("Status Code: ${response.statusCode}");
      debugPrint("Response Body: ${response.body}"); // THIS PRINTS THE RAW JSON
      
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        _isBidSuccessful = true;
        _successMessage = responseData['message'] ?? "Bid placed successfully!";
        _error = null;
        debugPrint("Success: $_successMessage");
      } else {
        _error = responseData['message'] ?? 'Failed to place bid';
        debugPrint("API Error: $_error");
      }
    } catch (e) {
      _error = 'Connection Error: $e';
      debugPrint("Exception Caught: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}