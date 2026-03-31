import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:sakhi_yatra/core/api_constants.dart';
import 'package:sakhi_yatra/core/models/chat_model.dart';
import 'package:sakhi_yatra/services/local_storage_service.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<ChatUser>> getChatList() async {
    final String url = ApiConstants.chatList;
    final String? token = LocalStorageService.getToken();

    if (token == null) return [];

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List list = data['chat_list'] ?? [];
        return list.map((json) => ChatUser.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      if (kDebugMode) print("Error fetching chat list: $e");
      return [];
    }
  }

  Stream<List<ChatMessage>> getMessages(String chatDocId) {
    return _firestore
        .collection('chats')
        .doc(chatDocId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => ChatMessage.fromFirestore(doc)).toList();
    });
  }

  Future<void> sendMessage(String chatDocId, String text, String senderId, String receiverId) async {
    try {
      final message = ChatMessage(
        id: '',
        senderId: senderId,
        receiverId: receiverId,
        text: text,
        timestamp: DateTime.now(),
        status: MessageStatus.sent,
      );

      // Ensure the chat document exists
      await _firestore.collection('chats').doc(chatDocId).set({
        'lastMessage': text,
        'lastMessageTime': FieldValue.serverTimestamp(),
        'users': [senderId, receiverId],
      }, SetOptions(merge: true));

      await _firestore
          .collection('chats')
          .doc(chatDocId)
          .collection('messages')
          .add(message.toFirestore());

      // Send push notification via backend
      _sendNotification(receiverId, text);
    } catch (e) {
      if (kDebugMode) print("Error in sendMessage: $e");
      rethrow;
    }
  }

  Future<void> _sendNotification(String recipientId, String text) async {
    final String url = ApiConstants.sendChatNotification;
    final String? token = LocalStorageService.getToken();
    if (token == null) return;

    try {
      await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode({
          "recipient_id": recipientId,
          "message_text": text,
        }),
      );
    } catch (e) {
      if (kDebugMode) print("Error sending notification: $e");
    }
  }

  Future<void> updateMessageStatus(String chatDocId, String messageId, MessageStatus status) async {
    await _firestore
        .collection('chats')
        .doc(chatDocId)
        .collection('messages')
        .doc(messageId)
        .update({'status': status.name});
  }

  String getChatDocId(String user1, String user2) {
    List<String> ids = [user1, user2];
    ids.sort();
    return ids.join('_');
  }
}
