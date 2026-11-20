import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../model/auth_response.dart';
import '../model/story_response.dart';

class ApiService {
  static const String baseUrl = 'https://story-api.dicoding.dev/v1';
  static const Duration requestTimeout = Duration(seconds: 15);

  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  Map<String, String> _headers([String? token]) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<RegisterResponse> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/register');
      final response = await _client
          .post(
            uri,
            headers: _headers(),
            body: jsonEncode({
              'name': name,
              'email': email,
              'password': password,
            }),
          )
          .timeout(requestTimeout);

      final dynamic data = jsonDecode(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        return RegisterResponse.fromJson(data as Map<String, dynamic>);
      } else {
        final message = (data is Map && data['message'] != null)
            ? data['message'].toString()
            : 'Registration failed (${response.statusCode})';
        throw Exception(message);
      }
    } on SocketException {
      throw Exception('No internet connection. Please check your network.');
    } on TimeoutException {
      throw Exception('Connection timed out. Please try again.');
    } on http.ClientException {
      throw Exception('Network connection error. Please try again.');
    } catch (e) {
      rethrow;
    }
  }

  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/login');
      final response = await _client
          .post(
            uri,
            headers: _headers(),
            body: jsonEncode({
              'email': email,
              'password': password,
            }),
          )
          .timeout(requestTimeout);

      final dynamic data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return LoginResponse.fromJson(data as Map<String, dynamic>);
      } else {
        final message = (data is Map && data['message'] != null)
            ? data['message'].toString()
            : 'Login failed (${response.statusCode})';
        throw Exception(message);
      }
    } on SocketException {
      throw Exception('No internet connection. Please check your network.');
    } on TimeoutException {
      throw Exception('Connection timed out. Please try again.');
    } on http.ClientException {
      throw Exception('Network connection error. Please try again.');
    } catch (e) {
      rethrow;
    }
  }

  Future<StoryListResponse> getStories({
    required String token,
    int? page,
    int? size,
    int? location,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (page != null) queryParams['page'] = page.toString();
      if (size != null) queryParams['size'] = size.toString();
      if (location != null) queryParams['location'] = location.toString();

      final uri = Uri.parse('$baseUrl/stories').replace(
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      final response = await _client
          .get(
            uri,
            headers: _headers(token),
          )
          .timeout(requestTimeout);

      final dynamic data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return StoryListResponse.fromJson(data as Map<String, dynamic>);
      } else {
        final message = (data is Map && data['message'] != null)
            ? data['message'].toString()
            : 'Failed to fetch stories (${response.statusCode})';
        throw Exception(message);
      }
    } on SocketException {
      throw Exception('No internet connection. Please check your network.');
    } on TimeoutException {
      throw Exception('Connection timed out. Please try again.');
    } on http.ClientException {
      throw Exception('Network connection error. Please try again.');
    } catch (e) {
      rethrow;
    }
  }

  Future<StoryDetailResponse> getStoryDetail({
    required String token,
    required String id,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/stories/$id');
      final response = await _client
          .get(
            uri,
            headers: _headers(token),
          )
          .timeout(requestTimeout);

      final dynamic data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return StoryDetailResponse.fromJson(data as Map<String, dynamic>);
      } else {
        final message = (data is Map && data['message'] != null)
            ? data['message'].toString()
            : 'Failed to fetch story detail (${response.statusCode})';
        throw Exception(message);
      }
    } on SocketException {
      throw Exception('No internet connection. Please check your network.');
    } on TimeoutException {
      throw Exception('Connection timed out. Please try again.');
    } on http.ClientException {
      throw Exception('Network connection error. Please try again.');
    } catch (e) {
      rethrow;
    }
  }

  Future<UploadResponse> uploadStory({
    required String token,
    required String description,
    required List<int> bytes,
    required String fileName,
    double? lat,
    double? lon,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/stories');
      final request = http.MultipartRequest('POST', uri);

      request.headers['Authorization'] = 'Bearer $token';
      request.fields['description'] = description;
      if (lat != null) request.fields['lat'] = lat.toString();
      if (lon != null) request.fields['lon'] = lon.toString();

      MediaType mediaType;
      final lowerName = fileName.toLowerCase();
      if (lowerName.endsWith('.png')) {
        mediaType = MediaType('image', 'png');
      } else {
        mediaType = MediaType('image', 'jpeg');
      }

      final multipartFile = http.MultipartFile.fromBytes(
        'photo',
        bytes,
        filename: fileName,
        contentType: mediaType,
      );
      request.files.add(multipartFile);

      final streamedResponse =
          await _client.send(request).timeout(requestTimeout);
      final response = await http.Response.fromStream(streamedResponse);

      final dynamic data = jsonDecode(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        return UploadResponse.fromJson(data as Map<String, dynamic>);
      } else {
        final message = (data is Map && data['message'] != null)
            ? data['message'].toString()
            : 'Failed to upload story (${response.statusCode})';
        throw Exception(message);
      }
    } on SocketException {
      throw Exception('No internet connection. Please check your network.');
    } on TimeoutException {
      throw Exception('Connection timed out. Please try again.');
    } on http.ClientException {
      throw Exception('Network connection error. Please try again.');
    } catch (e) {
      rethrow;
    }
  }
}
