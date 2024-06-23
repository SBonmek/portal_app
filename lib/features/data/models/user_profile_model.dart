import 'package:json_annotation/json_annotation.dart';

part 'user_profile_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UserProfileModel {
  @JsonKey(name: "given_name")
  final String givenName;
  @JsonKey(name: "family_name")
  final String familyName;
  final String email;
  @JsonKey(name: "profile_image")
  final String profileImage;

  UserProfileModel({
    required this.givenName,
    required this.familyName,
    required this.email,
    required this.profileImage,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserProfileModelToJson(this);
}
