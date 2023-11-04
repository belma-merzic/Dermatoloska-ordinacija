import 'package:dermatoloska_mobile/models/product.dart';

class Cart {
  List<CartItem> items = [];
  int? korisnikId;

   // Factory method to create a new Cart object
  factory Cart() => Cart._();

  Cart._(); // Private constructor

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'korisnikId': korisnikId,
    };
  }

  Cart.fromJson(Map<String, dynamic> json) {
    items = (json['items'] as List<dynamic>)
        .map((itemData) => CartItem.fromJson(itemData))
        .toList();
    korisnikId = json['korisnikId'];
  }
}

class CartItem {
  CartItem(this.product, this.count);
  late Product product;
  late int count;

   Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(), // Assuming Product has a toJson method
      'count': count,
    };
  }

  CartItem.fromJson(Map<String, dynamic> json) {
    product = Product.fromJson(json['product']);
    count = json['count'] as int;
  }
}