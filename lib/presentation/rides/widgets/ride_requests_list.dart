import 'package:flutter/material.dart';
import 'package:sakhi_yatra/core/models/ride_request_model.dart';
import 'package:sakhi_yatra/core/app_strings.dart';

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
    return ListView.separated(
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
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : null,
            child: Icon(
              Icons.person,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black
                  : Theme.of(context).primaryColor,
            ),
          ),
          title: Text(
            r.requesterName ?? "Unknown",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          subtitle: _buildSubtitle(context, r, s),
          trailing: s == 'pending'
              ? _buildAcceptButton(context, r)
              : const Icon(Icons.check_circle, color: Colors.green),
        );
      },
    );
  }

  Widget _buildSubtitle(BuildContext context, RideRequestModel r, String s) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (r.requesterPhone != null)
            Text(
              "Phone: ${r.requesterPhone}",
              style: TextStyle(
                color: Theme.of(context).disabledColor,
                fontSize: 13,
              ),
            ),
          if (r.requesterEmail != null)
            Text(
              "Email: ${r.requesterEmail}",
              style: TextStyle(
                color: Theme.of(context).disabledColor,
                fontSize: 13,
              ),
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

  Widget _buildAcceptButton(BuildContext context, RideRequestModel r) =>
      ElevatedButton(
        onPressed: isLoading ? null : () => onAccept(r.id),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Text(AppStrings.labelAccept),
      );
}
