import 'package:json_annotation/json_annotation.dart';

part 'story_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class Story {
  @JsonKey(defaultValue: '')
  final String id;
  @JsonKey(defaultValue: '')
  final String name;
  @JsonKey(defaultValue: '')
  final String description;
  @JsonKey(defaultValue: '')
  final String photoUrl;
  @JsonKey(defaultValue: '')
  final String createdAt;
  final double? lat;
  final double? lon;

  const Story({
    required this.id,
    required this.name,
    required this.description,
    required this.photoUrl,
    required this.createdAt,
    this.lat,
    this.lon,
  });

  DateTime get createdAtDate =>
      DateTime.tryParse(createdAt) ?? DateTime.now();

  factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);

  Map<String, dynamic> toJson() => _$StoryToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.none)
class StoryListResponse {
  @JsonKey(defaultValue: false)
  final bool error;
  @JsonKey(defaultValue: '')
  final String message;
  @JsonKey(defaultValue: [])
  final List<Story> listStory;

  const StoryListResponse({
    required this.error,
    required this.message,
    required this.listStory,
  });

  factory StoryListResponse.fromJson(Map<String, dynamic> json) =>
      _$StoryListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StoryListResponseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.none)
class StoryDetailResponse {
  @JsonKey(defaultValue: false)
  final bool error;
  @JsonKey(defaultValue: '')
  final String message;
  final Story? story;

  const StoryDetailResponse({
    required this.error,
    required this.message,
    this.story,
  });

  factory StoryDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$StoryDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StoryDetailResponseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.none)
class UploadResponse {
  @JsonKey(defaultValue: false)
  final bool error;
  @JsonKey(defaultValue: '')
  final String message;

  const UploadResponse({
    required this.error,
    required this.message,
  });

  factory UploadResponse.fromJson(Map<String, dynamic> json) =>
      _$UploadResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UploadResponseToJson(this);
}
