import 'package:dermatoloska_mobile/models/tipKorisnika.dart';
import 'package:json_annotation/json_annotation.dart';

part 'korisnik.g.dart';

@JsonSerializable()
class Korisnik {
  int? korisnikId;
  String? ime;
  String? prezime;
  String? username;
  String? email;
  String? telefon;
  String? adresa;
  String? slika;
  TipKorisnika? tipKorisnika;

  Korisnik(this.korisnikId, this.ime, this.prezime, this.username, this.email, this.telefon, this.adresa, this.slika, this.tipKorisnika);

  factory Korisnik.fromJson(Map<String, dynamic> json) => _$KorisnikFromJson(json);

  Map<String, dynamic> toJson() => _$KorisnikToJson(this);
}
