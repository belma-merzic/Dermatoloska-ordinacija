import 'package:json_annotation/json_annotation.dart';

part 'dojam.g.dart';

@JsonSerializable()
class Dojam {
  bool? isLiked;
  int? korisnikId;
  int? proizvodId;

  Dojam(this.isLiked, this.korisnikId, this.proizvodId);

  factory Dojam.fromJson(Map<String, dynamic> json) => _$DojamFromJson(json);

  Map<String, dynamic> toJson() => _$DojamToJson(this);
}
