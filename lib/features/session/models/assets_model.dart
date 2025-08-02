import 'package:json_annotation/json_annotation.dart';

part 'assets_model.g.dart';

@JsonSerializable()
class AssetsModel {
  final Map<String, String> images;
  final Map<String, String> audio;

  AssetsModel({required this.images, required this.audio});

  factory AssetsModel.fromJson(Map<String, dynamic> json) =>
      _$AssetsModelFromJson(json);

  Map<String, dynamic> toJson() => _$AssetsModelToJson(this);
}
