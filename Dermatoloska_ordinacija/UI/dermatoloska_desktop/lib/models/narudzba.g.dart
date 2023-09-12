// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'narudzba.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Narudzba _$NarudzbaFromJson(Map<String, dynamic> json) => Narudzba(
      json['narudzbaId'] as int?,
      json['brojNarudzbe'] as String?,
      json['status'] as String?,
      json['datum'] == null ? null : DateTime.parse(json['datum'] as String),
      (json['iznos'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$NarudzbaToJson(Narudzba instance) => <String, dynamic>{
      'narudzbaId': instance.narudzbaId,
      'brojNarudzbe': instance.brojNarudzbe,
      'status': instance.status,
      'datum': instance.datum?.toIso8601String(),
      'iznos': instance.iznos,
    };
