import 'package:sakhi_yatra/core/models/ride_request_model.dart';
import 'package:sakhi_yatra/core/models/booking_model.dart';
import 'package:sakhi_yatra/core/models/vehicle_model.dart';

class RideModel {
  final String id;
  final String? createdAt;
  final String? createdByEmail;
  final String? createdByName;
  final String? createdByPhone;
  final String? dropoffAddress;
  final String? dropoffLocation;
  final String? dropoffTime;
  final bool? isFull;
  final int? passengerCount;
  final String? pickupAddress;
  final String? pickupLocation;
  final String? pickupTime;
  final double? price;
  final List<RideRequestModel> requests;
  final List<BookingModel> bookedUsers;
  final String? status;
  final String? updatedAt;
  final String? userId;
  final int? availableSeats;
  final int? bookedSeats;
  final VehicleModel? vehicle;

  RideModel({
    required this.id,
    this.createdAt,
    this.createdByEmail,
    this.createdByName,
    this.createdByPhone,
    this.dropoffAddress,
    this.dropoffLocation,
    this.dropoffTime,
    this.isFull,
    this.passengerCount,
    this.pickupAddress,
    this.pickupLocation,
    this.pickupTime,
    this.price,
    this.requests = const [],
    this.bookedUsers = const [],
    this.status,
    this.updatedAt,
    this.userId,
    this.availableSeats,
    this.bookedSeats,
    this.vehicle,
  });

  factory RideModel.fromJson(Map<String, dynamic> json) {
    return RideModel(
      id: json['_id'] ?? json['id'] ?? '',
      createdAt: json['created_at'],
      createdByEmail: json['created_by_email'],
      createdByName: json['created_by_name'] ?? json['created_by'],
      createdByPhone: json['created_by_phone'],
      dropoffAddress: json['dropoff_address'],
      dropoffLocation:
          json['dropoff_location_name'] ?? json['dropoff_location'],
      dropoffTime: json['dropoff_time'],
      isFull: json['is_full'],
      passengerCount: json['passenger_count'],
      pickupAddress: json['pickup_address'],
      pickupLocation: json['pickup_location_name'] ?? json['pickup_location'],
      pickupTime: json['pickup_time'],
      price: (json['price'] as num?)?.toDouble(),
      requests:
          (json['requests'] as List?)
              ?.map((e) => RideRequestModel.fromJson(e))
              .toList() ??
          [],
      bookedUsers:
          (json['booked_users'] as List?)
              ?.map((e) => BookingModel.fromJson(e))
              .toList() ??
          [],
      status: json['status'],
      updatedAt: json['updated_at'],
      userId: json['user_id'],
      availableSeats: json['available_seats'],
      bookedSeats: json['booked_seats'],
      vehicle: json['vehicle'] != null
          ? VehicleModel.fromJson(json['vehicle'])
          : json['driver_vehicle'] != null
          ? VehicleModel.fromJson(json['driver_vehicle'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'created_at': createdAt,
      'created_by_email': createdByEmail,
      'created_by_name': createdByName,
      'created_by_phone': createdByPhone,
      'dropoff_address': dropoffAddress,
      'dropoff_location': dropoffLocation,
      'dropoff_time': dropoffTime,
      'is_full': isFull,
      'passenger_count': passengerCount,
      'pickup_address': pickupAddress,
      'pickup_location': pickupLocation,
      'pickup_time': pickupTime,
      'price': price,
      'requests': requests.map((e) => e.toJson()).toList(),
      'booked_users': bookedUsers.map((e) => e.toJson()).toList(),
      'status': status,
      'updated_at': updatedAt,
      'user_id': userId,
      'available_seats': availableSeats,
      'booked_seats': bookedSeats,
    };
  }
}
