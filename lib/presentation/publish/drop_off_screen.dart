import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_now/providers/create_ride_provider.dart';
import 'package:ride_now/services/place_service.dart';
import 'package:ride_now/presentation/publish/route_selection_screen.dart';

class DropOffScreen extends StatefulWidget {
  const DropOffScreen({super.key});

  @override
  State<DropOffScreen> createState() => _DropOffScreenState();
}

class _DropOffScreenState extends State<DropOffScreen> {
  final TextEditingController _controller = TextEditingController();
  final PlaceService _placeService = PlaceService();
  List<Map<String, dynamic>> _predictions = [];
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  bool _isSearching = false;
  bool _isMapVisible = false;
  bool _hasLocationPermission = false;

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(37.7749, -122.4194), // Default to SF
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<CreateRideProvider>(context, listen: false);
    if (provider.dropOffLocation != null &&
        provider.dropOffCoordinates != null) {
      _controller.text = provider.dropOffLocation!;
      _updateMarker(provider.dropOffCoordinates!, provider.dropOffLocation!);
      _isMapVisible = true;
    }
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    if (mounted) {
      setState(() {
        _hasLocationPermission = true;
      });
    }
  }

  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _mapController?.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (query.isEmpty) {
        setState(() {
          _predictions = [];
          _isSearching = false;
        });
        return;
      }

      final results = await _placeService.getSuggestions(query);
      if (mounted) {
        setState(() {
          _predictions = results;
          _isSearching = true;
        });
      }
    });
  }

  void _onPredictionSelected(Map<String, dynamic> prediction) async {
    final placeId = prediction['place_id'];
    final description = prediction['description'];

    _controller.text = description;
    setState(() {
      _predictions = [];
      _isSearching = false;
    });

    final details = await _placeService.getPlaceDetails(placeId);
    if (details != null && mounted) {
      final lat = details['lat'];
      final lng = details['lng'];
      final latLng = LatLng(lat, lng);

      _updateMarker(latLng, description);

      if (_isMapVisible) {
        _mapController?.animateCamera(CameraUpdate.newLatLng(latLng));
      } else {
        setState(() {
          _isMapVisible = true;
        });
      }

      context.read<CreateRideProvider>().updateDropOffLocation(
        description,
        latLng,
        placeId,
      );
    }
  }

  void _updateMarker(LatLng position, String title) {
    setState(() {
      _markers = {
        Marker(
          markerId: const MarkerId('dropOff'),
          position: position,
          infoWindow: InfoWindow(title: title),
          draggable: true,
          onDragEnd: (newPosition) {
            _onMarkerDragEnd(newPosition);
          },
        ),
      };
    });
  }

  void _onMarkerDragEnd(LatLng position) async {
    final address = await _placeService.getAddressFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (address != null && mounted) {
      _controller.text = address;
      _updateMarker(position, address);

      context.read<CreateRideProvider>().updateDropOffLocation(
        address,
        position,
        null,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          _isMapVisible
              ? GoogleMap(
                  initialCameraPosition: _initialPosition,
                  markers: _markers,
                  onMapCreated: (controller) {
                    _mapController = controller;
                    final provider = context.read<CreateRideProvider>();
                    if (provider.dropOffCoordinates != null) {
                      controller.animateCamera(
                        CameraUpdate.newLatLng(provider.dropOffCoordinates!),
                      );
                    }
                  },
                  myLocationEnabled: _hasLocationPermission,
                  myLocationButtonEnabled:
                      false, // Hide default button to minimize clutter
                  zoomControlsEnabled: false, // Hide default zoom controls
                )
              : Container(
                  color: const Color(0xFFF0F4F8), // Placeholder color
                  child: const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.map_outlined,
                          size: 48,
                          color: Colors.black26,
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Search location to view on map",
                          style: TextStyle(color: Colors.black45),
                        ),
                      ],
                    ),
                  ),
                ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(
                        0xFFF0F4F8,
                      ), // Light grey/blue background
                      borderRadius: BorderRadius.circular(
                        30,
                      ), // Rounded corners
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_back_ios_new,
                                size: 20,
                                color: Color(0xFF5A6A78),
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                            Expanded(
                              child: TextField(
                                controller: _controller,
                                onChanged: _onSearchChanged,
                                style: const TextStyle(
                                  color: Color(0xFF003B5C),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                decoration: const InputDecoration(
                                  hintText: "Enter the full address",
                                  hintStyle: TextStyle(
                                    color: Color(0xFF7D8C98),
                                    fontSize: 16,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                ),
                              ),
                            ),
                            if (_controller.text.isNotEmpty)
                              IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Color(0xFF5A6A78),
                                ),
                                onPressed: () {
                                  _controller.clear();
                                  _onSearchChanged('');
                                },
                              ),
                            const SizedBox(width: 8),
                          ],
                        ),
                        if (_isSearching && _predictions.isNotEmpty)
                          Container(
                            constraints: const BoxConstraints(maxHeight: 250),
                            decoration: const BoxDecoration(
                              border: Border(
                                top: BorderSide(color: Colors.black12),
                              ),
                            ),
                            child: ListView.separated(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemCount: _predictions.length,
                              separatorBuilder: (context, index) =>
                                  const Divider(
                                    height: 1,
                                    indent: 16,
                                    endIndent: 16,
                                  ),
                              itemBuilder: (context, index) {
                                final prediction = _predictions[index];
                                return ListTile(
                                  leading: const Icon(
                                    Icons.location_on_outlined,
                                    color: Color(0xFF7D8C98),
                                  ),
                                  title: Text(
                                    prediction['structured_formatting']['main_text'] ??
                                        prediction['description'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF003B5C),
                                    ),
                                  ),
                                  subtitle: Text(
                                    prediction['structured_formatting']['secondary_text'] ??
                                        "",
                                    style: const TextStyle(
                                      color: Color(0xFF7D8C98),
                                      fontSize: 13,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  onTap: () =>
                                      _onPredictionSelected(prediction),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final provider = context.read<CreateRideProvider>();
          if (provider.dropOffCoordinates != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RouteSelectionScreen(),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Please select a valid drop-off location"),
              ),
            );
          }
        },
        backgroundColor: const Color(0xFF00A3E0),
        shape: const CircleBorder(),
        child: const Icon(Icons.arrow_forward, color: Colors.white),
      ),
    );
  }
}
