import 'package:dermatoloska_mobile/models/zdravstveniKarton.dart';
import 'package:dermatoloska_mobile/providers/base_provider.dart';

class ZdravstveniKartonProvider<T> extends BaseProvider<ZdravstveniKarton>{
  ZdravstveniKartonProvider(): super("ZdravstveniKarton"); 
 
 @override
  ZdravstveniKarton fromJson(data) {
    return ZdravstveniKarton.fromJson(data);
  }
}