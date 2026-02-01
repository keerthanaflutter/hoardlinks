import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hoardlinks/core/constants/loginToken_constant.dart'; 
import 'package:http_parser/http_parser.dart'; // Required for MediaType

class ProfileImageUploadProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _responseMessage;

  bool get isLoading => _isLoading;
  String? get responseMessage => _responseMessage;

  void clearResponseMessage() {
    _responseMessage = null;
    notifyListeners();
  }

  Future<void> uploadProfileImage(File imageFile) async {
    _isLoading = true;
    _responseMessage = null;
    notifyListeners();

    final url = Uri.parse('http://hoardlinks.controlroom.cordsinnovations.com/api/v1/profile/user/image/upload');

    try {
      final String? token = await AuthStorage.getAccessToken();

      // 1. Create the Multipart Request
      var request = http.MultipartRequest('POST', url);

      // 2. Add Headers 
      // IMPORTANT: Removed "Content-Type: application/json"
      request.headers.addAll({
        "access_token": token ?? "",
        "Accept": "application/json", // Good practice to keep this
      });

      // 3. Determine File Extension for MediaType
      String extension = imageFile.path.split('.').last.toLowerCase();
      // Default to jpeg if unknown
      String type = (extension == 'png') ? 'png' : 'jpeg';

      // 4. Add Image File with explicit MediaType
      request.files.add(
        await http.MultipartFile.fromPath(
          'image', 
          imageFile.path,
          contentType: MediaType('image', type), // This tells the server it's an image
        ),
      );

      // 5. Send Request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      _responseMessage = response.body;

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('--- Upload Success ---');
      } else {
        print('--- Upload Failed --- Status: ${response.statusCode}');
      }
    } catch (e) {
      _responseMessage = "Error: ${e.toString()}";
      print('Catch Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}