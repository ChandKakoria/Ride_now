import 'package:flutter/material.dart';
import 'package:ride_now/core/api_response.dart';
import 'package:ride_now/core/models/vehicle_model.dart';
import 'package:ride_now/services/vehicle_service.dart';

class VehicleProvider with ChangeNotifier {
  final VehicleService _vehicleService = VehicleService();

  ApiResponse<List<VehicleModel>> _vehicles = ApiResponse.loading();
  ApiResponse<List<VehicleModel>> get vehicles => _vehicles;

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
      "vehicle_name": name,
      "vehicle_model": model,
      "vehicle_color": color,
    });

    if (res.status == Status.COMPLETED) {
      await fetchVehicles(); // Refresh list
    }
    return res;
  }
}
