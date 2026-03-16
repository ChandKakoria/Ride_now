import 'package:flutter/material.dart';
import 'package:sakhi_yatra/core/utils/map_utils.dart';
import 'package:sakhi_yatra/presentation/publish/widgets/route_option_tile.dart';
import 'package:sakhi_yatra/presentation/publish/ride_time_picker_screen.dart';

class RouteSelectionSheet extends StatelessWidget {
  final ScrollController controller;
  final List<dynamic> routes;
  final int selectedIndex;
  final Function(int) onSelect;

  const RouteSelectionSheet({
    super.key,
    required this.controller,
    required this.routes,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.12),
            blurRadius: 10,
          ),
        ],
      ),
      child: ListView(
        controller: controller,
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            "What is your route?",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 20),
          ...routes.asMap().entries.map(
            (e) => RouteOptionTile(
              index: e.key,
              selectedIndex: selectedIndex,
              duration: MapUtils.formatDuration(e.value['duration']),
              distance: MapUtils.formatDistance(e.value['distanceMeters']),
              via: e.value['description'] ?? "Route ${e.key + 1}",
              onTap: onSelect,
              hasTolls:
                  e.value['routeLabels']?.toString().contains('TOLL') ?? false,
            ),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerRight,
            child: FloatingActionButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (c) => const RideTimePickerScreen()),
              ),
              child: Icon(
                Icons.arrow_forward,
                ),
            ),
          ),
        ],
      ),
    );
  }
}
