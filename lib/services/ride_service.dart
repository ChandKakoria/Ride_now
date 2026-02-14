import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ride_now/core/api_response.dart';
import 'package:ride_now/core/api_constants.dart';
import 'package:ride_now/services/local_storage_service.dart';

class RideService {
  Future<ApiResponse<Map<String, dynamic>>> createRide(
    Map<String, dynamic> rideData,
  ) async {
    final String url = ApiConstants.createRide;
    final String? token = LocalStorageService.getToken();

    if (token == null) {
      return ApiResponse.error("User not authenticated");
    }

    try {
      print("CreateRide Payload: $url");
      print("Body: ${jsonEncode(rideData)}");

      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(rideData),
      );

      print("CreateRide Response Code: ${response.statusCode}");
      print("CreateRide Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return ApiResponse.completed(data);
      } else {
        return ApiResponse.error(
          "Failed to create ride: ${response.statusCode}",
        );
      }
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }
}
