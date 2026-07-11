import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_bridge_car/core/models/ride_model.dart';
import 'package:ride_bridge_car/core/models/vehicle_model.dart';
import 'package:ride_bridge_car/core/api_response.dart';
import 'package:ride_bridge_car/providers/rides_provider.dart';
import 'package:ride_bridge_car/presentation/rides/widgets/ride_header.dart';
import 'package:ride_bridge_car/presentation/rides/widgets/ride_timeline.dart';
import 'package:ride_bridge_car/presentation/rides/widgets/ride_passenger_info.dart';
import 'package:ride_bridge_car/presentation/rides/widgets/ride_driver_info.dart';
import 'package:ride_bridge_car/presentation/rides/widgets/booked_passengers_list.dart';
import 'package:ride_bridge_car/presentation/rides/widgets/ride_requests_list.dart';
import 'package:ride_bridge_car/presentation/rides/widgets/ride_bottom_action.dart';
import 'package:ride_bridge_car/core/app_strings.dart';
import 'package:ride_bridge_car/presentation/widgets/shared_gradient_background.dart';
import 'package:ride_bridge_car/presentation/widgets/common_app_bar.dart';
import 'package:ride_bridge_car/presentation/rides/driver_details_screen.dart';
import 'package:ride_bridge_car/presentation/rides/cancel_ride_bottom_sheets.dart';
import 'package:ride_bridge_car/providers/connectivity_provider.dart';

class RideDetailsScreen extends StatefulWidget {
  final RideModel? ride;
  final bool isMyRide;
  const RideDetailsScreen({super.key, this.ride, this.isMyRide = false});
  @override
  State<RideDetailsScreen> createState() => _RideDetailsScreenState();
}

class _RideDetailsScreenState extends State<RideDetailsScreen> {
  String? _rideId;
  bool _isBooking = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_rideId == null) {
      final rideIdFromRoute =
          ModalRoute.of(context)?.settings.arguments as String?;
      _rideId = widget.ride?.id ?? rideIdFromRoute;
      if (_rideId != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) context.read<RidesProvider>().fetchRideDetails(_rideId!);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SharedGradientBackground(
      child: Scaffold(
        appBar: _buildAppBar(),
        body: Consumer<RidesProvider>(
          builder: (context, provider, _) {
            final res = provider.rideDetailsResponse;
            final ride = res.data ?? widget.ride;
            if (ride == null ||
                (res.status == Status.LOADING && res.data == null)) {
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              );
            }
            return Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: RideHeader(
                                pickupTime: ride.pickupTime,
                                status: ride.status,
                              ),
                            ),
                            Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: RideTimeline(
                                pickupTime: ride.pickupTime,
                                dropoffTime: ride.dropoffTime,
                                pickupLocation: ride.pickupLocation,
                                dropoffLocation: ride.dropoffLocation,
                              ),
                            ),
                            Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: RidePassengerInfo(
                                totalSeats: ride.passengerCount ?? 0,
                                bookedSeats: ride.bookedSeats ?? 0,
                                availableSeats: ride.availableSeats ?? 0,
                                price: ride.price ?? 0.0,
                              ),
                            ),
                            Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: RideDriverInfo(
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
                            ),
                            if (ride.vehicle != null)
                              Card(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: _buildVehicleInfo(ride.vehicle!),
                              ),
                            if (ride.bookedUsers.isNotEmpty)
                              Card(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: BookedPassengersList(
                                  bookedUsers: ride.bookedUsers,
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (widget.isMyRide && ride.requests.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: RideRequestsList(
                              requests: ride.requests,
                              onAccept: (id) => _handleAccept(id),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: widget.isMyRide
                      ? _buildCancelAction(context, ride)
                      : (ride.status?.toLowerCase() == 'booked' ||
                            ride.status?.toLowerCase() == 'requested')
                      ? _buildCancelAction(context, ride)
                      : RideBottomAction(
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
        ),
      );
      if (ok && _rideId != null) p.fetchRideDetails(_rideId!);
    }
  }

  Widget _buildCancelAction(BuildContext context, RideModel ride) {
    final isCancelled = ride.status?.toLowerCase() == 'cancelled';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: isCancelled
            ? null
            : () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (c) => CancelRideReasonBottomSheet(rideId: ride.id),
                );
              },
        icon: const Icon(Icons.cancel, color: Colors.white),
        label: Text(
          isCancelled ? "Cancelled" : "Cancel Ride",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          disabledBackgroundColor: Colors.grey.shade400,
          disabledForegroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          elevation: 0,
        ),
      ),
    );
  }

  Widget _buildVehicleInfo(VehicleModel vehicle) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Vehicle Details",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Theme.of(context).primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.directions_car,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black
                      : Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${vehicle.name} ${vehicle.model}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      "Color: ${vehicle.color}",
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).disabledColor,
                      ),
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
