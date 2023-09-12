import 'package:json_annotation/json_annotation.dart';


part 'zdravstveniKarton.g.dart';

@JsonSerializable()
class ZdravstveniKarton{
	int? zdravstveniKartonId;
  String? sadrzaj; 
  int? korisnikId;

  ZdravstveniKarton(this.zdravstveniKartonId, this.sadrzaj, this.korisnikId);

  factory ZdravstveniKarton.fromJson(Map<String, dynamic> json) => _$ZdravstveniKartonFromJson(json);
  
  Map<String, dynamic> toJson() => _$ZdravstveniKartonToJson(this);

}