import 'package:flutter/material.dart';

class CancelRideReasonBottomSheet extends StatelessWidget {
  const CancelRideReasonBottomSheet({super.key});

  final List<String> reasons = const [
    "The car owner changed the date/schedule",
    "I found another ride",
    "The car owner asked me to cancel",
    "The date is no longer suitable",
    "I made a mistake and shouldn't have booked",
    "I found another means of transportation",
    "The car owner is no longer offering the ride",
    "The car owner is unreachable",
    "The driver changed the pick-up point",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF00A3E0)),
                  onPressed: () => Navigator.pop(context),
                ),
                const Expanded(
                  child: Text(
                    "What's the reason?",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF003B4D),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey[200]),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: reasons.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: Colors.grey[200],
                indent: 16,
                endIndent: 16,
              ),
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    reasons[index],
                    style: const TextStyle(
                      color: Color(0xFF003B4D),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
                  onTap: () {
                    Navigator.pop(context); // Close reason sheet
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (context) => CancelRideExplanationBottomSheet(
                        reason: reasons[index],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class CancelRideExplanationBottomSheet extends StatefulWidget {
  final String reason;

  const CancelRideExplanationBottomSheet({super.key, required this.reason});

  @override
  State<CancelRideExplanationBottomSheet> createState() =>
      _CancelRideExplanationBottomSheetState();
}

class _CancelRideExplanationBottomSheetState
    extends State<CancelRideExplanationBottomSheet> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check for keyboard visibility to adjust padding if needed,
    // but usually padding bottom inset is enough.
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF00A3E0)),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 16),
                const Text(
                  "Can you explain more?",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF003B4D),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "Reason: ${widget.reason}",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _controller,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Tell us more details...",
                hintStyle: TextStyle(color: Colors.grey[400]),
                filled: true,
                fillColor: const Color(0xFFF5F7FA),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // Handle cancellation submission here
                  Navigator.pop(context); // Close sheet
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Ride cancelled successfully"),
                      backgroundColor: Color(0xFF00A3E0),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00A3E0),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: const Text(
                  "Confirm Cancellation",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
