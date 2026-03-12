import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sakhi_yatra/services/place_service.dart';
import 'package:sakhi_yatra/presentation/widgets/shared_gradient_background.dart';

class LocationSelectionScreen extends StatefulWidget {
  final String title;
  final String hintText;
  final String? initialValue;

  const LocationSelectionScreen({
    super.key,
    required this.title,
    required this.hintText,
    this.initialValue,
  });

  @override
  State<LocationSelectionScreen> createState() =>
      _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {
  final TextEditingController _controller = TextEditingController();
  final PlaceService _placeService = PlaceService();
  List<Map<String, dynamic>> _predictions = [];
  bool _isLoading = false;
  bool _isLocating = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialValue ?? "";
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearch(String q) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (q.isEmpty) {
        setState(() {
          _predictions = [];
          _isLoading = false;
        });
        return;
      }
      setState(() => _isLoading = true);
      final res = await _placeService.getSuggestions(q);
      setState(() {
        _predictions = res;
        _isLoading = false;
      });
    });
  }

  Future<void> _useCurrentLocation() async {
    setState(() => _isLocating = true);
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        final position = await Geolocator.getCurrentPosition();
        final address = await _placeService.getAddressFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (address != null && mounted) {
          Navigator.pop(context, address);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Location permission denied")),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error getting location: $e")));
      }
    } finally {
      if (mounted) setState(() => _isLocating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF003B4D),
        elevation: 0,
      ),
      body: SharedGradientBackground(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _controller,
                autofocus: true,
                onChanged: _onSearch,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFF00A3E0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: _controller.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _controller.clear();
                            _onSearch("");
                          },
                        )
                      : null,
                ),
              ),
            ),
            if (_controller.text.isEmpty)
              ListTile(
                leading: const Icon(
                  Icons.my_location,
                  color: Color(0xFF00A3E0),
                ),
                title: const Text("Use Current Location"),
                trailing: _isLocating
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.chevron_right),
                onTap: _isLocating ? null : _useCurrentLocation,
              ),
            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(),
                ),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: _predictions.length,
                itemBuilder: (context, index) {
                  final p = _predictions[index];
                  return ListTile(
                    leading: const Icon(
                      Icons.location_on_outlined,
                      color: Colors.grey,
                    ),
                    title: Text(p['description'] ?? ""),
                    onTap: () => Navigator.pop(context, p['description']),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
