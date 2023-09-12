// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      json['proizvodID'] as int?,
      json['naziv'] as String?,
      json['sifra'] as String?,
      (json['cijena'] as num?)?.toDouble(),
      json['slika'] as String?,
      json['dostupno'] as bool?,
      json['vrstaId'] as int?,
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'proizvodID': instance.proizvodID,
      'naziv': instance.naziv,
      'sifra': instance.sifra,
      'cijena': instance.cijena,
      'slika': instance.slika,
      'dostupno': instance.dostupno,
      'vrstaId': instance.vrstaId,
    };
