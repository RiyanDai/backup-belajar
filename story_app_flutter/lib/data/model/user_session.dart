import 'package:json_annotation/json_annotation.dart';

part 'user_session.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class UserSession {
  @JsonKey(defaultValue: '')
  final String userId;
  @JsonKey(defaultValue: '')
  final String name;
  @JsonKey(defaultValue: '')
  final String token;

  const UserSession({
    required this.userId,
    required this.name,
    required this.token,
  });

  factory UserSession.fromJson(Map<String, dynamic> json) =>
      _$UserSessionFromJson(json);

  Map<String, dynamic> toJson() => _$UserSessionToJson(this);
}
