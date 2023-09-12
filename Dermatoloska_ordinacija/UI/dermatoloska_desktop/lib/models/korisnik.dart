import 'package:dermatoloska_desktop/models/tipKorisnika.dart';
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
  DateTime? datumRodjenja;
  TipKorisnika? tipKorisnika;

  Korisnik(this.korisnikId, this.ime, this.prezime, this.username, this.email, this.telefon, this.adresa, this.datumRodjenja, this.tipKorisnika);

  factory Korisnik.fromJson(Map<String, dynamic> json) => _$KorisnikFromJson(json);

  Map<String, dynamic> toJson() => _$KorisnikToJson(this);
}
