import 'package:json_annotation/json_annotation.dart';

part 'metadata_model.g.dart';

@JsonSerializable()
class MetadataModel {
  final String id;
  final String title;
  final String category;
  final int defaultLoopCount;
  final String tempo;

  MetadataModel({
    required this.id,
    required this.title,
    required this.category,
    required this.defaultLoopCount,
    required this.tempo,
  });

  factory MetadataModel.fromJson(Map<String, dynamic> json) =>
      _$MetadataModelFromJson(json);

  Map<String, dynamic> toJson() => _$MetadataModelToJson(this);
}
