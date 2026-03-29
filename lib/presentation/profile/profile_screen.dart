import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:sakhi_yatra/core/api_response.dart';
import 'package:sakhi_yatra/providers/user_provider.dart';
import 'package:sakhi_yatra/providers/theme_provider.dart';
import 'package:sakhi_yatra/providers/vehicle_provider.dart';
import 'package:sakhi_yatra/presentation/profile/widgets/profile_header.dart';
import 'package:sakhi_yatra/presentation/profile/widgets/profile_actions.dart';
import 'package:sakhi_yatra/presentation/profile/change_password_screen.dart';
import 'package:sakhi_yatra/presentation/profile/edit_profile_screen.dart';
import 'package:sakhi_yatra/presentation/profile/brand_selection_screen.dart';
import 'package:sakhi_yatra/presentation/profile/help_support_screen.dart';
import 'package:sakhi_yatra/presentation/widgets/common_app_bar.dart';
import 'package:sakhi_yatra/core/api_constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().fetchProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: Text("Profile")),
      body: Consumer<UserProvider>(
        builder: (context, provider, _) {
          final res = provider.profile;
          if (res.status == Status.LOADING) {
            return const Center(child: CircularProgressIndicator());
          }
          final user = res.data;
          return Stack(
            children: [
              _buildBackgroundBlobs(),
              Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProfileHeader(
                            firstName: user?.firstName ?? "User",
                            lastName: user?.lastName ?? "",
                            vehicle: user?.vehicle,
                          ),
                          const SizedBox(height: 24),
                          const SizedBox(height: 24),
                          Card(
                            margin: EdgeInsets.zero,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Column(
                                children: [
                                  _buildActionItem(
                                    icon: Icons.person_outline,
                                    text: "Edit personal details",
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (c) =>
                                              const EditProfileScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                  _buildActionItem(
                                    icon: Icons.directions_car_filled_outlined,
                                    text: "My Vehicles",
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (c) =>
                                              const BrandSelectionScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                  if (user?.vehicle != null)
                                    _buildActionItem(
                                      icon: Icons.no_crash_outlined,
                                      text: "Remove Vehicle",
                                      onTap: () =>
                                          _showRemoveVehicleDialog(context),
                                      textColor: Colors.red,
                                      iconColor: Colors.red,
                                    ),
                                  _buildActionItem(
                                    icon: Icons.lock_outline,
                                    text: "Change Password",
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (c) =>
                                              const ChangePasswordScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          Text(
                            "Verify your profile",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Card(
                            margin: EdgeInsets.zero,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: ProfileVerifySection(user: user),
                            ),
                          ),
                          const SizedBox(height: 32),
                          Text(
                            "More",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Card(
                            margin: EdgeInsets.zero,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Column(
                                children: [
                                  _buildActionItem(
                                    icon: Icons.description,
                                    text: "Terms & Conditions",
                                    onTap: () => launchUrl(
                                      Uri.parse(ApiConstants.terms),
                                      mode: LaunchMode.externalApplication,
                                    ),
                                  ),
                                  _buildActionItem(
                                    icon: Icons.privacy_tip,
                                    text: "Privacy Policy",
                                    onTap: () => launchUrl(
                                      Uri.parse(ApiConstants.privacy),
                                      mode: LaunchMode.externalApplication,
                                    ),
                                  ),
                                  _buildActionItem(
                                    icon: Icons.help_outline,
                                    text: "Help & Support",
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (c) =>
                                              const HelpSupportScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                  Consumer<ThemeProvider>(
                                    builder: (context, themeProvider, _) {
                                      return _buildActionItem(
                                        icon: themeProvider.isDarkMode
                                            ? Icons.light_mode
                                            : Icons.dark_mode,
                                        text: themeProvider.isDarkMode
                                            ? "Light Mode"
                                            : "Dark Mode",
                                        onTap: () =>
                                            themeProvider.toggleTheme(),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          const LogoutButton(),
                          const SizedBox(height: 16),
                          const DeleteAccountButton(),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBackgroundBlobs() => Stack(
    children: [
      Positioned(
        top: -100,
        right: -100,
        child: Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).primaryColor.withOpacity(0.08),
          ),
        ),
      ),
      Positioned(
        top: 250,
        left: -80,
        child: Container(
          width: 250,
          height: 250,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).primaryColor.withOpacity(0.05),
          ),
        ),
      ),
    ],
  );

  Future<void> _showRemoveVehicleDialog(BuildContext context) async {
    final vehicleProvider = context.read<VehicleProvider>();
    final userProvider = context.read<UserProvider>();

    final confirm = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text("Remove Vehicle"),
        content: const Text("Are you sure you want to remove your vehicle?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(c, true),
            child: const Text("Remove", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      if (!mounted) return;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (c) => const Center(child: CircularProgressIndicator()),
      );

      final res = await vehicleProvider.removeVehicle();

      if (!mounted) return;
      Navigator.pop(context); // Pop loading

      if (res.status == Status.COMPLETED) {
        await userProvider.fetchProfile();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Vehicle removed successfully")),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(res.message ?? "Failed to remove vehicle")),
          );
        }
      }
    }
  }

  Widget _buildActionItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color? textColor,
    Color? iconColor,
  }) => ListTile(
    onTap: onTap,
    leading: Icon(
      icon,
      color: iconColor ?? Theme.of(context).colorScheme.onSurface,
    ),
    title: Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textColor ?? Theme.of(context).colorScheme.onSurface,
      ),
    ),
    trailing: const Icon(Icons.chevron_right, color: Colors.grey),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
  );
}
