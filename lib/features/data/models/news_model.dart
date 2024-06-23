import 'package:json_annotation/json_annotation.dart';

part 'news_model.g.dart';

@JsonSerializable(explicitToJson: true)
class NewsModel {
  final String title;
  final String imageUrl;

  NewsModel({
    required this.imageUrl,
    required this.title,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) =>
      _$NewsModelFromJson(json);
  Map<String, dynamic> toJson() => _$NewsModelToJson(this);
}
