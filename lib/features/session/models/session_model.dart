import 'package:json_annotation/json_annotation.dart';
import 'segment_model.dart';
import 'assets_model.dart';

part 'session_model.g.dart';

@JsonSerializable()
class SessionModel {
  final String id;
  final String title;
  final String category;
  final int defaultLoopCount;
  final String tempo;
  final AssetsModel assets;
  final List<SegmentModel> sequence;

  SessionModel({
    required this.id,
    required this.title,
    required this.category,
    required this.defaultLoopCount,
    required this.tempo,
    required this.assets,
    required this.sequence,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) =>
      _$SessionModelFromJson(json);

  Map<String, dynamic> toJson() => _$SessionModelToJson(this);
}
