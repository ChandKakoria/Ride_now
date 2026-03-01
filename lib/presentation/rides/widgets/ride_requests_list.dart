import 'package:flutter/material.dart';
import 'package:ride_now/core/models/ride_request_model.dart';
import 'package:ride_now/core/app_strings.dart';

class RideRequestsList extends StatelessWidget {
  final List<RideRequestModel> requests;
  final Function(String) onAccept;
  final bool isLoading;

  const RideRequestsList({
    super.key,
    required this.requests,
    required this.onAccept,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (requests.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: Text(
            AppStrings.labelRideRequests,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF003B4D),
            ),
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: requests.length,
          separatorBuilder: (c, i) => const Divider(height: 1),
          itemBuilder: (c, i) {
            final r = requests[i];
            final s = r.status?.toLowerCase() ?? "pending";
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              leading: CircleAvatar(
                backgroundColor: const Color(0xFF00A3E0).withOpacity(0.1),
                child: const Icon(Icons.person, color: Color(0xFF00A3E0)),
              ),
              title: Text(
                r.requesterName ?? "Unknown",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF003B4D),
                ),
              ),
              subtitle: _buildSubtitle(r, s),
              trailing: s == 'pending'
                  ? _buildAcceptButton(r)
                  : const Icon(Icons.check_circle, color: Colors.green),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSubtitle(RideRequestModel r, String s) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (r.requesterPhone != null)
        Text(
          "Phone: ${r.requesterPhone}",
          style: TextStyle(color: Colors.grey[700], fontSize: 13),
        ),
      if (r.requesterEmail != null)
        Text(
          "Email: ${r.requesterEmail}",
          style: TextStyle(color: Colors.grey[700], fontSize: 13),
        ),
      const SizedBox(height: 4),
      Text(
        "Status: ${s.toUpperCase()}",
        style: TextStyle(
          color: s == 'pending' ? Colors.orange : Colors.green,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );

  Widget _buildAcceptButton(RideRequestModel r) => ElevatedButton(
    onPressed: isLoading ? null : () => onAccept(r.id),
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF00A3E0),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    child: const Text(AppStrings.labelAccept),
  );
}
