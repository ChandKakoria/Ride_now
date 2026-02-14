import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CreateRideProvider extends ChangeNotifier {
  String? _dropOffLocation;
  LatLng? _dropOffCoordinates;
  String? _dropOffPlaceId;

  String? get dropOffLocation => _dropOffLocation;
  LatLng? get dropOffCoordinates => _dropOffCoordinates;
  String? get dropOffPlaceId => _dropOffPlaceId;

  String? _pickupLocation;
  LatLng? _pickupCoordinates;
  String? _pickupPlaceId;

  String? get pickupLocation => _pickupLocation;
  LatLng? get pickupCoordinates => _pickupCoordinates;
  String? get pickupPlaceId => _pickupPlaceId;

  void updateDropOffLocation(
    String address,
    LatLng? coordinates,
    String? placeId,
  ) {
    _dropOffLocation = address;
    _dropOffCoordinates = coordinates;
    _dropOffPlaceId = placeId;
    notifyListeners();
  }

  void updatePickupLocation(
    String address,
    LatLng? coordinates,
    String? placeId,
  ) {
    _pickupLocation = address;
    _pickupCoordinates = coordinates;
    _pickupPlaceId = placeId;
    notifyListeners();
  }

  String? _tripDuration;
  String? _tripDistance;
  List<LatLng> _polylinePoints = [];

  String? get tripDuration => _tripDuration;
  String? get tripDistance => _tripDistance;
  List<LatLng> get polylinePoints => _polylinePoints;

  void updateRouteDetails(
    String duration,
    String distance,
    List<LatLng> points,
  ) {
    _tripDuration = duration;
    _tripDistance = distance;
    _polylinePoints = points;
    notifyListeners();
  }

  // Ride Scheduling Details
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int _passengerCount = 1;
  double _pricePerSeat = 0.0;

  DateTime? get selectedDate => _selectedDate;
  TimeOfDay? get selectedTime => _selectedTime;
  int get passengerCount => _passengerCount;
  double get pricePerSeat => _pricePerSeat;

  void updateDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void updateTime(TimeOfDay time) {
    _selectedTime = time;
    notifyListeners();
  }

  void updatePassengerCount(int count) {
    _passengerCount = count;
    notifyListeners();
  }

  void updatePricePerSeat(double price) {
    _pricePerSeat = price;
    notifyListeners();
  }
}
