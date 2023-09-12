import 'package:dermatoloska_mobile/providers/base_provider.dart';
import '../models/dojam.dart';

class DojamProvider extends BaseProvider<Dojam> { 

  DojamProvider() : super("Dojam"); 

   @override
  Dojam fromJson(data) {
    return Dojam.fromJson(data);
  }

   Future<bool> exists({required int korisnikId, required int proizvodId}) async {
    final queryParams = {
      'korisnikId': korisnikId.toString(),
      'proizvodId': proizvodId.toString(),
    };

    final result = await get(filter: queryParams);

    return result.result.isNotEmpty;
  }

}
