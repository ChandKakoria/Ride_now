import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sakhi_yatra/core/api_response.dart';
import 'package:sakhi_yatra/core/api_constants.dart';
import 'package:sakhi_yatra/core/api_utils.dart';
import 'package:sakhi_yatra/core/app_strings.dart';
import 'package:sakhi_yatra/services/local_storage_service.dart';

class RideActionService {
  Future<ApiResponse<Map<String, dynamic>>> createRide(
    Map<String, dynamic> rideData,
  ) async {
    print("RideActionService: createRide() triggered");
    final String url = ApiConstants.createRide;
    final String? token = LocalStorageService.getToken();

    if (token == null) {
      print("RideActionService: Auth token missing for createRide");
      return ApiResponse.error(AppStrings.errorAuth);
    }

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(rideData),
      );

      return ApiUtils.handleResponse<Map<String, dynamic>>(
        response,
        (data) => data as Map<String, dynamic>,
      );
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> bookRide(String rideId) async {
    print("RideActionService: bookRide($rideId) triggered");
    final String url = ApiConstants.bookRide;
    final String? token = LocalStorageService.getToken();

    if (token == null) {
      print("RideActionService: Auth token missing for bookRide");
      return ApiResponse.error(AppStrings.errorAuth);
    }

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"ride_id": rideId}),
      );

      return ApiUtils.handleResponse<Map<String, dynamic>>(
        response,
        (data) => data as Map<String, dynamic>,
      );
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> acceptRideRequest(
    String requestId,
  ) async {
    print("RideActionService: acceptRideRequest($requestId) triggered");
    final String url = ApiConstants.acceptRequest;
    final String? token = LocalStorageService.getToken();

    if (token == null) {
      print("RideActionService: Auth token missing for acceptRideRequest");
      return ApiResponse.error(AppStrings.errorAuth);
    }

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"request_id": requestId}),
      );

      return ApiUtils.handleResponse<Map<String, dynamic>>(
        response,
        (data) => data as Map<String, dynamic>,
      );
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }
}
