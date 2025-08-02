// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionModel _$SessionModelFromJson(Map<String, dynamic> json) => SessionModel(
  id: json['id'] as String,
  title: json['title'] as String,
  category: json['category'] as String,
  defaultLoopCount: (json['defaultLoopCount'] as num).toInt(),
  tempo: json['tempo'] as String,
  assets: AssetsModel.fromJson(json['assets'] as Map<String, dynamic>),
  sequence: (json['sequence'] as List<dynamic>)
      .map((e) => SegmentModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SessionModelToJson(SessionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'category': instance.category,
      'defaultLoopCount': instance.defaultLoopCount,
      'tempo': instance.tempo,
      'assets': instance.assets,
      'sequence': instance.sequence,
    };
