// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'segment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SegmentModel _$SegmentModelFromJson(Map<String, dynamic> json) => SegmentModel(
  type: json['type'] as String,
  name: json['name'] as String,
  audioRef: json['audioRef'] as String,
  durationSec: (json['durationSec'] as num).toInt(),
  loopable: json['loopable'] as bool?,
  script: (json['script'] as List<dynamic>)
      .map((e) => ScriptStepModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SegmentModelToJson(SegmentModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'name': instance.name,
      'audioRef': instance.audioRef,
      'loopable': instance.loopable,
      'durationSec': instance.durationSec,
      'script': instance.script,
    };
