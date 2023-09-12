import 'package:dermatoloska_mobile/providers/base_provider.dart';
import '../models/recenzija.dart';

class RecenzijaProvider<T> extends BaseProvider<Recenzija>{
  RecenzijaProvider(): super("Recenzija"); 
 
 @override
  Recenzija fromJson(data) {
    return Recenzija.fromJson(data);
  }
}