
import 'package:json_annotation/json_annotation.dart';

part 'vrste_proizvoda.g.dart';

@JsonSerializable()

class VrsteProizvoda {
  int? vrstaId;
  String? naziv;

  VrsteProizvoda(this.vrstaId, this.naziv);

  factory VrsteProizvoda.fromJson(Map<String, dynamic> json) => _$VrsteProizvodaFromJson(json);

  Map<String, dynamic> toJson() => _$VrsteProizvodaToJson(this);
}