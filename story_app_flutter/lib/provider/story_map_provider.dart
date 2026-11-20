import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StoryMapProvider extends ChangeNotifier {
  MapType _currentMapType = MapType.normal;
  String? _resolvedAddress;
  bool _isLoadingAddress = false;

  MapType get currentMapType => _currentMapType;
  String? get resolvedAddress => _resolvedAddress;
  bool get isLoadingAddress => _isLoadingAddress;

  void reset() {
    _currentMapType = MapType.normal;
    _resolvedAddress = null;
    _isLoadingAddress = false;
    notifyListeners();
  }

  void init({
    required double? lat,
    required double? lon,
    String? initialAddress,
  }) {
    _currentMapType = MapType.normal;
    _resolvedAddress = (initialAddress != null && initialAddress.trim().isNotEmpty)
        ? initialAddress.trim()
        : null;
    _isLoadingAddress = false;
    notifyListeners();

    if (_resolvedAddress == null && lat != null && lon != null) {
      resolveAddress(lat, lon);
    }
  }

  Future<void> resolveAddress(double lat, double lon) async {
    _isLoadingAddress = true;
    notifyListeners();

    try {
      final placemarks = await Geocoding().placemarkFromCoordinates(lat, lon);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final parts = [
          place.street,
          place.subLocality,
          place.locality,
          place.subAdministrativeArea,
          place.administrativeArea,
          place.country,
        ].where((p) => p != null && p.trim().isNotEmpty).toList();
        if (parts.isNotEmpty) {
          _resolvedAddress = parts.join(', ');
        }
      }
    } catch (_) {
      // Keep null or fallback
    }

    _isLoadingAddress = false;
    notifyListeners();
  }

  void toggleMapType() {
    if (_currentMapType == MapType.normal) {
      _currentMapType = MapType.satellite;
    } else if (_currentMapType == MapType.satellite) {
      _currentMapType = MapType.terrain;
    } else {
      _currentMapType = MapType.normal;
    }
    notifyListeners();
  }
}
