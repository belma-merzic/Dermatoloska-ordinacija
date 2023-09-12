import 'package:dermatoloska_mobile/models/product.dart';

class Cart {
  List<CartItem> items = [];
  int? korisnikId;
}

class CartItem {
  CartItem(this.product, this.count);
  late Product product;
  late int count;
}