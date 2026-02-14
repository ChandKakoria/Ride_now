import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_now/providers/ride_search_provider.dart';
import 'package:ride_now/presentation/search/all_rides_screen.dart';

class RideSearchScreen extends StatelessWidget {
  const RideSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Soft background
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Premium Curvy Header
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.40,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const CircleAvatar(
                              backgroundColor: Colors.white24,
                              child: Icon(Icons.menu, color: Colors.white),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white24,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 16,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    "4.8",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          "Where to\nnext?",
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Floating Search Card
            Transform.translate(
              offset: const Offset(0, -60), // Pull up overlap
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
                    builder: (context, provider, child) {
                      return Column(
                        children: [
                          _buildInputRow(
                            context: context,
                            icon: Icons.radio_button_unchecked,
                            hint: "Leaving from",
                            value: provider.source,
                            onChanged: provider.updateSource,
                            isFirst: true,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 48),
                            child: Divider(color: Colors.grey[200]),
                          ),
                          _buildInputRow(
                            context: context,
                            icon: Icons.location_on_outlined,
                            hint: "Going to",
                            value: provider.destination,
                            onChanged: provider.updateDestination,
                            isLast: true,
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: _buildDateSelector(context, provider),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildPassengerSelector(
                                  context,
                                  provider,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const AllRidesScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF00A3E0),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Text(
                                "Search Rides",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputRow({
    required BuildContext context,
    required IconData icon,
    required String hint,
    String? value,
    required Function(String) onChanged,
    bool isFirst = false,
    bool isLast = false,
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
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontWeight: FontWeight.w500,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
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
        if (date != null) {
          provider.updateDate(date);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F4F8),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Date",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              "${provider.selectedDate.day}/${provider.selectedDate.month}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPassengerSelector(
    BuildContext context,
    RideSearchProvider provider,
  ) {
    return GestureDetector(
      onTap: () {
        // Implement passenger selection logic if needed
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F4F8),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Passengers",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              "${provider.passengerCount}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
