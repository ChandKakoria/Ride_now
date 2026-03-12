import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sakhi_yatra/providers/create_ride_provider.dart';
import 'package:sakhi_yatra/services/place_service.dart';
import 'package:sakhi_yatra/core/utils/map_utils.dart';
import 'package:sakhi_yatra/presentation/publish/widgets/route_selection_sheet.dart';
import 'package:sakhi_yatra/presentation/widgets/shared_gradient_background.dart';

class RouteSelectionScreen extends StatefulWidget {
  const RouteSelectionScreen({super.key});
  @override
  State<RouteSelectionScreen> createState() => _RouteSelectionScreenState();
}

class _RouteSelectionScreenState extends State<RouteSelectionScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  List<dynamic> _routes = [];
  int _selectedRouteIndex = 0;
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDirections();
  }

  Future<void> _fetchDirections() async {
    final p = context.read<CreateRideProvider>();
    final start = p.pickupCoordinates, end = p.dropOffCoordinates;
    if (start == null || end == null) return;
    setState(() {
      _markers = {
        Marker(
          markerId: const MarkerId('p'),
          position: start,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        ),
        Marker(
          markerId: const MarkerId('d'),
          position: end,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      };
    });
    try {
      final res = await PlaceService().getDirections(
        start.latitude,
        start.longitude,
        end.latitude,
        end.longitude,
      );
      if (res != null && res['routes'] != null) {
        setState(() {
          _routes = res['routes'];
          _updatePolylines();
          _isLoading = false;
        });
        (await _controller.future).animateCamera(
          CameraUpdate.newLatLngBounds(MapUtils.getBounds(start, end), 50),
        );
        _updateProvider(0);
      } else
        setState(() => _isLoading = false);
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  void _updatePolylines() {
    _polylines = _routes
        .asMap()
        .entries
        .map(
          (e) => Polyline(
            polylineId: PolylineId('r${e.key}'),
            points: MapUtils.decodePolyline(
              e.value['polyline']['encodedPolyline'],
            ),
            color: e.key == _selectedRouteIndex
                ? const Color(0xFF00A3E0)
                : Colors.grey,
            width: e.key == _selectedRouteIndex ? 5 : 3,
            zIndex: e.key == _selectedRouteIndex ? 1 : 0,
            onTap: () => _updateProvider(e.key),
            consumeTapEvents: true,
          ),
        )
        .toSet();
  }

  void _updateProvider(int i) {
    setState(() {
      _selectedRouteIndex = i;
      _updatePolylines();
    });
    final r = _routes[i];
    context.read<CreateRideProvider>().updateRouteDetails(
      MapUtils.formatDuration(r['duration']),
      MapUtils.formatDistance(r['distanceMeters']),
      r['distanceMeters'],
      MapUtils.decodePolyline(r['polyline']['encodedPolyline']),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SharedGradientBackground(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(0, 0),
                zoom: 2,
              ),
              markers: _markers,
              polylines: _polylines,
              onMapCreated: (c) => _controller.complete(c),
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
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
                builder: (c, s) => RouteSelectionSheet(
                  controller: s,
                  routes: _routes,
                  selectedIndex: _selectedRouteIndex,
                  onSelect: _updateProvider,
                ),
              )
            else
              _buildError(),
          ],
        ),
      ),
    );
  }

  Widget _buildError() => Positioned(
    bottom: 0,
    left: 0,
    right: 0,
    child: Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const Text("Unable to fetch routes"),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _fetchDirections,
            child: const Text("Retry"),
          ),
        ],
      ),
    ),
  );
}
