// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorites.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Favorites _$FavoritesFromJson(Map<String, dynamic> json) => Favorites(
      json['omiljeniProizvodId'] as int?,
      json['datumDodavanja'] == null
          ? null
          : DateTime.parse(json['datumDodavanja'] as String),
      json['proizvodId'] as int?,
      json['korisnikId'] as int?,
    );

Map<String, dynamic> _$FavoritesToJson(Favorites instance) => <String, dynamic>{
      'omiljeniProizvodId': instance.omiljeniProizvodId,
      'datumDodavanja': instance.datumDodavanja?.toIso8601String(),
      'proizvodId': instance.proizvodId,
      'korisnikId': instance.korisnikId,
    };
