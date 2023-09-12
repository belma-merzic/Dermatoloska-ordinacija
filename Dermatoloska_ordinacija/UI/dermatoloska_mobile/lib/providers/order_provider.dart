import 'package:dermatoloska_mobile/models/narudzba.dart';
import 'package:dermatoloska_mobile/providers/base_provider.dart';

class OrderProvider extends BaseProvider<Narudzba> {
  OrderProvider() : super("Narudzba");

  @override
  Narudzba fromJson(data) {
    return Narudzba.fromJson(data);
  }
}