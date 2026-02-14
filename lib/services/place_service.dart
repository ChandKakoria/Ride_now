import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class PlaceService {
  final String apiKey = 'AIzaSyC2dKdUM_GSzRaNrMJbIEpz-nyPdmhY2Hc';

  Future<List<Map<String, dynamic>>> getSuggestions(String query) async {
    if (query.isEmpty) return [];

    final String url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        return List<Map<String, dynamic>>.from(data['predictions']);
      }
    }
    return [];
  }

  Future<Map<String, dynamic>?> getPlaceDetails(String placeId) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        final result = data['result'];
        final location = result['geometry']['location'];
        return {
          'lat': location['lat'],
          'lng': location['lng'],
          'name': result['name'],
          'formatted_address': result['formatted_address'],
        };
      }
    }
    return null;
  }

  Future<String?> getAddressFromCoordinates(double lat, double lng) async {
    final String url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        final results = data['results'] as List;
        if (results.isNotEmpty) {
          return results.first['formatted_address'];
        }
      }
    }
    return null;
  }

  Future<Map<String, dynamic>?> getDirections(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) async {
    const String url =
        'https://routes.googleapis.com/directions/v2:computeRoutes';

    final body = json.encode({
      "origin": {
        "location": {
          "latLng": {"latitude": startLat, "longitude": startLng},
        },
      },
      "destination": {
        "location": {
          "latLng": {"latitude": endLat, "longitude": endLng},
        },
      },
      "travelMode": "DRIVE",
      "routingPreference": "TRAFFIC_AWARE",
      "computeAlternativeRoutes": true,
      "routeModifiers": {
        "avoidTolls": false,
        "avoidHighways": false,
        "avoidFerries": false,
      },
      "languageCode": "en-US",
      "units": "METRIC",
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'X-Goog-Api-Key': apiKey,
          'X-Goog-FieldMask':
              'routes.duration,routes.distanceMeters,routes.polyline.encodedPolyline,routes.description,routes.routeLabels',
        },
        body: body,
      );

      debugPrint('Routes API URL: $url');
      debugPrint('Routes API Status: ${response.statusCode}');
      debugPrint('Routes API Body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final data = json.decode(response.body);
        debugPrint('Routes API Error: ${data}');
      }
    } catch (e) {
      debugPrint('Error fetching routes: $e');
    }
    return null;
  }
}
