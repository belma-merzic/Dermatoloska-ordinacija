import 'package:json_annotation/json_annotation.dart';

part 'korisnikInsertRequest.g.dart';

@JsonSerializable()
class KorisnikInsertRequest {
  String? firstName;
  String? lastName;
  String? userName;
  String? email;
  String? phone;
  String? password;
  String? passwordConfirm;
  int? userTypeId;

  KorisnikInsertRequest(this.firstName, this.lastName, this.userName, this.email, this.phone, this.password, this.passwordConfirm, this.userTypeId);

  factory KorisnikInsertRequest.fromJson(Map<String, dynamic> json) => _$KorisnikInsertRequestFromJson(json);

  Map<String, dynamic> toJson() => _$KorisnikInsertRequestToJson(this);
}
