import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:dermatoloska_mobile/models/cart.dart';
import 'package:flutter/material.dart';

import '../models/product.dart';

class CartProvider with ChangeNotifier {
  Cart cart = Cart();
  addToCart(Product product) {
    if (findInCart(product) != null) {
      findInCart(product)?.count++;
    } else {
      cart.items.add(CartItem(product, 1));
    }

    notifyListeners();
  }

  removeFromCart(Product product) {
    cart.items
        .removeWhere((item) => item.product.proizvodID == product.proizvodID);
    notifyListeners();
  }

  CartItem? findInCart(Product product) {
    CartItem? item = cart.items.firstWhereOrNull(
        (item) => item.product.proizvodID == product.proizvodID);
    return item;
  }
}