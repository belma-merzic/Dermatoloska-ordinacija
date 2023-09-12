import 'package:json_annotation/json_annotation.dart';

part 'termin.g.dart';

@JsonSerializable()
class Termin{
	int? terminId;
  int? korisnikIdDoktor; 
  int? korisnikIdPacijent; 
  DateTime? datum;
  Termin(this.terminId, this.korisnikIdDoktor, this.korisnikIdPacijent, this.datum);

  factory Termin.fromJson(Map<String, dynamic> json) => _$TerminFromJson(json);

  Map<String, dynamic> toJson() => _$TerminToJson(this);

}