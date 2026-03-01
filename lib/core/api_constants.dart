class ApiConstants {
  // Base URL
  static const String baseUrl =
      "https://python-beckend-chandkakorias-projects.vercel.app/api";

  // Auth Endpoints
  static String get signUp => "$baseUrl/signup";
  static String get login => "$baseUrl/login";

  // Ride Endpoints
  static String get createRide => "$baseUrl/rides";
  static String get myRides => "$baseUrl/rides/my-rides";
  static String get bookedRides => "$baseUrl/rides/my-booked-rides";
  static String get bookRide => "$baseUrl/rides/book";
  static String get acceptRequest => "$baseUrl/rides/requests/approve";
  static String get profile => "$baseUrl/profile";
  static String rideDetails(String id) => "$baseUrl/rides/$id";
  static String searchRides(String pickup, String dropoff) =>
      "$baseUrl/rides/search?pickup_location=$pickup&dropoff_location=$dropoff";
}
