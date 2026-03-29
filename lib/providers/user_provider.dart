import 'package:flutter/material.dart';
import 'package:sakhi_yatra/core/api_response.dart';
import 'package:sakhi_yatra/core/models/user_model.dart';
import 'package:sakhi_yatra/services/user_service.dart';

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


  Future<ApiResponse<dynamic>> updateProfile({
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String dob,
  }) async {
    final response = await _userService.updateProfile({
      "first_name": firstName,
      "last_name": lastName,
      "phone_number": phoneNumber,
      "dob": dob,
    });

    if (response.status == Status.COMPLETED) {
      if (_profile.data != null) {
        final currentUser = _profile.data!;
        final updatedUser = UserModel(
          id: currentUser.id,
          email: currentUser.email,
          firstName: firstName,
          lastName: lastName,
          phoneNumber: phoneNumber,
          dob: dob,
          gender: currentUser.gender,
        );
        _profile = ApiResponse.completed(updatedUser);
      }
    }
    notifyListeners();
    return response;
  }

  Future<ApiResponse<dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    return await _userService.changePassword(currentPassword, newPassword);
  }

  void clearProfile() {
    _profile = ApiResponse.loading();
    notifyListeners();
  }

  Future<ApiResponse<dynamic>> deleteAccount() async {
    return await _userService.deleteAccount();
  }
}
