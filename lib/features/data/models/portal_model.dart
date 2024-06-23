import 'package:json_annotation/json_annotation.dart';

part 'portal_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PortalModel {
  final String title;
  final String imageUrl;
  final String? link;

  PortalModel({
    required this.imageUrl,
    required this.title,
    this.link,
  });

  factory PortalModel.fromJson(Map<String, dynamic> json) =>
      _$PortalModelFromJson(json);
  Map<String, dynamic> toJson() => _$PortalModelToJson(this);
}
