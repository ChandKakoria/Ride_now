import 'package:http/http.dart' as http;
import 'package:sakhi_yatra/core/api_response.dart';
import 'package:sakhi_yatra/core/api_constants.dart';
import 'package:sakhi_yatra/core/api_utils.dart';
import 'package:sakhi_yatra/core/app_strings.dart';
import 'package:sakhi_yatra/core/models/ride_model.dart';
import 'package:sakhi_yatra/services/local_storage_service.dart';

class RideService {
  Future<ApiResponse<List<RideModel>>> searchRides({
    required String pickup,
    required String dropoff,
    String? date,
  }) async {
    print("RideService: searchRides($pickup, $dropoff, $date) triggered");
    final String url = ApiConstants.searchRides(pickup, dropoff, date);

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      return ApiUtils.handleResponse<List<RideModel>>(response, (data) {
        final List list = data['rides'] ?? [];
        return list.map((e) {
          final rideJson = e['ride_details'] ?? e;
          return RideModel.fromJson(rideJson);
        }).toList();
      });
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  Future<ApiResponse<List<RideModel>>> getMyRides() async {
    print("RideService: getMyRides() triggered");
    final String url = ApiConstants.myRides;
    final String? token = LocalStorageService.getToken();

    if (token == null) {
      print("RideService: Auth token missing for getMyRides");
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

      return ApiUtils.handleResponse<List<RideModel>>(response, (data) {
        final List list = data['rides'] ?? [];
        return list.map((e) {
          final rideJson = e['ride_details'] ?? e;
          return RideModel.fromJson(rideJson);
        }).toList();
      });
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  Future<ApiResponse<List<RideModel>>> getMyBookedRides() async {
    print("RideService: getMyBookedRides() triggered");
    final String url = ApiConstants.bookedRides;
    final String? token = LocalStorageService.getToken();

    if (token == null) {
      print("RideService: Auth token missing for getMyBookedRides");
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

      return ApiUtils.handleResponse<List<RideModel>>(response, (data) {
        final List list = data['booked_rides'] ?? [];
        return list.map((e) {
          final rideJson = e['ride_details'] ?? e;
          return RideModel.fromJson(rideJson);
        }).toList();
      });
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  Future<ApiResponse<RideModel>> getRideDetails(String id) async {
    print("RideService: getRideDetails($id) triggered");
    final String url = ApiConstants.rideDetails(id);
    final String? token = LocalStorageService.getToken();

    if (token == null) {
      print("RideService: Auth token missing for getRideDetails");
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

      return ApiUtils.handleResponse<RideModel>(
        response,
        (data) => RideModel.fromJson(data['ride']),
      );
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }
}
