import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:sakhi_yatra/core/api_response.dart';
import 'package:sakhi_yatra/core/api_constants.dart';
import 'package:sakhi_yatra/core/api_utils.dart';
import 'package:sakhi_yatra/core/app_strings.dart';
import 'package:sakhi_yatra/core/models/user_model.dart';
import 'package:sakhi_yatra/services/local_storage_service.dart';

class UserService {
  Future<ApiResponse<UserModel>> getProfile() async {
    if (kDebugMode) print("UserService: getProfile() triggered");
    final String url = ApiConstants.profile;
    final String? token = LocalStorageService.getToken();

    if (token == null) {
      if (kDebugMode) print("UserService: Auth token missing");
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
      return ApiResponse.error(ApiUtils.handleError(e));
    }
  }


  Future<ApiResponse<dynamic>> updateProfile(Map<String, dynamic> data) async {
    if (kDebugMode) print("UserService: updateProfile() triggered");
    final String url = ApiConstants.profile;
    final String? token = LocalStorageService.getToken();

    if (token == null) {
      return ApiResponse.error(AppStrings.errorAuth);
    }

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode(data),
      );

      return ApiUtils.handleResponse<dynamic>(response, (data) => data);
    } catch (e) {
      return ApiResponse.error(ApiUtils.handleError(e));
    }
  }

  Future<ApiResponse<dynamic>> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    if (kDebugMode) print("UserService: changePassword() triggered");
    final String url = ApiConstants.changePassword;
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
        body: json.encode({
          "current_password": currentPassword,
          "new_password": newPassword,
        }),
      );

      return ApiUtils.handleResponse<dynamic>(response, (data) => data);
    } catch (e) {
      return ApiResponse.error(ApiUtils.handleError(e));
    }
  }

  Future<ApiResponse<dynamic>> deleteAccount() async {
    if (kDebugMode) print("UserService: deleteAccount() triggered");
    final String url = ApiConstants.removeAccount;
    final String? token = LocalStorageService.getToken();

    if (token == null) {
      return ApiResponse.error(AppStrings.errorAuth);
    }

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      return ApiUtils.handleResponse<dynamic>(response, (data) => data);
    } catch (e) {
      return ApiResponse.error(ApiUtils.handleError(e));
    }
  }
}
