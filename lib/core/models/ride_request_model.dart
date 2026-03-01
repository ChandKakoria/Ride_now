class RideRequestModel {
  final String id;
  final String? createdAt;
  final RequesterDetails? requesterDetails;
  final String? requesterEmail;
  final String? requesterId;
  final String? requesterName;
  final String? requesterPhone;
  final String? rideId;
  final String? status;
  final String? updatedAt;

  RideRequestModel({
    required this.id,
    this.createdAt,
    this.requesterDetails,
    this.requesterEmail,
    this.requesterId,
    this.requesterName,
    this.requesterPhone,
    this.rideId,
    this.status,
    this.updatedAt,
  });

  factory RideRequestModel.fromJson(Map<String, dynamic> json) {
    return RideRequestModel(
      id: json['_id'] ?? json['id'] ?? '',
      createdAt: json['created_at'],
      requesterDetails: json['requester_details'] != null
          ? RequesterDetails.fromJson(json['requester_details'])
          : null,
      requesterEmail: json['requester_email'],
      requesterId: json['requester_id'],
      requesterName: json['requester_name'],
      requesterPhone: json['requester_phone'],
      rideId: json['ride_id'],
      status: json['status'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'created_at': createdAt,
      'requester_details': requesterDetails?.toJson(),
      'requester_email': requesterEmail,
      'requester_id': requesterId,
      'requester_name': requesterName,
      'requester_phone': requesterPhone,
      'ride_id': rideId,
      'status': status,
      'updated_at': updatedAt,
    };
  }
}

class RequesterDetails {
  final String? dob;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;

  RequesterDetails({
    this.dob,
    this.email,
    this.firstName,
    this.lastName,
    this.phoneNumber,
  });

  factory RequesterDetails.fromJson(Map<String, dynamic> json) {
    return RequesterDetails(
      dob: json['dob'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      phoneNumber: json['phone_number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dob': dob,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
    };
  }
}
