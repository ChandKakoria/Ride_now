import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sakhi_yatra/core/api_response.dart';
import 'package:sakhi_yatra/services/local_storage_service.dart';
import 'package:sakhi_yatra/main.dart';

class ApiUtils {
  static Future<ApiResponse<T>> handleResponse<T>(
    http.Response response,
    FutureOr<T> Function(dynamic data) mapper,
  ) async {
    print("--- API REQUEST ---");
    print("URL: ${response.request?.url}");
    print("Method: ${response.request?.method}");
    print("Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");
    print("------------------");

    final body = jsonDecode(response.body);

    // Check for token expiration
    if (body is Map && body['msg'] == "Token has expired") {
      print("Token expired! Logging out...");
      await LocalStorageService.clearAll();
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        '/login',
        (route) => false,
      );
      return ApiResponse.error("Session expired. Please login again.");
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        return ApiResponse.completed(await mapper(body));
      } catch (e) {
        return ApiResponse.error("Data mapping error: $e");
      }
    } else {
      return ApiResponse.error(
        body['message'] ?? body['msg'] ?? "Error ${response.statusCode}",
      );
    }
  }
}
