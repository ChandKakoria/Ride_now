import 'package:flutter/material.dart';
import 'package:ride_now/core/api_response.dart';
import 'package:ride_now/core/models/user_model.dart';
import 'package:ride_now/services/user_service.dart';

class UserProvider extends ChangeNotifier {
  final UserService _userService = UserService();
  ApiResponse<UserModel> _profile = ApiResponse.loading();

  ApiResponse<UserModel> get profile => _profile;

  Future<void> fetchProfile() async {
    print("UserProvider: fetchProfile() triggered");
    _profile = ApiResponse.loading();
    notifyListeners();
    _profile = await _userService.getProfile();
    notifyListeners();
  }

  void clearProfile() {
    _profile = ApiResponse.loading();
    notifyListeners();
  }
}
