import 'package:json_annotation/json_annotation.dart';

part 'news_banner_model.g.dart';

@JsonSerializable(explicitToJson: true)
class NewsBannerModel {
  final String imageUrl;
  final String? linkUrl;

  NewsBannerModel({
    required this.imageUrl,
    this.linkUrl,
  });

  factory NewsBannerModel.fromJson(Map<String, dynamic> json) =>
      _$NewsBannerModelFromJson(json);
  Map<String, dynamic> toJson() => _$NewsBannerModelToJson(this);
}
