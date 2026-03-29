import 'package:flutter/material.dart';
import 'package:sakhi_yatra/presentation/rides/widgets/cancel_ride_explanation_sheet.dart';

class CancelRideReasonBottomSheet extends StatelessWidget {
  final String rideId;
  const CancelRideReasonBottomSheet({super.key, required this.rideId});

  final List<String> reasons = const [
    "The car owner changed the date/schedule",
    "I found another ride",
    "The car owner asked me to cancel",
    "The date is no longer suitable",
    "I made a mistake",
    "I found another means of transportation",
    "The car owner is no longer offering the ride",
    "The car owner is unreachable",
    "The driver changed the pick-up point",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context),
          Divider(height: 1, color: Theme.of(context).dividerColor),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: reasons.length,
              separatorBuilder: (c, i) => Divider(
                height: 1,
                color: Theme.of(context).dividerColor,
                indent: 16,
                endIndent: 16,
              ),
              itemBuilder: (c, i) => ListTile(
                title: Text(
                  reasons[i],
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Theme.of(context).disabledColor,
                ),
                onTap: () {
                  Navigator.pop(context);
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder: (c) =>
                        CancelRideExplanationSheet(reason: reasons[i], rideId: rideId),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) => Padding(
    padding: const EdgeInsets.all(16),
    child: Row(
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        Expanded(
          child: Text(
            "What's the reason?",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ],
    ),
  );
}
