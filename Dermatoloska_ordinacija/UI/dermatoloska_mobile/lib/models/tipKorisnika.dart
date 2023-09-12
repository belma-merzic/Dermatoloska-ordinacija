import 'package:json_annotation/json_annotation.dart';

part 'tipKorisnika.g.dart';

@JsonSerializable()
class TipKorisnika{
	int? tipKorisnikaId;
  String? tip;

  TipKorisnika(this.tipKorisnikaId, this.tip);

  factory TipKorisnika.fromJson(Map<String, dynamic> json) => _$TipKorisnikaFromJson(json);

  Map<String, dynamic> toJson() => _$TipKorisnikaToJson(this);

}