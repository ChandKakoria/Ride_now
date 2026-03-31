import 'package:cloud_firestore/cloud_firestore.dart';

class ChatUser {
  final String userId;
  final String firstName;
  final String lastName;
  final String gender;
  final String role;
  final String rideId;
  final String requestId;
  final String rideStatus;

  ChatUser({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.role,
    required this.rideId,
    required this.requestId,
    required this.rideStatus,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      userId: json['user_id'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      gender: json['gender'] ?? '',
      role: json['role'] ?? '',
      rideId: json['ride_id'] ?? '',
      requestId: json['request_id'] ?? '',
      rideStatus: json['ride_status'] ?? '',
    );
  }

  String get fullName => "$firstName $lastName".trim();
}

enum MessageStatus { sent, delivered, seen }

class ChatMessage {
  final String id;
  final String senderId;
  final String receiverId;
  final String text;
  final DateTime timestamp;
  final MessageStatus status;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.timestamp,
    required this.status,
  });

  factory ChatMessage.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ChatMessage(
      id: doc.id,
      senderId: data['senderId'] ?? '',
      receiverId: data['receiverId'] ?? '',
      text: data['text'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      status: _parseStatus(data['status']),
    );
  }

  static MessageStatus _parseStatus(String? status) {
    switch (status) {
      case 'delivered':
        return MessageStatus.delivered;
      case 'seen':
        return MessageStatus.seen;
      default:
        return MessageStatus.sent;
    }
  }

  Map<String, dynamic> toFirestore() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'timestamp': Timestamp.fromDate(timestamp),
      'status': status.name,
    };
  }
}
