import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ride_now/core/api_response.dart';
import 'package:ride_now/core/api_constants.dart';

import 'package:ride_now/services/local_storage_service.dart';

class AuthService {
  Future<ApiResponse<Map<String, dynamic>>> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String dob,
  }) async {
    final String url = ApiConstants.signUp;

    try {
      print("SignUp Payload: $url");
      print(
        "Body: ${jsonEncode({"email": email, "password": password, "first_name": firstName, "last_name": lastName, "phone_number": phoneNumber, "dob": dob})}",
      );

      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
          "first_name": firstName,
          "last_name": lastName,
          "phone_number": phoneNumber,
          "dob": dob,
        }),
      );

      print("SignUp Response Code: ${response.statusCode}");
      print("SignUp Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        // Check and save token if present (Auto-Login)
        if (data.containsKey('access_token')) {
          final String accessToken = data['access_token'];
          await LocalStorageService.saveToken(accessToken);
          // Optional: Save user ID if needed
          // Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);
          // await LocalStorageService.saveUserId(decodedToken['sub']);
        }
        return ApiResponse.completed(data);
      } else {
        return ApiResponse.error("Failed to sign up: ${response.statusCode}");
      }
    } catch (e) {
      print("SignUp Error: $e");
      return ApiResponse.error(e.toString());
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> login({
    required String email,
    required String password,
  }) async {
    final String url = ApiConstants.login;

    try {
      print("Login Payload: $url");
      print("Body: ${jsonEncode({"email": email, "password": password})}");

      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      print("Login Response Code: ${response.statusCode}");
      print("Login Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String accessToken = data['access_token'];

        // Decode token to get user ID
        //  Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);
        //String userId = decodedToken['sub'];

        // Save to local storage
        await LocalStorageService.saveToken(accessToken);
        // await LocalStorageService.saveUserId(userId);

        return ApiResponse.completed(data);
      } else {
        return ApiResponse.error("Failed to login: ${response.statusCode}");
      }
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }
}
