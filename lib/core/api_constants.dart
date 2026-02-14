import 'dart:io';

class ApiConstants {
  // Base URL
  // Android Emulator uses 10.0.2.2 to access host localhost
  // iOS Simulator uses 127.0.0.1
  static String baseUrl = Platform.isAndroid
      ? "http://10.0.2.2:5000"
      : "http://127.0.0.1:5000";

  // Auth Endpoints
  static String get signUp => "$baseUrl/api/signup";
  static String get login => "$baseUrl/api/login";

  // Ride Endpoints
  static String get createRide => "$baseUrl/api/rides";
}
