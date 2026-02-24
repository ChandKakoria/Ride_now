import 'package:flutter/material.dart';
import 'package:ride_now/services/ride_service.dart';
import 'package:ride_now/core/api_response.dart';

class RideSearchProvider extends ChangeNotifier {
  final RideService _rideService = RideService();

  String? _source;
  String? _destination;
  DateTime _selectedDate = DateTime.now();
  int _passengerCount = 1;

  List<dynamic> _searchResults = [];
  bool _isLoading = false;
  String? _errorMessage;

  String? get source => _source;
  String? get destination => _destination;
  DateTime get selectedDate => _selectedDate;
  int get passengerCount => _passengerCount;

  List<dynamic> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void updateSource(String value) {
    _source = value;
    notifyListeners();
  }

  void updateDestination(String value) {
    _destination = value;
    notifyListeners();
  }

  void updateDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void updatePassengerCount(int count) {
    _passengerCount = count;
    notifyListeners();
  }

  void swapLocations() {
    final temp = _source;
    _source = _destination;
    _destination = temp;
    notifyListeners();
  }

  Future<void> searchRides() async {
    if (_source == null || _destination == null) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await _rideService.searchRides(
      pickup: _source!,
      dropoff: _destination!,
    );

    _isLoading = false;

    if (response.status == Status.COMPLETED) {
      _searchResults = response.data?['rides'] ?? [];
    } else {
      _errorMessage = response.message;
      _searchResults = [];
    }

    notifyListeners();
  }
}
