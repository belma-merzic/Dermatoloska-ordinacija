// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transakcija.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transakcija _$TransakcijaFromJson(Map<String, dynamic> json) => Transakcija(
      json['transakcijaId'] as int?,
      json['narudzbaId'] as int?,
      (json['iznos'] as num?)?.toDouble(),
      json['transId'] as String?,
      json['statusTransakcije'] as String?,
    );

Map<String, dynamic> _$TransakcijaToJson(Transakcija instance) =>
    <String, dynamic>{
      'transakcijaId': instance.transakcijaId,
      'narudzbaId': instance.narudzbaId,
      'iznos': instance.iznos,
      'transId': instance.transId,
      'statusTransakcije': instance.statusTransakcije,
    };
