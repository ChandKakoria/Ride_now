import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ride_bridge_car/core/models/chat_model.dart';
import 'package:ride_bridge_car/core/models/user_model.dart';
import 'package:ride_bridge_car/presentation/inbox/chat_screen.dart';
import 'package:ride_bridge_car/presentation/widgets/common_app_bar.dart';
import 'package:ride_bridge_car/providers/user_provider.dart';
import 'package:ride_bridge_car/services/chat_service.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => InboxScreenState();
}

class InboxScreenState extends State<InboxScreen> {
  final ChatService _chatService = ChatService();
  List<ChatUser>? _chatList;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadChatList();
  }

  Future<void> loadChatList() async {
    final list = await _chatService.getChatList();
    if (mounted) {
      setState(() {
        _chatList = list;
        _isLoading = false;
      });

      // Cleanup Firestore only if we have an active user profile
      final userProvider = context.read<UserProvider>();
      final currentUser = userProvider.profile.data;
      if (currentUser != null) {
        _chatService.cleanupStaleChats(list, currentUser.id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final currentUser = userProvider.profile.data;

    return Scaffold(
      appBar: const CommonAppBar(title: Text("Inbox")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _chatList == null || _chatList!.isEmpty
          ? _buildEmptyState()
          : RefreshIndicator(
              onRefresh: loadChatList,
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _chatList!.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final chatUser = _chatList![index];
                  return _buildChatTile(context, chatUser, currentUser);
                },
              ),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.chat_bubble_outline, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            "No messages yet",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Your conversations with drivers and passengers will appear here.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildChatTile(
    BuildContext context,
    ChatUser chatUser,
    UserModel? currentUser,
  ) {
    return InkWell(
      onTap: () {
        if (currentUser != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ChatScreen(chatUser: chatUser, currentUserId: currentUser.id),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: chatUser.gender.toLowerCase() == 'female'
                  ? Colors.pink.shade50
                  : Colors.blue.shade50,
              child: Icon(
                Icons.person,
                color: chatUser.gender.toLowerCase() == 'female'
                    ? Colors.pink
                    : Colors.blue,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        chatUser.fullName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(
                            chatUser.rideStatus,
                          ).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          chatUser.rideStatus,
                          style: TextStyle(
                            fontSize: 12,
                            color: _getStatusColor(chatUser.rideStatus),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    chatUser.role == 'driver' ? 'Driver' : 'Passenger',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                ],
              ),
            ),
            _buildUnreadBadge(chatUser, currentUser?.id),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildUnreadBadge(ChatUser chatUser, String? currentUserId) {
    if (currentUserId == null) return const SizedBox.shrink();

    final chatDocId = _chatService.getChatDocId(currentUserId, chatUser.userId);

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .doc(chatDocId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const SizedBox.shrink();
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        final count = data['unreadCount_$currentUserId'] ?? 0;

        if (count == 0) return const SizedBox.shrink();

        return Container(
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.all(6),
          decoration: const BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
          child: Text(
            "$count",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'booked':
        return Colors.green;
      case 'requested':
        return Colors.orange;
      case 'completed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
