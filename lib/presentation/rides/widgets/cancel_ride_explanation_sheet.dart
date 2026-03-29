import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sakhi_yatra/providers/rides_provider.dart';

class CancelRideExplanationSheet extends StatefulWidget {
  final String reason;
  final String rideId;
  const CancelRideExplanationSheet({
    super.key,
    required this.reason,
    required this.rideId,
  });
  @override
  State<CancelRideExplanationSheet> createState() =>
      _CancelRideExplanationSheetState();
}

class _CancelRideExplanationSheetState
    extends State<CancelRideExplanationSheet> {
  final _controller = TextEditingController();
  bool _isCancelling = false;
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 16),
                Text(
                  "Can you explain more?",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "Reason: ${widget.reason}",
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).disabledColor,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _controller,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Tell us more details...",
                filled: true,
                fillColor: Theme.of(context).disabledColor.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 24),
            _buildConfirmButton(context),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmButton(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 56,
    child: ElevatedButton(
      onPressed: _isCancelling ? null : () async {
        setState(() => _isCancelling = true);
        final provider = context.read<RidesProvider>();
        final success = await provider.cancelRide(widget.rideId);
        if (mounted) {
          setState(() => _isCancelling = false);
          if (success) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Ride cancelled successfully")),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(provider.error ?? "Failed to cancel ride")),
            );
          }
        }
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
      child: _isCancelling
          ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Text(
              "Confirm Cancellation",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
    ),
  );
}
