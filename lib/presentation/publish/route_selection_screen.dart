import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ride_now/providers/create_ride_provider.dart';
import 'package:ride_now/services/place_service.dart';
import 'package:ride_now/presentation/publish/ride_time_picker_screen.dart';

class RouteSelectionScreen extends StatefulWidget {
  const RouteSelectionScreen({super.key});

  @override
  State<RouteSelectionScreen> createState() => _RouteSelectionScreenState();
}

class _RouteSelectionScreenState extends State<RouteSelectionScreen> {
  final PlaceService _placeService = PlaceService();
  final Completer<GoogleMapController> _controller = Completer();

  // Directions data
  List<dynamic> _routes = [];
  int _selectedRouteIndex = 0;
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};
  bool _isLoading = true;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();
    _fetchDirections();
  }

  Future<void> _fetchDirections() async {
    final provider = context.read<CreateRideProvider>();
    final start = provider.pickupCoordinates;
    final end = provider.dropOffCoordinates;

    if (start == null || end == null) {
      setState(() => _isLoading = false);
      return;
    }

    // Set markers
    _markers.add(
      Marker(
        markerId: const MarkerId('pickup'),
        position: start,
        infoWindow: InfoWindow(title: provider.pickupLocation ?? 'Pickup'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
    );
    _markers.add(
      Marker(
        markerId: const MarkerId('dropoff'),
        position: end,
        infoWindow: InfoWindow(title: provider.dropOffLocation ?? 'Dropoff'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );

    try {
      final result = await _placeService.getDirections(
        start.latitude,
        start.longitude,
        end.latitude,
        end.longitude,
      );

      if (result != null && result['routes'] != null) {
        setState(() {
          _routes = result['routes'];
          _updatePolylines();
          _isLoading = false;
        });

        _fitBounds(start, end);

        // Update provider with initial route
        if (_routes.isNotEmpty) {
          _updateProviderWithRoute(_selectedRouteIndex);
        }
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint('Error fetching directions: $e');
      setState(() => _isLoading = false);
    }
  }

  void _updatePolylines() {
    _polylines.clear();
    for (int i = 0; i < _routes.length; i++) {
      final route = _routes[i];
      final encodedPolyline = route['polyline']['encodedPolyline'];
      final points = _decodePolyline(encodedPolyline);

      _polylines.add(
        Polyline(
          polylineId: PolylineId('route_$i'),
          points: points,
          color: i == _selectedRouteIndex
              ? const Color(0xFF00A3E0)
              : Colors.grey,
          width: i == _selectedRouteIndex ? 5 : 3,
          zIndex: i == _selectedRouteIndex ? 1 : 0,
          onTap: () {
            setState(() {
              _selectedRouteIndex = i;
              _updatePolylines();
              _updateProviderWithRoute(i);
            });
          },
        ),
      );
    }
  }

  void _updateProviderWithRoute(int index) {
    if (_routes.isEmpty || index >= _routes.length) return;

    final route = _routes[index];
    final distanceMeters = route['distanceMeters'] as int?;
    final durationString = route['duration'] as String?; // e.g., "1234s"
    final encodedPolyline = route['polyline']['encodedPolyline'];

    final distance = _formatDistance(distanceMeters);
    final duration = _formatDuration(durationString);
    final points = _decodePolyline(encodedPolyline);

    context.read<CreateRideProvider>().updateRouteDetails(
      duration,
      distance,
      points,
    );
  }

  String _formatDistance(int? meters) {
    if (meters == null) return "";
    if (meters < 1000) {
      return "$meters m";
    } else {
      return "${(meters / 1000).toStringAsFixed(1)} km";
    }
  }

  String _formatDuration(String? duration) {
    if (duration == null) return "";
    // Format is like "354s"
    if (duration.endsWith('s')) {
      try {
        final seconds = int.parse(duration.substring(0, duration.length - 1));
        final minutes = (seconds / 60).round();
        if (minutes < 60) {
          return "$minutes min";
        } else {
          final hours = minutes ~/ 60;
          final mins = minutes % 60;
          if (mins == 0) return "$hours hr";
          return "$hours hr $mins min";
        }
      } catch (e) {
        return duration;
      }
    }
    return duration;
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }

  Future<void> _fitBounds(LatLng start, LatLng end) async {
    final controller = await _controller.future;
    LatLngBounds bounds;
    if (start.latitude > end.latitude && start.longitude > end.longitude) {
      bounds = LatLngBounds(southwest: end, northeast: start);
    } else if (start.longitude > end.longitude) {
      bounds = LatLngBounds(
        southwest: LatLng(start.latitude, end.longitude),
        northeast: LatLng(end.latitude, start.longitude),
      );
    } else if (start.latitude > end.latitude) {
      bounds = LatLngBounds(
        southwest: LatLng(end.latitude, start.longitude),
        northeast: LatLng(start.latitude, end.longitude),
      );
    } else {
      bounds = LatLngBounds(southwest: start, northeast: end);
    }

    controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            markers: _markers,
            polylines: _polylines,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ),

          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_routes.isNotEmpty)
            DraggableScrollableSheet(
              initialChildSize: 0.4,
              minChildSize: 0.2,
              maxChildSize: 0.6,
              builder: (context, scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(20),
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "What is your route?",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF003B5C),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ...List.generate(_routes.length, (index) {
                        final route = _routes[index];
                        final distanceMeters = route['distanceMeters'] as int?;
                        final durationString = route['duration'] as String?;

                        return _buildRouteOption(
                          index: index,
                          duration: _formatDuration(durationString),
                          distance: _formatDistance(distanceMeters),
                          via: route['description'] ?? "Route ${index + 1}",
                          hasTolls:
                              route['routeLabels'] != null &&
                              route['routeLabels'].toString().contains('TOLL'),
                        );
                      }),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerRight,
                        child: FloatingActionButton(
                          onPressed: () {
                            // Proceed to next step
                            if (_selectedRouteIndex < _routes.length) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const RideTimePickerScreen(),
                                ),
                              );
                            }
                          },
                          backgroundColor: const Color(0xFF00A3E0),
                          child: const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          else
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Unable to fetch routes",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF003B5C),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Please check your internet connection or try again later.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        setState(() => _isLoading = true);
                        _fetchDirections();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00A3E0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "Retry",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRouteOption({
    required int index,
    required String duration,
    required String distance,
    required String via,
    bool hasTolls = false,
  }) {
    final isSelected = _selectedRouteIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedRouteIndex = index;
          _updatePolylines();
          _updateProviderWithRoute(index);
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF0F4F8) : Colors.transparent,
          border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Row(
          children: [
            Radio(
              value: index,
              groupValue: _selectedRouteIndex,
              onChanged: (val) {
                setState(() {
                  _selectedRouteIndex = val as int;
                  _updatePolylines();
                  _updateProviderWithRoute(index);
                });
              },
              activeColor: const Color(0xFF00A3E0),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF003B5C),
                        fontWeight: FontWeight.w600,
                      ),
                      children: [
                        TextSpan(text: duration),
                        const TextSpan(
                          text: " - ",
                          style: TextStyle(fontWeight: FontWeight.normal),
                        ),
                        TextSpan(
                          text: hasTolls ? "Tolls" : "No tolls",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: hasTolls ? Colors.orange : Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "$distance - $via",
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
