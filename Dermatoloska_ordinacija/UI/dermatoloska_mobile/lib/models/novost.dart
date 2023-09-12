import 'package:json_annotation/json_annotation.dart';

part 'novost.g.dart';

@JsonSerializable()
class Novost{
	int? novostId;
  String? naslov; 
  String? sadrzaj; 
  DateTime? datumObjave; 
  int? korisnikId;

  Novost(this.novostId, this.naslov, this.sadrzaj, this.datumObjave, this.korisnikId);

  factory Novost.fromJson(Map<String, dynamic> json) => _$NovostFromJson(json);

  Map<String, dynamic> toJson() => _$NovostToJson(this);

}