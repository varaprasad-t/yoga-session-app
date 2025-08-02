import 'package:json_annotation/json_annotation.dart';

part 'script_step_model.g.dart';

@JsonSerializable()
class ScriptStepModel {
  final String text;
  final int startSec;
  final int endSec;
  final String imageRef;

  ScriptStepModel({
    required this.text,
    required this.startSec,
    required this.endSec,
    required this.imageRef,
  });

  factory ScriptStepModel.fromJson(Map<String, dynamic> json) =>
      _$ScriptStepModelFromJson(json);

  Map<String, dynamic> toJson() => _$ScriptStepModelToJson(this);
}
