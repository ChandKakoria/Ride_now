import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_now/core/models/ride_model.dart';
import 'package:ride_now/core/api_response.dart';
import 'package:ride_now/providers/rides_provider.dart';
import 'package:ride_now/presentation/rides/widgets/ride_header.dart';
import 'package:ride_now/presentation/rides/widgets/ride_timeline.dart';
import 'package:ride_now/presentation/rides/widgets/ride_passenger_info.dart';
import 'package:ride_now/presentation/rides/widgets/ride_driver_info.dart';
import 'package:ride_now/presentation/rides/widgets/booked_passengers_list.dart';
import 'package:ride_now/presentation/rides/widgets/ride_requests_list.dart';
import 'package:ride_now/presentation/rides/widgets/ride_bottom_action.dart';
import 'package:ride_now/core/app_strings.dart';
import 'package:ride_now/presentation/widgets/shared_gradient_background.dart';

class RideDetailsScreen extends StatefulWidget {
  final RideModel ride;
  final bool isMyRide;
  const RideDetailsScreen({
    super.key,
    required this.ride,
    this.isMyRide = false,
  });
  @override
  State<RideDetailsScreen> createState() => _RideDetailsScreenState();
}

class _RideDetailsScreenState extends State<RideDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<RidesProvider>().fetchRideDetails(widget.ride.id),
    );
  }

  bool _isBooking = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: _buildAppBar(),
      body: SharedGradientBackground(
        child: Consumer<RidesProvider>(
          builder: (context, provider, _) {
            final res = provider.rideDetailsResponse;
            final ride = res.data ?? widget.ride;
            if (res.status == Status.LOADING && res.data == null) {
              return const Center(child: CircularProgressIndicator());
            }
            return Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RideHeader(
                        pickupTime: ride.pickupTime,
                        status: ride.status,
                      ),
                      RideTimeline(
                        pickupTime: ride.pickupTime,
                        dropoffTime: ride.dropoffTime,
                        pickupLocation: ride.pickupLocation,
                        dropoffLocation: ride.dropoffLocation,
                      ),
                      const SizedBox(height: 16),
                      Divider(thickness: 8, color: Colors.grey[100]),
                      RidePassengerInfo(
                        totalSeats: ride.passengerCount ?? 0,
                        bookedSeats: ride.bookedSeats ?? 0,
                        availableSeats: ride.availableSeats ?? 0,
                        price: ride.price ?? 0.0,
                      ),
                      Divider(thickness: 8, color: Colors.grey[100]),
                      if (!widget.isMyRide)
                        RideDriverInfo(
                          name: ride.createdByName ?? "Unknown",
                          email: ride.createdByEmail,
                        ),
                      if (ride.bookedUsers.isNotEmpty)
                        BookedPassengersList(bookedUsers: ride.bookedUsers),
                      if (widget.isMyRide && ride.requests.isNotEmpty)
                        RideRequestsList(
                          requests: ride.requests,
                          onAccept: (id) => _handleAccept(id),
                        ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
                if (!widget.isMyRide)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: RideBottomAction(
                      status: ride.status ?? "open",
                      isLoading: _isBooking,
                      onBook: () => _handleBook(ride.id),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() => AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back, color: Color(0xFF003B4D)),
      onPressed: () => Navigator.pop(context),
    ),
    title: const Text(
      AppStrings.titleRideDetails,
      style: TextStyle(
        color: Color(0xFF003B4D),
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  Future<void> _handleBook(String id) async {
    setState(() => _isBooking = true);
    final p = context.read<RidesProvider>();
    final ok = await p.bookRide(id);
    if (mounted) {
      setState(() => _isBooking = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ok
                ? AppStrings.successRideBooked
                : (p.error ?? AppStrings.errorBookingFailed),
          ),
          backgroundColor: ok ? Colors.green : Colors.red,
        ),
      );
    }
  }

  Future<void> _handleAccept(String id) async {
    final p = context.read<RidesProvider>();
    final ok = await p.acceptRequest(id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ok
                ? AppStrings.successRequestAccepted
                : (p.error ?? AppStrings.errorAcceptFailed),
          ),
          backgroundColor: ok ? Colors.green : Colors.red,
        ),
      );
      if (ok) p.fetchRideDetails(widget.ride.id);
    }
  }
}
