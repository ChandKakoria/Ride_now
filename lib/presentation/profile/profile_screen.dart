import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_now/core/api_response.dart';
import 'package:ride_now/providers/user_provider.dart';
import 'package:ride_now/presentation/profile/widgets/profile_header.dart';
import 'package:ride_now/presentation/profile/widgets/completion_progress_card.dart';
import 'package:ride_now/presentation/profile/widgets/profile_actions.dart';

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
      backgroundColor: Colors.transparent,
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
              SafeArea(
                child: Column(
                  children: [
                    _buildTopTabs(),
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
                            ),
                            const SizedBox(height: 24),
                            const CompletionProgressCard(),
                            const SizedBox(height: 24),
                            _buildActionLink("Edit profile picture"),
                            _buildActionLink("Edit personal details"),
                            const SizedBox(height: 32),
                            const Text(
                              "Verify your profile",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF003B4D),
                              ),
                            ),
                            const SizedBox(height: 16),
                            ProfileVerifySection(user: user),
                            const SizedBox(height: 32),
                            const LogoutButton(),
                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
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
            color: const Color(0xFF00A3E0).withOpacity(0.08),
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
            color: const Color(0xFF00A3E0).withOpacity(0.05),
          ),
        ),
      ),
    ],
  );

  Widget _buildTopTabs() => Container(
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: Colors.black12)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildTabItem("About you", true),
        _buildTabItem("Account", false),
      ],
    ),
  );

  Widget _buildTabItem(String text, bool active) => Container(
    padding: const EdgeInsets.symmetric(vertical: 16),
    decoration: active
        ? const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Color(0xFF003B4D), width: 2),
            ),
          )
        : null,
    child: Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: active ? const Color(0xFF003B4D) : Colors.grey,
      ),
    ),
  );

  Widget _buildActionLink(String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Color(0xFF00A3E0),
      ),
    ),
  );
}
