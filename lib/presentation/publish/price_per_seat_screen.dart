import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_now/providers/create_ride_provider.dart';
import 'package:ride_now/services/ride_service.dart';
import 'package:ride_now/core/api_response.dart';

class PricePerSeatScreen extends StatefulWidget {
  const PricePerSeatScreen({super.key});

  @override
  State<PricePerSeatScreen> createState() => _PricePerSeatScreenState();
}

class _PricePerSeatScreenState extends State<PricePerSeatScreen> {
  double _price = 0.0;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _price = context.read<CreateRideProvider>().pricePerSeat;
    if (_price > 0) {
      _controller.text = _price.toStringAsFixed(0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _increment() {
    setState(() {
      _price += 50;
      _controller.text = _price.toStringAsFixed(0);
    });
  }

  void _decrement() {
    setState(() {
      if (_price >= 50) {
        _price -= 50;
        _controller.text = _price.toStringAsFixed(0);
      }
    });
  }

  bool _isLoading = false;
  final RideService _rideService = RideService();

  @override
  Widget build(BuildContext context) {
    // Recommend price based on distance if available (mock logic for now or simple calculation)
    final recommendedPrice = 350; // Placeholder

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
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
                "Set your price per seat",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF003B5C),
                ),
              ),
              const SizedBox(height: 40),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildPriceButton(
                          icon: Icons.remove,
                          onTap: _decrement,
                          enabled: _price > 0,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "₹",
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF003B5C),
                              ),
                            ),
                            SizedBox(
                              width: 120,
                              child: TextField(
                                controller: _controller,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 60,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF003B5C),
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _price = double.tryParse(value) ?? 0.0;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        _buildPriceButton(
                          icon: Icons.add,
                          onTap: _increment,
                          enabled: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Recommended: ₹$recommendedPrice - ₹${recommendedPrice + 100}",
                      style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          final provider = context.read<CreateRideProvider>();

                          // Ensure valid date and time
                          if (provider.selectedDate == null ||
                              provider.selectedTime == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please select date and time'),
                              ),
                            );
                            return;
                          }

                          setState(() => _isLoading = true);

                          // Calculate times
                          final DateTime pickupDateTime = DateTime(
                            provider.selectedDate!.year,
                            provider.selectedDate!.month,
                            provider.selectedDate!.day,
                            provider.selectedTime!.hour,
                            provider.selectedTime!.minute,
                          );

                          // Parse trip duration (e.g., "1 hour 20 mins")
                          Duration duration = const Duration(
                            hours: 1,
                          ); // Fallback
                          if (provider.tripDuration != null) {
                            duration = _parseDuration(provider.tripDuration!);
                          }

                          final DateTime dropoffDateTime = pickupDateTime.add(
                            duration,
                          );

                          // Construct Payload
                          final rideData = {
                            "pickup_location": provider.pickupLocation,
                            "dropoff_location": provider.dropOffLocation,
                            "pickup_time": pickupDateTime.toIso8601String(),
                            "dropoff_time": dropoffDateTime.toIso8601String(),
                            "passenger_count": provider.passengerCount,
                            "price": _price,
                          };

                          // Call API
                          final response = await _rideService.createRide(
                            rideData,
                          );

                          setState(() => _isLoading = false);

                          if (response.status == Status.COMPLETED) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Ride Published Successfully!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              // Navigate back to home
                              Navigator.of(
                                context,
                              ).popUntil((route) => route.isFirst);
                            }
                          } else {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    response.message ??
                                        'Failed to publish ride',
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00A3E0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Publish Ride",
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
    );
  }

  Duration _parseDuration(String durationString) {
    int hours = 0;
    int minutes = 0;

    // Example input: "1 hour 20 mins" or "45 mins" or "2 hours"
    final parts = durationString.split(' ');
    for (int i = 0; i < parts.length; i++) {
      if (parts[i].startsWith('hour')) {
        if (i > 0) hours = int.tryParse(parts[i - 1]) ?? 0;
      } else if (parts[i].startsWith('min')) {
        if (i > 0) minutes = int.tryParse(parts[i - 1]) ?? 0;
      }
    }
    return Duration(hours: hours, minutes: minutes);
  }

  Widget _buildPriceButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool enabled,
  }) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: enabled ? const Color(0xFFF0F4F8) : Colors.grey[100],
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: enabled ? const Color(0xFF003B5C) : Colors.grey[400],
          size: 32,
        ),
      ),
    );
  }
}
