import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import '../common/result_state.dart';
import '../data/api/api_service.dart';
import '../data/model/story_response.dart';
import '../data/preferences/auth_preferences.dart';

class StoryProvider extends ChangeNotifier {
  final ApiService _apiService;
  final AuthPreferences _authPreferences;

  static const int _pageSize = 10;

  ResultState _storiesState = ResultState.initial;
  List<Story> _stories = [];
  String? _storiesError;
  int _currentPage = 1;
  bool _hasMorePages = true;
  bool _isFetchingMore = false;

  ResultState _detailState = ResultState.initial;
  Story? _storyDetail;
  String? _detailError;
  String? _storyDetailAddress;
  bool _isLoadingAddress = false;

  StoryProvider(this._apiService, this._authPreferences);

  ResultState get storiesState => _storiesState;
  List<Story> get stories => _stories;
  String? get storiesError => _storiesError;
  bool get hasMorePages => _hasMorePages;
  bool get isFetchingMore => _isFetchingMore;

  ResultState get detailState => _detailState;
  Story? get storyDetail => _storyDetail;
  String? get detailError => _detailError;
  String? get storyDetailAddress => _storyDetailAddress;
  bool get isLoadingAddress => _isLoadingAddress;

  /// Fetch the first page of stories (refresh).
  Future<void> fetchAllStories() async {
    final token = _authPreferences.getToken();
    if (token == null || token.isEmpty) {
      _storiesState = ResultState.error;
      _storiesError = 'No authentication token found. Please login.';
      notifyListeners();
      return;
    }

    _storiesState = ResultState.loading;
    _storiesError = null;
    _currentPage = 1;
    _hasMorePages = true;
    _isFetchingMore = false;
    _stories = [];
    notifyListeners();

    try {
      final response = await _apiService.getStories(
        token: token,
        page: _currentPage,
        size: _pageSize,
      );

      _stories = response.listStory;
      _hasMorePages = response.listStory.length >= _pageSize;

      if (_stories.isEmpty) {
        _storiesState = ResultState.noData;
      } else {
        _storiesState = ResultState.hasData;
      }
      notifyListeners();
    } catch (e) {
      _storiesState = ResultState.error;
      _storiesError = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
    }
  }

  /// Fetch the next page of stories (infinite scroll).
  Future<void> fetchMoreStories() async {
    if (!_hasMorePages || _isFetchingMore) return;

    final token = _authPreferences.getToken();
    if (token == null || token.isEmpty) return;

    _isFetchingMore = true;
    notifyListeners();

    try {
      _currentPage++;
      final response = await _apiService.getStories(
        token: token,
        page: _currentPage,
        size: _pageSize,
      );

      _stories = [..._stories, ...response.listStory];
      _hasMorePages = response.listStory.length >= _pageSize;
      _isFetchingMore = false;
      _storiesState = ResultState.hasData;
      notifyListeners();
    } catch (e) {
      _currentPage--;
      _isFetchingMore = false;
      notifyListeners();
    }
  }

  Future<void> fetchStoryDetail(String id) async {
    final token = _authPreferences.getToken();
    if (token == null || token.isEmpty) {
      _detailState = ResultState.error;
      _detailError = 'No authentication token found. Please login.';
      notifyListeners();
      return;
    }

    _detailState = ResultState.loading;
    _detailError = null;
    _storyDetail = null;
    _storyDetailAddress = null;
    _isLoadingAddress = false;
    notifyListeners();

    try {
      final response = await _apiService.getStoryDetail(token: token, id: id);
      if (response.story != null) {
        _storyDetail = response.story;
        _detailState = ResultState.hasData;
        notifyListeners();

        if (_storyDetail!.lat != null && _storyDetail!.lon != null) {
          _resolveDetailAddress(_storyDetail!.lat!, _storyDetail!.lon!);
        }
      } else {
        _detailState = ResultState.noData;
        notifyListeners();
      }
    } catch (e) {
      _detailState = ResultState.error;
      _detailError = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
    }
  }

  Future<void> _resolveDetailAddress(double lat, double lon) async {
    _isLoadingAddress = true;
    notifyListeners();

    try {
      final placemarks = await Geocoding().placemarkFromCoordinates(lat, lon);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final parts = <String>[
          if (place.street != null && place.street!.isNotEmpty) place.street!,
          if (place.subLocality != null && place.subLocality!.isNotEmpty)
            place.subLocality!,
          if (place.locality != null && place.locality!.isNotEmpty)
            place.locality!,
          if (place.administrativeArea != null &&
              place.administrativeArea!.isNotEmpty)
            place.administrativeArea!,
          if (place.country != null && place.country!.isNotEmpty)
            place.country!,
        ];
        _storyDetailAddress = parts.isNotEmpty
            ? parts.join(', ')
            : '${place.name}, ${place.country}';
      } else {
        _storyDetailAddress =
            'Lat: ${lat.toStringAsFixed(4)}, Lon: ${lon.toStringAsFixed(4)}';
      }
    } catch (_) {
      _storyDetailAddress =
          'Lat: ${lat.toStringAsFixed(4)}, Lon: ${lon.toStringAsFixed(4)}';
    } finally {
      _isLoadingAddress = false;
      notifyListeners();
    }
  }
}
