import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sakhi_yatra/core/models/ride_model.dart';
import 'package:sakhi_yatra/core/models/vehicle_model.dart';
import 'package:sakhi_yatra/core/api_response.dart';
import 'package:sakhi_yatra/providers/rides_provider.dart';
import 'package:sakhi_yatra/presentation/rides/widgets/ride_header.dart';
import 'package:sakhi_yatra/presentation/rides/widgets/ride_timeline.dart';
import 'package:sakhi_yatra/presentation/rides/widgets/ride_passenger_info.dart';
import 'package:sakhi_yatra/presentation/rides/widgets/ride_driver_info.dart';
import 'package:sakhi_yatra/presentation/rides/widgets/booked_passengers_list.dart';
import 'package:sakhi_yatra/presentation/rides/widgets/ride_requests_list.dart';
import 'package:sakhi_yatra/presentation/rides/widgets/ride_bottom_action.dart';
import 'package:sakhi_yatra/core/app_strings.dart';
import 'package:sakhi_yatra/presentation/widgets/shared_gradient_background.dart';
import 'package:sakhi_yatra/presentation/widgets/common_app_bar.dart';
import 'package:sakhi_yatra/presentation/rides/driver_details_screen.dart';
import 'package:sakhi_yatra/providers/connectivity_provider.dart';

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
    return SharedGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: _buildAppBar(),
        body: Consumer<RidesProvider>(
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
                      RideDriverInfo(
                        name: ride.createdByName ?? "Unknown",
                        email: ride.createdByEmail,
                        onTap: widget.isMyRide
                            ? null
                            : () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (c) =>
                                      DriverDetailsScreen(ride: ride),
                                ),
                              ),
                      ),
                      if (ride.vehicle != null) ...[
                        Divider(thickness: 8, color: Colors.grey[100]),
                        _buildVehicleInfo(ride.vehicle!),
                      ],
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

  PreferredSizeWidget _buildAppBar() => CommonAppBar(
    leading: IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => Navigator.pop(context),
    ),
    title: const Text(AppStrings.titleRideDetails),
  );

  Future<void> _handleBook(String id) async {
    if (!Provider.of<ConnectivityProvider>(
      context,
      listen: false,
    ).checkConnectionAndNotify(context))
      return;
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

  Widget _buildVehicleInfo(VehicleModel vehicle) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Vehicle Details",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF003B4D),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFF00A3E0).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.directions_car,
                  color: Color(0xFF00A3E0),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${vehicle.name} ${vehicle.model}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF003B4D),
                      ),
                    ),
                    Text(
                      "Color: ${vehicle.color}",
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
