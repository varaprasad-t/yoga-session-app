// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'metadata_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MetadataModel _$MetadataModelFromJson(Map<String, dynamic> json) =>
    MetadataModel(
      id: json['id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      defaultLoopCount: (json['defaultLoopCount'] as num).toInt(),
      tempo: json['tempo'] as String,
    );

Map<String, dynamic> _$MetadataModelToJson(MetadataModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'category': instance.category,
      'defaultLoopCount': instance.defaultLoopCount,
      'tempo': instance.tempo,
    };
