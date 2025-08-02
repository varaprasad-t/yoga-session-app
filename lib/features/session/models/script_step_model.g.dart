// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'script_step_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScriptStepModel _$ScriptStepModelFromJson(Map<String, dynamic> json) =>
    ScriptStepModel(
      text: json['text'] as String,
      startSec: (json['startSec'] as num).toInt(),
      endSec: (json['endSec'] as num).toInt(),
      imageRef: json['imageRef'] as String,
    );

Map<String, dynamic> _$ScriptStepModelToJson(ScriptStepModel instance) =>
    <String, dynamic>{
      'text': instance.text,
      'startSec': instance.startSec,
      'endSec': instance.endSec,
      'imageRef': instance.imageRef,
    };
