import 'package:dermatoloska_desktop/providers/base_provider.dart';
import '../models/stavkaNarudzbe.dart';

class StavkaNarudzbeProvider<T> extends BaseProvider<StavkaNarudzbe>{
  StavkaNarudzbeProvider(): super("StavkaNarudzbe");  
 
 @override
  StavkaNarudzbe fromJson(data) {
    return StavkaNarudzbe.fromJson(data);
  }


Future<List<StavkaNarudzbe>> getStavkeNarudzbeByNarudzbaId(int narudzbaId) async {
  try {
    var filter = {"NarudzbaId": narudzbaId}; // Create a filter object based on NarudzbaId
    var result = await get(filter: filter);
    print(result.result);
    return result.result;

  } catch (e) {
    throw Exception('Error getting StavkeNarudzbe by NarudzbaId: $e');
  }
}



  
}