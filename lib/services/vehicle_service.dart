import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ride_now/core/api_response.dart';
import 'package:ride_now/core/api_constants.dart';
import 'package:ride_now/core/api_utils.dart';
import 'package:ride_now/core/app_strings.dart';
import 'package:ride_now/core/models/vehicle_model.dart';
import 'package:ride_now/services/local_storage_service.dart';

class VehicleService {
  Future<ApiResponse<List<VehicleModel>>> getVehicles() async {
    final String url = ApiConstants.vehicles;
    final String? token = LocalStorageService.getToken();

    if (token == null) {
      return ApiResponse.error(AppStrings.errorAuth);
    }

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      return ApiUtils.handleResponse<List<VehicleModel>>(response, (data) {
        final List list = data is List ? data : (data['vehicles'] ?? []);
        return list.map((item) => VehicleModel.fromJson(item)).toList();
      });
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  Future<ApiResponse<dynamic>> addVehicle(Map<String, dynamic> data) async {
    final String url = ApiConstants.vehicles;
    final String? token = LocalStorageService.getToken();

    if (token == null) {
      return ApiResponse.error(AppStrings.errorAuth);
    }

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode(data),
      );

      return ApiUtils.handleResponse<dynamic>(response, (data) => data);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }
}
