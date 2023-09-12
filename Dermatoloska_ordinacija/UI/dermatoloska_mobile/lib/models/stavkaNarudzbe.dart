import 'package:json_annotation/json_annotation.dart';

part 'stavkaNarudzbe.g.dart';

@JsonSerializable()
class StavkaNarudzbe {
  int? proizvodId;
  int? kolicina;

  StavkaNarudzbe(this.proizvodId, this.kolicina);

  factory StavkaNarudzbe.fromJson(Map<String, dynamic> json) => _$StavkaNarudzbeFromJson(json);

  Map<String, dynamic> toJson() => _$StavkaNarudzbeToJson(this);
}
