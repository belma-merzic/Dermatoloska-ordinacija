import 'package:dermatoloska_mobile/providers/base_provider.dart';
import '../models/korisnik.dart';
import '../utils/util.dart';

class KorisniciProvider extends BaseProvider<Korisnik> { 

  KorisniciProvider() : super("Korisnici"); 

   @override
  Korisnik fromJson(data) {
    return Korisnik.fromJson(data);
  }

   void logout() {
    Authorization.username = null;
    Authorization.password = null;
  }
}
