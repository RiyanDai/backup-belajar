// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Story _$StoryFromJson(Map<String, dynamic> json) => Story(
  id: json['id'] as String? ?? '',
  name: json['name'] as String? ?? '',
  description: json['description'] as String? ?? '',
  photoUrl: json['photoUrl'] as String? ?? '',
  createdAt: json['createdAt'] as String? ?? '',
  lat: (json['lat'] as num?)?.toDouble(),
  lon: (json['lon'] as num?)?.toDouble(),
);

Map<String, dynamic> _$StoryToJson(Story instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'photoUrl': instance.photoUrl,
  'createdAt': instance.createdAt,
  'lat': instance.lat,
  'lon': instance.lon,
};

StoryListResponse _$StoryListResponseFromJson(Map<String, dynamic> json) =>
    StoryListResponse(
      error: json['error'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      listStory:
          (json['listStory'] as List<dynamic>?)
              ?.map((e) => Story.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$StoryListResponseToJson(StoryListResponse instance) =>
    <String, dynamic>{
      'error': instance.error,
      'message': instance.message,
      'listStory': instance.listStory,
    };

StoryDetailResponse _$StoryDetailResponseFromJson(Map<String, dynamic> json) =>
    StoryDetailResponse(
      error: json['error'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      story: json['story'] == null
          ? null
          : Story.fromJson(json['story'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StoryDetailResponseToJson(
  StoryDetailResponse instance,
) => <String, dynamic>{
  'error': instance.error,
  'message': instance.message,
  'story': instance.story,
};

UploadResponse _$UploadResponseFromJson(Map<String, dynamic> json) =>
    UploadResponse(
      error: json['error'] as bool? ?? false,
      message: json['message'] as String? ?? '',
    );

Map<String, dynamic> _$UploadResponseToJson(UploadResponse instance) =>
    <String, dynamic>{'error': instance.error, 'message': instance.message};
