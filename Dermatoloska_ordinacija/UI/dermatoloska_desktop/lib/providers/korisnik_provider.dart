import 'package:dermatoloska_desktop/providers/base_provider.dart';
import '../models/korisnik.dart';

class KorisniciProvider extends BaseProvider<Korisnik> { 

  KorisniciProvider() : super("Korisnici"); 

   @override
  Korisnik fromJson(data) {
    return Korisnik.fromJson(data);
  }
}
