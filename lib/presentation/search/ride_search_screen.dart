import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_now/providers/ride_search_provider.dart';
import 'package:ride_now/presentation/search/all_rides_screen.dart';
import 'package:ride_now/presentation/search/widgets/search_header.dart';

class RideSearchScreen extends StatefulWidget {
  const RideSearchScreen({super.key});

  @override
  State<RideSearchScreen> createState() => _RideSearchScreenState();
}

class _RideSearchScreenState extends State<RideSearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
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
                          onChanged: (v) => provider.updateSource(v),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 48),
                          child: Divider(color: Colors.grey[200]),
                        ),
                        _buildInputRow(
                          icon: Icons.location_on_outlined,
                          hint: "Going to",
                          value: provider.destination,
                          onChanged: (v) => provider.updateDestination(v),
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
                await provider.searchRides();
                if (mounted)
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (c) => const AllRidesScreen()),
                  );
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00A3E0),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: provider.isLoading
            ? const CircularProgressIndicator(color: Colors.white)
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
    required Function(String) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F4F8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF00A3E0), size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: TextEditingController(text: value)
                ..selection = TextSelection.fromPosition(
                  TextPosition(offset: value?.length ?? 0),
                ),
              onChanged: onChanged,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
              ),
            ),
          ),
        ],
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
          color: const Color(0xFFF0F4F8),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_today,
              size: 18,
              color: Color(0xFF00A3E0),
            ),
            const SizedBox(width: 12),
            Text(
              "${provider.selectedDate.day}/${provider.selectedDate.month}/${provider.selectedDate.year}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
