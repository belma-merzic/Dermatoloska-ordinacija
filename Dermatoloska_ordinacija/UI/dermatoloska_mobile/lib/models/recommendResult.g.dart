// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommendResult.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecommendResult _$RecommendResultFromJson(Map<String, dynamic> json) =>
    RecommendResult(
      json['proizvodId'] as int?,
      json['drugiProizvodId'] as int?,
      json['treciProizvodId'] as int?,
    )..prviProizvodId = json['prviProizvodId'] as int?;

Map<String, dynamic> _$RecommendResultToJson(RecommendResult instance) =>
    <String, dynamic>{
      'proizvodId': instance.proizvodId,
      'prviProizvodId': instance.prviProizvodId,
      'drugiProizvodId': instance.drugiProizvodId,
      'treciProizvodId': instance.treciProizvodId,
    };
