import 'package:json_annotation/json_annotation.dart';

part 'narudzba.g.dart';

@JsonSerializable()
class Narudzba{
	int? narudzbaId;
  String? brojNarudzbe; 
  String? status; 
  DateTime? datum; 
  double? iznos;

  Narudzba(this.narudzbaId, this.brojNarudzbe, this.status, this.datum, this.iznos);

  factory Narudzba.fromJson(Map<String, dynamic> json) => _$NarudzbaFromJson(json);

  Map<String, dynamic> toJson() => _$NarudzbaToJson(this);

}