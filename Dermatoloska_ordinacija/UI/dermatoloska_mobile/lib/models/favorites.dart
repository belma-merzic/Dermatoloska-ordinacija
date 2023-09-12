 import 'package:json_annotation/json_annotation.dart';

part 'favorites.g.dart';

@JsonSerializable()
class Favorites{
	int? omiljeniProizvodId;
  DateTime? datumDodavanja;
	int? proizvodId;
	int? korisnikId;

  Favorites(this.omiljeniProizvodId, this.datumDodavanja, this.proizvodId, this.korisnikId);

  factory Favorites.fromJson(Map<String, dynamic> json) => _$FavoritesFromJson(json);

  Map<String, dynamic> toJson() => _$FavoritesToJson(this);

}