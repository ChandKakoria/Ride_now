import 'package:flutter/material.dart';

class RideSearchProvider extends ChangeNotifier {
  String? _source;
  String? _destination;
  DateTime _selectedDate = DateTime.now();
  int _passengerCount = 1;

  String? get source => _source;
  String? get destination => _destination;
  DateTime get selectedDate => _selectedDate;
  int get passengerCount => _passengerCount;

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
}
