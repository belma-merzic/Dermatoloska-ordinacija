import 'package:dermatoloska_desktop/providers/base_provider.dart';
import '../models/narudzba.dart';

class OrdersProvider<T> extends BaseProvider<Narudzba>{
  OrdersProvider(): super("Narudzba"); 

  @override
  Narudzba fromJson(data) {
    return Narudzba.fromJson(data);
  }

}