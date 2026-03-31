class ApiConstants {
  // Base URL
  static const String baseUrl =
      "https://python-beckend-chandkakorias-projects.vercel.app/api";

  // Auth Endpoints
  static String get signUp => "$baseUrl/signup";
  static String get login => "$baseUrl/login";
  static String get forgotPassword => "$baseUrl/forgot-password";
  static String get removeAccount => "$baseUrl/remove-account";

  // Ride Endpoints
  static String get createRide => "$baseUrl/rides";
  static String get myRides => "$baseUrl/rides/my-rides";
  static String get bookedRides => "$baseUrl/rides/my-booked-rides";
  static String get bookRide => "$baseUrl/rides/book";
  static String get acceptRequest => "$baseUrl/rides/requests/approve";
  static String get cancelRide => "$baseUrl/rides/cancel";
  static String get profile => "$baseUrl/profile";
  static String get vehicles => "$baseUrl/vehicles";
  static String get addVehicle => "$baseUrl/add-vehicle";
  static String get removeVehicle => "$baseUrl/remove-vehicle";
  static String get changePassword => "$baseUrl/change-password";
  static String get privacy => "https://python-beckend-chandkakorias-projects.vercel.app/api/privacy-page";
  static String get terms => "https://python-beckend-chandkakorias-projects.vercel.app/api/terms-page";
  static String get chatList => "$baseUrl/chat-list";
  static String get sendChatNotification => "$baseUrl/send-chat-notification";
  static String get updateFcmToken => "$baseUrl/update-fcm-token";
  static String rideDetails(String id) => "$baseUrl/rides/$id";
  static String searchRides(String pickup, String dropoff, String? date) =>
      "$baseUrl/rides/search?pickup_location=$pickup&dropoff_location=$dropoff${date != null ? '&date=$date' : ''}";
}
