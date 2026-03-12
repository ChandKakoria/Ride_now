import 'package:flutter/material.dart';
import 'package:sakhi_yatra/core/models/ride_model.dart';
import 'package:sakhi_yatra/presentation/widgets/common_app_bar.dart';
import 'package:sakhi_yatra/presentation/widgets/shared_gradient_background.dart';
import 'package:url_launcher/url_launcher.dart';

class DriverDetailsScreen extends StatelessWidget {
  final RideModel ride;

  const DriverDetailsScreen({super.key, required this.ride});

  Future<void> _makeCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      // Handle error if dialer cannot be opened
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: const CommonAppBar(title: Text("Driver Details")),
      body: SharedGradientBackground(
        child: Column(
          children: [
            const SizedBox(height: 24),
            const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFFE0F7FA),
              child: Icon(Icons.person, color: Colors.grey, size: 60),
            ),
            const SizedBox(height: 16),
            Text(
              ride.createdByName ?? "Jane Smith",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF003B4D),
              ),
            ),
            const SizedBox(height: 8),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star, color: Colors.amber, size: 20),
                SizedBox(width: 4),
                Text(
                  "4.8 (124 ratings)",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildInfoCard(
              context,
              icon: Icons.email_outlined,
              label: "Email",
              value: ride.createdByEmail ?? "chand@example.com",
            ),
            _buildInfoCard(
              context,
              icon: Icons.phone_outlined,
              label: "Phone",
              value: ride.createdByPhone ?? "8222022278",
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (ride.createdByPhone != null) {
                      _makeCall(ride.createdByPhone!);
                    } else {
                      _makeCall("8222022278"); // Fallback mock
                    }
                  },
                  icon: const Icon(Icons.call, color: Colors.white),
                  label: const Text(
                    "Call Driver",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00A3E0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(16),
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
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF00A3E0).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF00A3E0), size: 24),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF003B4D),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
