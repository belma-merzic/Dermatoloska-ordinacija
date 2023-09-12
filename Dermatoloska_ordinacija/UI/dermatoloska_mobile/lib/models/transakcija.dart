import 'package:json_annotation/json_annotation.dart';

part 'transakcija.g.dart';

@JsonSerializable()
class Transakcija{
	int? transakcijaId;
  int? narudzbaId; 
  double? iznos;
  String? transId;
  String? statusTransakcije;

  Transakcija(this.transakcijaId, this.narudzbaId, this.iznos, this.transId, this.statusTransakcije);

  factory Transakcija.fromJson(Map<String, dynamic> json) => _$TransakcijaFromJson(json);

  Map<String, dynamic> toJson() => _$TransakcijaToJson(this);

}