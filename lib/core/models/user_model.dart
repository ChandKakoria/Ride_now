class UserModel {
  final String id;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? dob;
  final String? gender;

  UserModel({
    required this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.dob,
    this.gender,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? json['id'] ?? '',
      email: json['email'],
      firstName: json['first_name'] ?? json['name']?.split(' ').first,
      lastName:
          json['last_name'] ??
          (json['name']?.split(' ').length > 1
              ? json['name']?.split(' ').last
              : null),
      phoneNumber: json['phone_number'] ?? json['phone'],
      dob: json['dob'],
      gender: json['gender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'dob': dob,
      'gender': gender,
    };
  }

  String get fullName => "$firstName ${lastName ?? ''}".trim();
}
