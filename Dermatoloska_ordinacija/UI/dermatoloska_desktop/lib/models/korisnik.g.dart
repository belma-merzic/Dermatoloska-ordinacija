// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'korisnik.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Korisnik _$KorisnikFromJson(Map<String, dynamic> json) => Korisnik(
      json['korisnikId'] as int?,
      json['ime'] as String?,
      json['prezime'] as String?,
      json['username'] as String?,
      json['email'] as String?,
      json['telefon'] as String?,
      json['adresa'] as String?,
      json['datumRodjenja'] == null
          ? null
          : DateTime.parse(json['datumRodjenja'] as String),
      json['tipKorisnika'] == null
          ? null
          : TipKorisnika.fromJson(json['tipKorisnika'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$KorisnikToJson(Korisnik instance) => <String, dynamic>{
      'korisnikId': instance.korisnikId,
      'ime': instance.ime,
      'prezime': instance.prezime,
      'username': instance.username,
      'email': instance.email,
      'telefon': instance.telefon,
      'adresa': instance.adresa,
      'datumRodjenja': instance.datumRodjenja?.toIso8601String(),
      'tipKorisnika': instance.tipKorisnika,
    };
