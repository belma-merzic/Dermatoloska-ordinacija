import 'package:dermatoloska_desktop/providers/base_provider.dart';
import '../models/product.dart';

class ProductProvider<T> extends BaseProvider<Product>{
  ProductProvider(): super("Proizvodi");
 
 @override
  Product fromJson(data) {
    return Product.fromJson(data);
  }
}