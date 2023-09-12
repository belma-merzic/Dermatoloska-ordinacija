import 'package:dermatoloska_mobile/providers/base_provider.dart';
import '../models/vrste_proizvoda.dart';

class VrsteProizvodaProvider<T> extends BaseProvider<VrsteProizvoda>{
  VrsteProizvodaProvider(): super("VrsteProizvodum"); 

  @override
  VrsteProizvoda fromJson(data) {
    return VrsteProizvoda.fromJson(data);
  }

}