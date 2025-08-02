import 'package:json_annotation/json_annotation.dart';
import 'package:yoga_session_app/features/session/models/script_step_model.dart';

part 'segment_model.g.dart';

@JsonSerializable()
class SegmentModel {
  final String type;
  final String name;
  final String audioRef;
  final bool? loopable;
  final int durationSec;

  final List<ScriptStepModel> script;

  SegmentModel({
    required this.type,
    required this.name,
    required this.audioRef,
    required this.durationSec,
    this.loopable,
    required this.script,
  });

  factory SegmentModel.fromJson(Map<String, dynamic> json) =>
      _$SegmentModelFromJson(json);

  Map<String, dynamic> toJson() => _$SegmentModelToJson(this);
}
