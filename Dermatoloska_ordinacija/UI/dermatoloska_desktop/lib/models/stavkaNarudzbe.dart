import 'package:json_annotation/json_annotation.dart';

part 'stavkaNarudzbe.g.dart';

@JsonSerializable()
class StavkaNarudzbe{
	int? stavkaNarudzbeId;
  int? kolicina; 
  int? proizvodId; 
  int? narudzbaId;

  StavkaNarudzbe(this.stavkaNarudzbeId, this.kolicina, this.proizvodId, this.narudzbaId);

  factory StavkaNarudzbe.fromJson(Map<String, dynamic> json) => _$StavkaNarudzbeFromJson(json);

  Map<String, dynamic> toJson() => _$StavkaNarudzbeToJson(this);

}