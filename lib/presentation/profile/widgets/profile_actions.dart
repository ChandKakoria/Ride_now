import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sakhi_yatra/core/api_response.dart';
import 'package:sakhi_yatra/core/models/user_model.dart';
import 'package:sakhi_yatra/services/local_storage_service.dart';
import 'package:sakhi_yatra/providers/user_provider.dart';

class ProfileVerifySection extends StatelessWidget {
  final UserModel? user;
  const ProfileVerifySection({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildItem(
          context: context,
          icon: Icons.email_outlined,
          text: user?.email ?? "Not provided",
          iconColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Theme.of(context).primaryColor,
        ),
        _buildItem(
          context: context,
          icon: Icons.check_circle,
          text: user?.phoneNumber ?? "Not provided",
          iconColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Theme.of(context).primaryColor,
        ),
      ],
    );
  }

  Widget _buildItem({
    required BuildContext context,
    required IconData icon,
    required String text,
    String? subtext,
    Color? iconColor,
    bool action = false,
  }) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Row(
      children: [
        Icon(
          icon,
          color: iconColor ?? Theme.of(context).primaryColor,
          size: 24,
        ),
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
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
            if (subtext != null)
              Text(
                subtext,
                style: TextStyle(
                  fontSize: 14,
                  color: action
                      ? Theme.of(context).primaryColor
                      : Colors.grey[600],
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
      child: ElevatedButton.icon(
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
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          elevation: 4,
          padding: const EdgeInsets.symmetric(vertical: 16),
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

class DeleteAccountButton extends StatefulWidget {
  const DeleteAccountButton({super.key});

  @override
  State<DeleteAccountButton> createState() => _DeleteAccountButtonState();
}

class _DeleteAccountButtonState extends State<DeleteAccountButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _isLoading ? null : () => _showDeleteDialog(context),
        icon: _isLoading
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
            : const Icon(Icons.delete_forever, color: Colors.white),
        label: Text(
          _isLoading ? "Deleting..." : "Delete Account",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          elevation: 4,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Future<void> _showDeleteDialog(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text("Delete Account"),
        content: const Text("Are you sure you want to permanently delete your account? This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(c, true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      setState(() => _isLoading = true);
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final response = await userProvider.deleteAccount();

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (response.status == Status.COMPLETED) {
        await LocalStorageService.clearAll();
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message ?? "Failed to delete account")),
        );
      }
    }
  }
}
