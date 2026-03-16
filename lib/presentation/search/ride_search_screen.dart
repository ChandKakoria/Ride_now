import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sakhi_yatra/providers/ride_search_provider.dart';
import 'package:sakhi_yatra/presentation/search/all_rides_screen.dart';
import 'package:sakhi_yatra/presentation/search/widgets/search_header.dart';
import 'package:sakhi_yatra/presentation/search/location_selection_screen.dart';
import 'package:sakhi_yatra/providers/connectivity_provider.dart';

class RideSearchScreen extends StatefulWidget {
  const RideSearchScreen({super.key});

  @override
  State<RideSearchScreen> createState() => _RideSearchScreenState();
}

class _RideSearchScreenState extends State<RideSearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SearchHeader(),
            Transform.translate(
              offset: const Offset(0, -60),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white.withOpacity(0.1)
                          : Colors.transparent,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.black.withOpacity(0.5)
                            : Theme.of(context).shadowColor.withOpacity(0.08),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),
                  child: Consumer<RideSearchProvider>(
                    builder: (context, provider, child) => Column(
                      children: [
                        _buildInputRow(
                          icon: Icons.radio_button_unchecked,
                          hint: "Leaving from",
                          value: provider.source,
                          onTap: () async {
                            final result = await Navigator.push<String>(
                              context,
                              MaterialPageRoute(
                                builder: (c) => const LocationSelectionScreen(
                                  title: "Leaving from",
                                  hintText: "Enter pickup location",
                                ),
                              ),
                            );
                            if (result != null) provider.updateSource(result);
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 48),
                          child: Divider(color: Theme.of(context).dividerColor),
                        ),
                        _buildInputRow(
                          icon: Icons.location_on_outlined,
                          hint: "Going to",
                          value: provider.destination,
                          onTap: () async {
                            final result = await Navigator.push<String>(
                              context,
                              MaterialPageRoute(
                                builder: (c) => const LocationSelectionScreen(
                                  title: "Going to",
                                  hintText: "Enter destination",
                                ),
                              ),
                            );
                            if (result != null)
                              provider.updateDestination(result);
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildDateSelector(context, provider),
                        const SizedBox(height: 30),
                        _buildSearchButton(provider),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchButton(RideSearchProvider provider) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: provider.isLoading
            ? null
            : () async {
                if (provider.source == null || provider.destination == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Enter locations")),
                  );
                  return;
                }
                if (!Provider.of<ConnectivityProvider>(
                  context,
                  listen: false,
                ).checkConnectionAndNotify(context))
                  return;
                await provider.searchRides();
                if (mounted)
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (c) => const AllRidesScreen()),
                  );
              },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: provider.isLoading
            ? CircularProgressIndicator()
            : const Text(
                "Search Rides",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  Widget _buildInputRow({
    required IconData icon,
    required String hint,
    String? value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black
                    : Theme.of(context).primaryColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value != null && value.isNotEmpty ? value : hint,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: value != null && value.isNotEmpty
                          ? Theme.of(context).colorScheme.onSurface
                          : Theme.of(context).disabledColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector(BuildContext context, RideSearchProvider provider) {
    return GestureDetector(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: provider.selectedDate,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (date != null) provider.updateDate(date);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              size: 18,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black
                  : Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 12),
            Text(
              "${provider.selectedDate.day}/${provider.selectedDate.month}/${provider.selectedDate.year}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors
                          .black // Preserves visibility against white dark mode background
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
