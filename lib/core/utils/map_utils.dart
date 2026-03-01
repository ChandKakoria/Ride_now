import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapUtils {
  static List<LatLng> decodePolyline(String encoded) {
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

  static String formatDistance(int? meters) {
    if (meters == null) return "";
    return meters < 1000
        ? "$meters m"
        : "${(meters / 1000).toStringAsFixed(1)} km";
  }

  static String formatDuration(String? duration) {
    if (duration == null || !duration.endsWith('s')) return duration ?? "";
    try {
      final seconds = int.parse(duration.substring(0, duration.length - 1));
      final minutes = (seconds / 60).round();
      if (minutes < 60) return "$minutes min";
      final hours = minutes ~/ 60;
      final mins = minutes % 60;
      return mins == 0 ? "$hours hr" : "$hours hr $mins min";
    } catch (e) {
      return duration;
    }
  }

  static LatLngBounds getBounds(LatLng start, LatLng end) {
    if (start.latitude > end.latitude && start.longitude > end.longitude) {
      return LatLngBounds(southwest: end, northeast: start);
    } else if (start.longitude > end.longitude) {
      return LatLngBounds(
        southwest: LatLng(start.latitude, end.longitude),
        northeast: LatLng(end.latitude, start.longitude),
      );
    } else if (start.latitude > end.latitude) {
      return LatLngBounds(
        southwest: LatLng(end.latitude, start.longitude),
        northeast: LatLng(start.latitude, end.longitude),
      );
    } else {
      return LatLngBounds(southwest: start, northeast: end);
    }
  }
}
