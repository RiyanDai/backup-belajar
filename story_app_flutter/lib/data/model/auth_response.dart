import 'package:json_annotation/json_annotation.dart';

part 'auth_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class RegisterResponse {
  @JsonKey(defaultValue: false)
  final bool error;
  @JsonKey(defaultValue: '')
  final String message;

  const RegisterResponse({
    required this.error,
    required this.message,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterResponseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.none)
class LoginResult {
  @JsonKey(defaultValue: '')
  final String userId;
  @JsonKey(defaultValue: '')
  final String name;
  @JsonKey(defaultValue: '')
  final String token;

  const LoginResult({
    required this.userId,
    required this.name,
    required this.token,
  });

  factory LoginResult.fromJson(Map<String, dynamic> json) =>
      _$LoginResultFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResultToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.none)
class LoginResponse {
  @JsonKey(defaultValue: false)
  final bool error;
  @JsonKey(defaultValue: '')
  final String message;
  final LoginResult? loginResult;

  const LoginResponse({
    required this.error,
    required this.message,
    this.loginResult,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
