import 'dart:ui';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFF0F4F8,
      ), // Soft background for glass effect
      body: Stack(
        children: [
          // Background Gradient Blobs (to make glass effect visible)
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF00A3E0).withOpacity(0.2),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00A3E0).withOpacity(0.2),
                    blurRadius: 100,
                    spreadRadius: 50,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 200,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.purple.withOpacity(0.1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.1),
                    blurRadius: 80,
                    spreadRadius: 40,
                  ),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Top Tabs
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
                        // Profile Header
                        _buildProfileHeader(),
                        const SizedBox(height: 24),

                        // Glass Progress Card
                        _buildProgressGlassCard(),
                        const SizedBox(height: 24),

                        // Action Links
                        _buildActionLink("Edit profile picture"),
                        _buildActionLink("Edit personal details"),
                        const SizedBox(height: 32),

                        // Verify Section
                        const Text(
                          "Verify your profile",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF003B4D),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildVerifyItem(
                          icon: Icons.add_circle_outline,
                          text: "Verify your Govt. ID",
                          action: true,
                        ),
                        _buildVerifyItem(
                          icon: Icons.add_circle_outline,
                          text: "Confirm email",
                          subtext: "chandk2228@gmail.com",
                          action: true,
                        ),
                        _buildVerifyItem(
                          icon: Icons.check_circle,
                          iconColor: const Color(0xFF00A3E0),
                          text: "+917496822289",
                        ),
                        const SizedBox(height: 100), // Space for bottom bar
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopTabs() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black12, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildTabItem("About you", true),
          _buildTabItem("Account", false),
        ],
      ),
    );
  }

  Widget _buildTabItem(String text, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: isActive
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
          color: isActive ? const Color(0xFF003B4D) : Colors.grey,
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      children: [
        // Avatar
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
            image: const DecorationImage(
              image: NetworkImage(
                "https://i.pravatar.cc/300?img=11",
              ), // Placeholder
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 16),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Rakesh",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF003B4D),
                ),
              ),
              Text(
                "Newcomer",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Icon(Icons.chevron_right, color: Colors.grey[400], size: 30),
      ],
    );
  }

  Widget _buildProgressGlassCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.6), // Frosted glass color
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.4)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00A3E0).withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Complete your profile",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF003B4D),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "This helps builds trust, encouraging members to travel with you.",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "2 out of 6 complete",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF003B4D),
                ),
              ),
              const SizedBox(height: 12),
              // Segmented Progress Bar
              Row(
                children: List.generate(6, (index) {
                  bool isCompleted = index < 2;
                  return Expanded(
                    child: Container(
                      height: 6,
                      margin: const EdgeInsets.only(right: 4),
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? const Color(0xFF00A3E0)
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
              const Text(
                "Confirm your email address",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00A3E0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionLink(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
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

  Widget _buildVerifyItem({
    required IconData icon,
    required String text,
    String? subtext,
    Color? iconColor,
    bool action = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor ?? const Color(0xFF00A3E0), size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
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
                      color: action
                          ? const Color(0xFF00A3E0)
                          : Colors.grey[600],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
