
import 'package:json_annotation/json_annotation.dart';
import 'korisnik.dart';

part 'zdravstveni_karton.g.dart';

@JsonSerializable()

class ZdravstveniKarton {
  int? zdravstveniKartonId;
  String? sadrzaj;
  int? korisnikId;
  Korisnik? korisnik;

  ZdravstveniKarton(this.zdravstveniKartonId, this.sadrzaj, this.korisnikId, this.korisnik);

  factory ZdravstveniKarton.fromJson(Map<String, dynamic> json) => _$ZdravstveniKartonFromJson(json);

  Map<String, dynamic> toJson() => _$ZdravstveniKartonToJson(this);
}