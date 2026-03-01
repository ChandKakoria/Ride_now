import 'package:http/http.dart' as http;
import 'package:ride_now/core/api_response.dart';
import 'package:ride_now/core/api_constants.dart';
import 'package:ride_now/core/api_utils.dart';
import 'package:ride_now/core/app_strings.dart';
import 'package:ride_now/core/models/user_model.dart';
import 'package:ride_now/services/local_storage_service.dart';

class UserService {
  Future<ApiResponse<UserModel>> getProfile() async {
    print("UserService: getProfile() triggered");
    final String url = ApiConstants.profile;
    final String? token = LocalStorageService.getToken();

    if (token == null) {
      print("UserService: Auth token missing");
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

      return ApiUtils.handleResponse<UserModel>(response, (data) {
        final userJson = data['user'] ?? data;
        return UserModel.fromJson(userJson);
      });
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }
}
