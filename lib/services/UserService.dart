import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserDetailsService {
  final String baseUrl = 'http://your-backend-url.com/user_details/';
  final storage = const FlutterSecureStorage();

  Future<bool> submitUserDetails(UserDetailsModel userDetails) async {
    try {
      // Get the access token from secure storage
      final accessToken = await storage.read(key: 'access_token');
      if (accessToken == null) {
        throw Exception('No access token found');
      }

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode(userDetails.toJson()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        // Parse error message from the backend
        final errorBody = json.decode(response.body);
        throw Exception(errorBody['detail'] ?? 'Failed to submit user details');
      }
    } catch (e) {
      print('Error submitting user details: $e');
      return false;
    }
  }

  Future<bool> updateUserDetails(UserDetailsModel userDetails) async {
    try {
      final accessToken = await storage.read(key: 'access_token');
      if (accessToken == null) {
        throw Exception('No access token found');
      }

      final response = await http.put(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode(userDetails.toJson()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        final errorBody = json.decode(response.body);
        throw Exception(errorBody['detail'] ?? 'Failed to update user details');
      }
    } catch (e) {
      print('Error updating user details: $e');
      return false;
    }
  }
}