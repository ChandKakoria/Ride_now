class AppStrings {
  // App Title
  static const String appName = 'SakhiYatra';

  // API Message Constants
  static const String errorAuth = 'User not authenticated';
  static const String errorGeneric = 'Something went wrong. Please try again.';
  static const String successRideBooked = 'Ride booked successfully!';
  static const String successRequestAccepted = 'Request accepted!';
  static const String errorBookingFailed = 'Failed to book ride';
  static const String errorAcceptFailed = 'Failed to accept request';

  // Screen Titles
  static const String titleRideDetails = 'Ride details';
  static const String titleMyRides = 'My Rides';
  static const String titlePublishRide = 'Publish Ride';
  static const String titleProfile = 'Profile';

  // Labels
  static const String labelPickup = 'Pickup Location';
  static const String labelDropoff = 'Dropoff Location';
  static const String labelPassenger = 'passenger';
  static const String labelSeatsTotal = 'seats total';
  static const String labelBookedSeats = 'booked';
  static const String labelAvailableSeats = 'available';
  static const String labelBookedPassengers = 'Booked Passengers';
  static const String labelRideRequests = 'Ride Requests';
  static const String labelStatus = 'Status';
  static const String labelAccept = 'Accept';
  static const String labelBook = 'Book';
  static const String labelRequested = 'Requested';
  static const String labelBooked = 'Booked';

  // Auth Screens
  static const String welcomeBack = 'Welcome Back';
  static const String signInToContinue = 'Sign in to continue';
  static const String signIn = 'Sign In';
  static const String signUp = 'Sign Up';
  static const String createAccount = 'Create Account';
  static const String forgotPassword = 'Forgot Password?';
  static const String noAccount = "Don't have an account? Sign Up";
  static const String haveAccount = 'Already have an account? Sign In';

  // Validation
  static const String validEmailReq = 'Valid email required';
  static const String passwordReq = 'Password required';
  static const String requiredField = 'Required';
  static const String invalidField = 'Invalid';
  static const String tooShort = 'Too short';
  static const String min6Chars = 'Min 6 chars';
  static const String dobFormatReq = 'YYYY-MM-DD required';

  // Publish Flow
  static const String setPricePerSeat = 'Set your price per seat';
  static const String recommended = 'Recommended';
  static const String publishRide = 'Publish Ride';
  static const String ridePublished = 'Ride Published Successfully!';
  static const String selectDateDuration = 'Please select date and time';

  // Profile
  static const String completeProfile = 'Complete your profile';
  static const String trustBuilding =
      'This helps builds trust, encouraging members to travel with you.';
  static const String verifyProfile = 'Verify your profile';
  static const String editProfilePic = 'Edit profile picture';
  static const String editPersonalDetails = 'Edit personal details';
  static const String logout = 'Logout';
  static const String confirmLogout = 'Are you sure?';
  static const String cancel = 'Cancel';

  // Ride Search
  static const String whereToNext = 'Where to\nnext?';
  static const String leavingFrom = 'Leaving from';
  static const String goingTo = 'Going to';
  static const String searchRides = 'Search Rides';
  static const String enterLocations =
      'Please enter pickup and dropoff locations';
  static const String noRidesFound = 'No rides found';
  static const String tryDifferentSearch = 'Try different locations or dates';
}
