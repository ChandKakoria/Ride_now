import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sakhi_yatra/providers/create_ride_provider.dart';
import 'package:sakhi_yatra/presentation/publish/price_per_seat_screen.dart';
import 'package:sakhi_yatra/presentation/widgets/shared_gradient_background.dart';
import 'package:sakhi_yatra/presentation/widgets/common_app_bar.dart';

class PassengerCountScreen extends StatefulWidget {
  const PassengerCountScreen({super.key});

  @override
  State<PassengerCountScreen> createState() => _PassengerCountScreenState();
}

class _PassengerCountScreenState extends State<PassengerCountScreen> {
  int _passengerCount = 1;

  @override
  void initState() {
    super.initState();
    _passengerCount = context.read<CreateRideProvider>().passengerCount;
  }

  void _increment() {
    setState(() {
      if (_passengerCount < 8) _passengerCount++;
    });
  }

  void _decrement() {
    setState(() {
      if (_passengerCount > 1) _passengerCount--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: CommonAppBar(
        title: const Text(
          "Passenger Count",
        ), // I'll add a title or leave it empty if it was empty
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SharedGradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "How many passengers will you take?",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF003B4D),
                    height: 1.2,
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildCountButton(
                      icon: Icons.remove,
                      onTap: _decrement,
                      enabled: _passengerCount > 1,
                    ),
                    const SizedBox(width: 40),
                    Text(
                      "$_passengerCount",
                      style: const TextStyle(
                        fontSize: 80,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF003B4D),
                      ),
                    ),
                    const SizedBox(width: 40),
                    _buildCountButton(
                      icon: Icons.add,
                      onTap: _increment,
                      enabled: _passengerCount < 8,
                    ),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<CreateRideProvider>().updatePassengerCount(
                        _passengerCount,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PricePerSeatScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00A3E0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Next",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCountButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool enabled,
  }) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: enabled ? Colors.white : Colors.grey[100],
          shape: BoxShape.circle,
          border: Border.all(
            color: enabled ? const Color(0xFF00A3E0) : Colors.grey[300]!,
            width: 2,
          ),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: const Color(0xFF00A3E0).withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Icon(
          icon,
          color: enabled ? const Color(0xFF00A3E0) : Colors.grey[400],
          size: 32,
        ),
      ),
    );
  }
}
