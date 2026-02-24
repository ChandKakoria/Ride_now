class ApiConstants {
  // Base URL
  static const String baseUrl =
      "https://python-beckend-chandkakorias-projects.vercel.app/api";

  // Auth Endpoints
  static String get signUp => "$baseUrl/signup";
  static String get login => "$baseUrl/login";

  // Ride Endpoints
  static String get createRide => "$baseUrl/rides";
  static String searchRides(String pickup, String dropoff) =>
      "$baseUrl/rides/search?pickup_location=$pickup&dropoff_location=$dropoff";
}
