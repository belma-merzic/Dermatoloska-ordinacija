import 'package:dermatoloska_desktop/models/zdravstveni_karton.dart';
import 'package:dermatoloska_desktop/providers/base_provider.dart';

class ZdravstveniKartonProvider<T> extends BaseProvider<ZdravstveniKarton>{
  ZdravstveniKartonProvider(): super("ZdravstveniKarton"); 

  @override
  ZdravstveniKarton fromJson(data) {
    return ZdravstveniKarton.fromJson(data);
  }

}