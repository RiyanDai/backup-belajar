import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPickerProvider extends ChangeNotifier {
  static const LatLng defaultLocation = LatLng(-6.200000, 106.816666);

  LatLng _pickedLocation = defaultLocation;
  String? _pickedAddress;
  bool _isLoadingAddress = false;
  bool _isFetchingGps = false;
  String? _errorMessage;
  Set<Marker> _markers = {};

  LatLng get pickedLocation => _pickedLocation;
  String? get pickedAddress => _pickedAddress;
  bool get isLoadingAddress => _isLoadingAddress;
  bool get isFetchingGps => _isFetchingGps;
  String? get errorMessage => _errorMessage;
  Set<Marker> get markers => _markers;

  void init(LatLng? initial) {
    _pickedLocation = initial ?? defaultLocation;
    _errorMessage = null;
    updatePickedLocation(_pickedLocation);
  }

  Future<void> updatePickedLocation(LatLng position) async {
    _pickedLocation = position;
    _isLoadingAddress = true;
    _errorMessage = null;
    _markers = {
      Marker(
        markerId: const MarkerId('picked_location'),
        position: position,
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueGreen,
        ),
      ),
    };
    notifyListeners();

    String addressText =
        'Lat: ${position.latitude.toStringAsFixed(5)}, Lon: ${position.longitude.toStringAsFixed(5)}';

    try {
      final placemarks = await Geocoding().placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final parts = [
          place.street,
          place.subLocality,
          place.locality,
          place.subAdministrativeArea,
          place.administrativeArea,
        ].where((p) => p != null && p.trim().isNotEmpty).toList();
        if (parts.isNotEmpty) {
          addressText = parts.join(', ');
        }
      }
    } catch (_) {
      // Keep lat/lon fallback string
    }

    _pickedAddress = addressText;
    _isLoadingAddress = false;
    _markers = {
      Marker(
        markerId: const MarkerId('picked_location'),
        position: position,
        infoWindow: InfoWindow(title: addressText),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueGreen,
        ),
      ),
    };
    notifyListeners();
  }

  Future<LatLng?> fetchCurrentLocation({
    required void Function(String message) onPermissionDenied,
    required void Function(String message) onGpsDisabled,
    required String permissionDeniedMessage,
    required String gpsDisabledMessage,
  }) async {
    _isFetchingGps = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // 1. Check and request location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _isFetchingGps = false;
          _errorMessage = permissionDeniedMessage;
          notifyListeners();
          onPermissionDenied(permissionDeniedMessage);
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _isFetchingGps = false;
        _errorMessage = permissionDeniedMessage;
        notifyListeners();
        onPermissionDenied(permissionDeniedMessage);
        await Geolocator.openAppSettings();
        return null;
      }

      // 2. Check if device location service (GPS) is turned on
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _isFetchingGps = false;
        _errorMessage = gpsDisabledMessage;
        notifyListeners();
        onGpsDisabled(gpsDisabledMessage);
        await Geolocator.openLocationSettings();
        return null;
      }

      // 3. Fetch position with fallback to last known position
      Position? position;
      try {
        position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            timeLimit: Duration(seconds: 8),
          ),
        );
      } catch (_) {
        position = await Geolocator.getLastKnownPosition();
      }

      if (position != null) {
        final target = LatLng(position.latitude, position.longitude);
        await updatePickedLocation(target);
        _isFetchingGps = false;
        notifyListeners();
        return target;
      } else {
        _isFetchingGps = false;
        notifyListeners();
        return null;
      }
    } catch (e) {
      _isFetchingGps = false;
      _errorMessage = e.toString();
      notifyListeners();
      return null;
    }
  }
}

