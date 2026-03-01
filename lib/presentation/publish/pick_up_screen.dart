import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ride_now/providers/create_ride_provider.dart';
import 'package:ride_now/services/place_service.dart';
import 'package:ride_now/presentation/publish/drop_off_screen.dart';
import 'package:ride_now/presentation/publish/widgets/location_search_bar.dart';
import 'package:ride_now/presentation/publish/widgets/location_prediction_list.dart';
import 'package:ride_now/presentation/widgets/shared_gradient_background.dart';

class PickUpScreen extends StatefulWidget {
  const PickUpScreen({super.key});

  @override
  State<PickUpScreen> createState() => _PickUpScreenState();
}

class _PickUpScreenState extends State<PickUpScreen> {
  final TextEditingController _controller = TextEditingController();
  final PlaceService _placeService = PlaceService();
  List<Map<String, dynamic>> _predictions = [];
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  bool _isSearching = false,
      _isMapVisible = false,
      _hasLocationPermission = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    final provider = context.read<CreateRideProvider>();
    if (provider.pickupLocation != null && provider.pickupCoordinates != null) {
      _controller.text = provider.pickupLocation!;
      _updateMarker(provider.pickupCoordinates!, provider.pickupLocation!);
      _isMapVisible = true;
    }
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      setState(() => _hasLocationPermission = true);
    }
  }

  void _onSearch(String q) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (q.isEmpty) {
        setState(() {
          _predictions = [];
          _isSearching = false;
        });
        return;
      }
      final res = await _placeService.getSuggestions(q);
      setState(() {
        _predictions = res;
        _isSearching = true;
      });
    });
  }

  void _onSelected(Map<String, dynamic> p) async {
    final details = await _placeService.getPlaceDetails(p['place_id']);
    if (details != null && mounted) {
      final latLng = LatLng(details['lat'], details['lng']);
      _controller.text = p['description'];
      setState(() {
        _predictions = [];
        _isSearching = _isMapVisible = true;
      });
      _updateMarker(latLng, p['description']);
      _mapController?.animateCamera(CameraUpdate.newLatLng(latLng));
      context.read<CreateRideProvider>().updatePickupLocation(
        p['description'],
        latLng,
        p['place_id'],
      );
    }
  }

  void _updateMarker(LatLng pos, String title) {
    setState(
      () => _markers = {
        Marker(
          markerId: const MarkerId('p'),
          position: pos,
          infoWindow: InfoWindow(title: title),
          draggable: true,
          onDragEnd: _onDrag,
        ),
      },
    );
  }

  void _onDrag(LatLng pos) async {
    final addr = await _placeService.getAddressFromCoordinates(
      pos.latitude,
      pos.longitude,
    );
    if (addr != null && mounted) {
      _controller.text = addr;
      _updateMarker(pos, addr);
      context.read<CreateRideProvider>().updatePickupLocation(addr, pos, null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: SharedGradientBackground(
        child: Stack(
          children: [
            _buildMap(),
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        LocationSearchBar(
                          controller: _controller,
                          onChanged: _onSearch,
                          onClear: () {
                            _controller.clear();
                            _onSearch('');
                          },
                          onBack: () => Navigator.pop(context),
                          hintText: "Enter pickup location",
                        ),
                        if (_isSearching && _predictions.isNotEmpty)
                          LocationPredictionList(
                            predictions: _predictions,
                            onSelected: _onSelected,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            context.read<CreateRideProvider>().pickupCoordinates != null
            ? Navigator.push(
                context,
                MaterialPageRoute(builder: (c) => const DropOffScreen()),
              )
            : ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Select a pickup location")),
              ),
        backgroundColor: const Color(0xFF00A3E0),
        child: const Icon(Icons.arrow_forward, color: Colors.white),
      ),
    );
  }

  Widget _buildMap() => _isMapVisible
      ? GoogleMap(
          initialCameraPosition: const CameraPosition(
            target: LatLng(37.77, -122.41),
            zoom: 14,
          ),
          markers: _markers,
          onMapCreated: (c) => _mapController = c,
          myLocationEnabled: _hasLocationPermission,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
        )
      : Container(
          color: Colors.transparent,
          child: const Center(child: Text("Search location to view on map")),
        );
}
