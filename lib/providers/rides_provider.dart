import 'package:flutter/material.dart';
import 'package:sakhi_yatra/core/api_response.dart';
import 'package:sakhi_yatra/core/models/ride_model.dart';
import 'package:sakhi_yatra/services/ride_service.dart';
import 'package:sakhi_yatra/services/ride_action_service.dart';

class RidesProvider extends ChangeNotifier {
  final RideService _rideService = RideService();
  final RideActionService _rideActionService = RideActionService();

  ApiResponse<List<RideModel>> _myRides = ApiResponse.loading();
  ApiResponse<List<RideModel>> _bookedRides = ApiResponse.loading();
  ApiResponse<RideModel> _rideDetails = ApiResponse.loading();
  String? _error;

  ApiResponse<List<RideModel>> get myRides => _myRides;
  ApiResponse<List<RideModel>> get bookedRides => _bookedRides;
  ApiResponse<RideModel> get rideDetailsResponse => _rideDetails;
  String? get error => _error;

  Future<void> fetchMyRides() async {
    print("RidesProvider: fetchMyRides() triggered");
    _myRides = ApiResponse.loading();
    notifyListeners();
    _myRides = await _rideService.getMyRides();
    notifyListeners();
  }

  Future<void> fetchBookedRides() async {
    print("RidesProvider: fetchBookedRides() triggered");
    _bookedRides = ApiResponse.loading();
    notifyListeners();
    _bookedRides = await _rideService.getMyBookedRides();
    notifyListeners();
  }

  Future<void> fetchRideDetails(String id) async {
    print("RidesProvider: fetchRideDetails($id) triggered");
    _rideDetails = ApiResponse.loading();
    notifyListeners();
    _rideDetails = await _rideService.getRideDetails(id);
    notifyListeners();
  }

  Future<bool> bookRide(String rideId) async {
    _error = null;
    final response = await _rideActionService.bookRide(rideId);
    if (response.status == Status.COMPLETED) {
      fetchBookedRides();
      fetchRideDetails(rideId);
      return true;
    } else {
      _error = response.message;
      return false;
    }
  }

  Future<bool> acceptRequest(String requestId) async {
    _error = null;
    final response = await _rideActionService.acceptRideRequest(requestId);
    if (response.status == Status.COMPLETED) {
      return true;
    } else {
      _error = response.message;
      return false;
    }
  }

  Future<bool> cancelRide(String rideId) async {
    _error = null;
    final response = await _rideActionService.cancelRide(rideId);
    if (response.status == Status.COMPLETED) {
      fetchMyRides();
      return true;
    } else {
      _error = response.message;
      return false;
    }
  }
}
