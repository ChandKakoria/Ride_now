import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sakhi_yatra/core/api_response.dart';
import 'package:sakhi_yatra/core/api_constants.dart';
import 'package:sakhi_yatra/core/api_utils.dart';
import 'package:sakhi_yatra/core/models/user_model.dart';
import 'package:sakhi_yatra/services/local_storage_service.dart';
import 'package:sakhi_yatra/main.dart';

class AuthService {
  Future<ApiResponse<Map<String, dynamic>>> login(
    String email,
    String password,
  ) async {
    final String url = ApiConstants.login;
    try {
      String? fcmToken;
      try {
        fcmToken = await FirebaseMessaging.instance.getToken();
      } catch (e) {
        if (kDebugMode) print("Error getting FCM token: $e");
      }

      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
          if (fcmToken != null) "fcm_token": fcmToken,
        }),
      );
      return ApiUtils.handleResponse<Map<String, dynamic>>(response, (
        data,
      ) async {
        final res = data as Map<String, dynamic>;
        final token = res['token'] ?? res['access_token'];
        if (token != null) {
          await LocalStorageService.saveToken(token);
          if (res['user'] != null)
            await LocalStorageService.saveUser(jsonEncode(res['user']));
        }
        return res;
      });
    } catch (e) {
      return ApiResponse.error(ApiUtils.handleError(e));
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> signUp(
    UserModel user,
    String password,
  ) async {
    final String url = ApiConstants.signUp;
    final Map<String, dynamic> userData = user.toJson();
    userData['password'] = password;
    
    try {
      String? fcmToken;
      try {
        fcmToken = await FirebaseMessaging.instance.getToken();
      } catch (e) {
        if (kDebugMode) print("Error getting FCM token: $e");
      }
      if (fcmToken != null) {
        userData['fcm_token'] = fcmToken;
      }

      if (kDebugMode) print("Signup Payload: ${jsonEncode(userData)}");
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(userData),
      );
      return ApiUtils.handleResponse<Map<String, dynamic>>(response, (
        data,
      ) async {
        final res = data as Map<String, dynamic>;
        final token = res['token'] ?? res['access_token'];
        if (token != null) {
          await LocalStorageService.saveToken(token);
          if (res['user'] != null)
            await LocalStorageService.saveUser(jsonEncode(res['user']));
        }
        return res;
      });
    } catch (e) {
      return ApiResponse.error(ApiUtils.handleError(e));
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> forgotPassword(String email) async {
    final String url = ApiConstants.forgotPassword;
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );
      return ApiUtils.handleResponse<Map<String, dynamic>>(response, (
        data,
      ) async {
        return data as Map<String, dynamic>;
      });
    } catch (e) {
      return ApiResponse.error(ApiUtils.handleError(e));
    }
  }

  Future<void> logout() async {
    await LocalStorageService.clearAll();
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      '/login',
      (route) => false,
    );
  }

  static UserModel? get currentUser {
    final userStr = LocalStorageService.getUser();
    if (userStr != null) {
      try {
        return UserModel.fromJson(jsonDecode(userStr));
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}
