import 'package:json_annotation/json_annotation.dart';

part 'token_model.g.dart';

@JsonSerializable(explicitToJson: true)
class TokenModel {
  final String idToken;
  final String accessToken;
  final String refreshToken;

  TokenModel({
    required this.idToken,
    required this.accessToken,
    required this.refreshToken,
  });

  factory TokenModel.fromJson(Map<String, dynamic> json) =>
      _$TokenModelFromJson(json);
  Map<String, dynamic> toJson() => _$TokenModelToJson(this);
}
