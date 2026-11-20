import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import '../data/api/api_service.dart';
import '../data/preferences/auth_preferences.dart';

class UploadProvider extends ChangeNotifier {
  final ApiService _apiService;
  final AuthPreferences _authPreferences;
  final ImagePicker _picker;

  XFile? _imageFile;
  Uint8List? _imageBytes;
  bool _isUploading = false;
  String? _errorMessage;
  bool _uploadSuccess = false;

  LatLng? _pickedLocation;
  String? _pickedLocationAddress;
  bool _isLoadingLocation = false;

  UploadProvider(
    this._apiService,
    this._authPreferences, [
    ImagePicker? picker,
  ]) : _picker = picker ?? ImagePicker();

  XFile? get imageFile => _imageFile;
  Uint8List? get imageBytes => _imageBytes;
  bool get isUploading => _isUploading;
  String? get errorMessage => _errorMessage;
  bool get uploadSuccess => _uploadSuccess;

  LatLng? get pickedLocation => _pickedLocation;
  String? get pickedLocationAddress => _pickedLocationAddress;
  bool get isLoadingLocation => _isLoadingLocation;

  void setImageFile(XFile file, Uint8List bytes) {
    _imageFile = file;
    _imageBytes = bytes;
    _errorMessage = null;
    notifyListeners();
  }

  void clearImage() {
    _imageFile = null;
    _imageBytes = null;
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> setLocation(
    LatLng location, {
    String? searchingPlaceholder,
  }) async {
    _pickedLocation = location;
    _pickedLocationAddress = searchingPlaceholder ?? 'Searching address...';
    _isLoadingLocation = true;
    notifyListeners();

    try {
      final placemarks = await Geocoding().placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final locality = p.locality ?? p.subLocality ?? p.name ?? '';
        final admin = p.administrativeArea ?? p.country ?? '';
        _pickedLocationAddress = locality.isNotEmpty && admin.isNotEmpty
            ? '$locality, $admin'
            : '${p.name}, ${p.country}';
      } else {
        _pickedLocationAddress =
            'Lat: ${location.latitude.toStringAsFixed(4)}, Lon: ${location.longitude.toStringAsFixed(4)}';
      }
    } catch (_) {
      _pickedLocationAddress =
          'Lat: ${location.latitude.toStringAsFixed(4)}, Lon: ${location.longitude.toStringAsFixed(4)}';
    }

    _isLoadingLocation = false;
    notifyListeners();
  }

  void removeLocation() {
    _pickedLocation = null;
    _pickedLocationAddress = null;
    _isLoadingLocation = false;
    notifyListeners();
  }

  Future<void> pickFromCamera() async {
    try {
      final picked = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
      );
      if (picked != null) {
        final rawBytes = await picked.readAsBytes();
        _imageFile = picked;
        _imageBytes = await _compressImageBytes(rawBytes);
        _errorMessage = null;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to pick image from camera: $e';
      notifyListeners();
    }
  }

  Future<void> pickFromGallery() async {
    try {
      final picked = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
      );
      if (picked != null) {
        final rawBytes = await picked.readAsBytes();
        _imageFile = picked;
        _imageBytes = await _compressImageBytes(rawBytes);
        _errorMessage = null;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to pick image from gallery: $e';
      notifyListeners();
    }
  }

  Future<Uint8List> _compressImageBytes(Uint8List bytes) async {
    const maxSizeBytes = 1000000; // 1 MB
    if (bytes.lengthInBytes <= maxSizeBytes) {
      return bytes;
    }

    final decoded = img.decodeImage(bytes);
    if (decoded == null) {
      return bytes;
    }

    int quality = 90;
    Uint8List compressed = Uint8List.fromList(
      img.encodeJpg(decoded, quality: quality),
    );

    while (compressed.lengthInBytes > maxSizeBytes && quality > 20) {
      quality -= 15;
      compressed = Uint8List.fromList(
        img.encodeJpg(decoded, quality: quality),
      );
    }

    if (compressed.lengthInBytes > maxSizeBytes) {
      final resized = img.copyResize(
        decoded,
        width: (decoded.width * 0.7).round(),
      );
      compressed = Uint8List.fromList(
        img.encodeJpg(resized, quality: 70),
      );
    }

    return compressed;
  }

  Future<bool> uploadStory({
    required String description,
    double? lat,
    double? lon,
  }) async {
    final token = _authPreferences.getToken();
    if (token == null || token.isEmpty) {
      _errorMessage = 'Authentication token not found. Please log in.';
      notifyListeners();
      return false;
    }

    if (_imageBytes == null || _imageFile == null) {
      _errorMessage = 'Please select an image first.';
      notifyListeners();
      return false;
    }

    _isUploading = true;
    _errorMessage = null;
    _uploadSuccess = false;
    notifyListeners();

    try {
      final fileName = _imageFile!.name.isNotEmpty
          ? _imageFile!.name
          : 'story_image_${DateTime.now().millisecondsSinceEpoch}.jpg';

      final finalLat = lat ?? _pickedLocation?.latitude;
      final finalLon = lon ?? _pickedLocation?.longitude;

      await _apiService.uploadStory(
        token: token,
        description: description,
        bytes: _imageBytes!,
        fileName: fileName,
        lat: finalLat,
        lon: finalLon,
      );

      _isUploading = false;
      _uploadSuccess = true;
      notifyListeners();
      return true;
    } catch (e) {
      _isUploading = false;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  void reset() {
    _imageFile = null;
    _imageBytes = null;
    _isUploading = false;
    _errorMessage = null;
    _uploadSuccess = false;
    _pickedLocation = null;
    _pickedLocationAddress = null;
    _isLoadingLocation = false;
    notifyListeners();
  }
}
