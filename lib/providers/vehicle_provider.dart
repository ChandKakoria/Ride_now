import 'package:flutter/material.dart';
import 'package:sakhi_yatra/core/api_response.dart';
import 'package:sakhi_yatra/core/models/vehicle_model.dart';
import 'package:sakhi_yatra/core/models/vehicle_selection_model.dart';
import 'package:sakhi_yatra/services/vehicle_service.dart';

class VehicleProvider with ChangeNotifier {
  final VehicleService _vehicleService = VehicleService();

  ApiResponse<List<VehicleModel>> _vehicles = ApiResponse.loading();
  ApiResponse<List<VehicleModel>> get vehicles => _vehicles;

  ApiResponse<VehicleSelectionData> _availableVehicles = ApiResponse.loading();
  ApiResponse<VehicleSelectionData> get availableVehicles => _availableVehicles;

  Future<void> fetchAvailableVehicles() async {
    _availableVehicles = ApiResponse.loading();
    notifyListeners();

    try {
      final res = await _vehicleService.getAvailableVehicles();
      _availableVehicles = res;
    } catch (e) {
      _availableVehicles = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  Future<void> fetchVehicles() async {
    _vehicles = ApiResponse.loading();
    notifyListeners();

    try {
      final res = await _vehicleService.getVehicles();
      _vehicles = res;
    } catch (e) {
      _vehicles = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  Future<ApiResponse<dynamic>> addVehicle({
    required String name,
    required String model,
    required String color,
  }) async {
    final res = await _vehicleService.addVehicle({
      "brand": name,
      "model": model,
      "color": color,
    });

    if (res.status == Status.COMPLETED) {
      await fetchVehicles(); // Refresh list
    }
    return res;
  }

  Future<ApiResponse<dynamic>> removeVehicle() async {
    final res = await _vehicleService.removeVehicle();

    if (res.status == Status.COMPLETED) {
      await fetchVehicles(); // Refresh list if necessary
    }
    return res;
  }
}
