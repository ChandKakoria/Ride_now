import 'package:hive_flutter/hive_flutter.dart';

class LocalStorageService {
  static const String _boxName = 'auth_box';
  static const String _tokenKey = 'access_token';
  static const String _userIdKey = 'user_id';
  static const String _emailKey = 'user_email';
  static const String _firstNameKey = 'first_name';
  static const String _lastNameKey = 'last_name';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_boxName);
  }

  static Box get _box => Hive.box(_boxName);

  static Future<void> saveToken(String token) async {
    await _box.put(_tokenKey, token);
  }

  static String? getToken() {
    return _box.get(_tokenKey);
  }

  static Future<void> saveUserId(String userId) async {
    await _box.put(_userIdKey, userId);
  }

  static String? getUserId() {
    return _box.get(_userIdKey);
  }

  static Future<void> saveUserData({
    required String email,
    required String firstName,
    required String lastName,
  }) async {
    await _box.put(_emailKey, email);
    await _box.put(_firstNameKey, firstName);
    await _box.put(_lastNameKey, lastName);
  }

  static String? getEmail() => _box.get(_emailKey);
  static String? getFirstName() => _box.get(_firstNameKey);
  static String? getLastName() => _box.get(_lastNameKey);

  static Future<void> clearAll() async {
    await _box.clear();
  }
}
