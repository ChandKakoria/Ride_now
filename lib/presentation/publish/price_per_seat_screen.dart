import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_now/providers/create_ride_provider.dart';
import 'package:ride_now/services/ride_action_service.dart';
import 'package:ride_now/core/api_response.dart';
import 'package:ride_now/presentation/publish/widgets/price_selector.dart';
import 'package:ride_now/presentation/widgets/shared_gradient_background.dart';

class PricePerSeatScreen extends StatefulWidget {
  const PricePerSeatScreen({super.key});

  @override
  State<PricePerSeatScreen> createState() => _PricePerSeatScreenState();
}

class _PricePerSeatScreenState extends State<PricePerSeatScreen> {
  double _price = 0.0;
  final TextEditingController _controller = TextEditingController();
  final RideActionService _rideActionService = RideActionService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _price = context.read<CreateRideProvider>().pricePerSeat;
    if (_price > 0) _controller.text = _price.toStringAsFixed(0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updatePrice(double newPrice) {
    setState(() {
      _price = newPrice.clamp(0, 10000);
      _controller.text = _price.toStringAsFixed(0);
    });
  }

  Future<void> _publishRide() async {
    final provider = context.read<CreateRideProvider>();
    if (provider.selectedDate == null || provider.selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select date and time')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final pickupDateTime = DateTime(
      provider.selectedDate!.year,
      provider.selectedDate!.month,
      provider.selectedDate!.day,
      provider.selectedTime!.hour,
      provider.selectedTime!.minute,
    );
    final duration = _parseDuration(provider.tripDuration ?? "1 hour");
    final dropoffDateTime = pickupDateTime.add(duration);

    final rideData = {
      "pickup_location": provider.pickupLocation,
      "dropoff_location": provider.dropOffLocation,
      "pickup_time": pickupDateTime.toIso8601String(),
      "dropoff_time": dropoffDateTime.toIso8601String(),
      "passenger_count": provider.passengerCount,
      "price": _price,
    };

    final response = await _rideActionService.createRide(rideData);
    setState(() => _isLoading = false);

    if (response.status == Status.COMPLETED) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ride Published Successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message ?? 'Failed to publish ride'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF003B4D)),
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
                const Text(
                  "Set your price per seat",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF003B4D),
                  ),
                ),
                const SizedBox(height: 40),
                PriceSelector(
                  price: _price,
                  controller: _controller,
                  onIncrement: () => _updatePrice(_price + 50),
                  onDecrement: () => _updatePrice(_price - 50),
                  onChanged: (v) =>
                      setState(() => _price = double.tryParse(v) ?? 0.0),
                  recommendedPrice: 350,
                ),
                const Spacer(),
                _buildPublishButton(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPublishButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _publishRide,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00A3E0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
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
    );
  }

  Duration _parseDuration(String durationString) {
    int hours = 0, minutes = 0;
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
}
