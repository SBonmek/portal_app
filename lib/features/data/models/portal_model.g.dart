// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portal_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PortalModel _$PortalModelFromJson(Map<String, dynamic> json) => PortalModel(
      imageUrl: json['imageUrl'] as String,
      title: json['title'] as String,
      link: json['link'] as String?,
    );

Map<String, dynamic> _$PortalModelToJson(PortalModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'imageUrl': instance.imageUrl,
      'link': instance.link,
    };
