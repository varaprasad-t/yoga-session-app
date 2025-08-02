// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assets_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetsModel _$AssetsModelFromJson(Map<String, dynamic> json) => AssetsModel(
  images: Map<String, String>.from(json['images'] as Map),
  audio: Map<String, String>.from(json['audio'] as Map),
);

Map<String, dynamic> _$AssetsModelToJson(AssetsModel instance) =>
    <String, dynamic>{'images': instance.images, 'audio': instance.audio};
