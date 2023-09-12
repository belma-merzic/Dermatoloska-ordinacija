// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'novost.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Novost _$NovostFromJson(Map<String, dynamic> json) => Novost(
      json['novostId'] as int?,
      json['naslov'] as String?,
      json['sadrzaj'] as String?,
      json['datumObjave'] == null
          ? null
          : DateTime.parse(json['datumObjave'] as String),
      json['korisnikId'] as int?,
    );

Map<String, dynamic> _$NovostToJson(Novost instance) => <String, dynamic>{
      'novostId': instance.novostId,
      'naslov': instance.naslov,
      'sadrzaj': instance.sadrzaj,
      'datumObjave': instance.datumObjave?.toIso8601String(),
      'korisnikId': instance.korisnikId,
    };
