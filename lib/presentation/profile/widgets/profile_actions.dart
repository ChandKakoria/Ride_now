import 'package:flutter/material.dart';
import 'package:ride_now/core/models/user_model.dart';
import 'package:ride_now/services/local_storage_service.dart';

class ProfileVerifySection extends StatelessWidget {
  final UserModel? user;
  const ProfileVerifySection({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildItem(
          icon: Icons.add_circle_outline,
          text: "Verify your Govt. ID",
          action: true,
        ),
        _buildItem(
          icon: Icons.add_circle_outline,
          text: "Confirm email",
          subtext: user?.email ?? "Not provided",
          action: true,
        ),
        _buildItem(
          icon: Icons.check_circle,
          text: user?.phoneNumber ?? "Not provided",
          iconColor: const Color(0xFF00A3E0),
        ),
      ],
    );
  }

  Widget _buildItem({
    required IconData icon,
    required String text,
    String? subtext,
    Color? iconColor,
    bool action = false,
  }) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Row(
      children: [
        Icon(icon, color: iconColor ?? const Color(0xFF00A3E0), size: 24),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: action
                    ? const Color(0xFF00A3E0)
                    : const Color(0xFF003B4D),
              ),
            ),
            if (subtext != null)
              Text(
                subtext,
                style: TextStyle(
                  fontSize: 14,
                  color: action ? const Color(0xFF00A3E0) : Colors.grey[600],
                ),
              ),
          ],
        ),
      ],
    ),
  );
}

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
        onPressed: () => _showLogoutDialog(context),
        icon: const Icon(Icons.logout, color: Colors.red),
        label: const Text(
          "Logout",
          style: TextStyle(
            color: Colors.red,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.red.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(c, true),
            child: const Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await LocalStorageService.clearAll();
      if (context.mounted)
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }
}
