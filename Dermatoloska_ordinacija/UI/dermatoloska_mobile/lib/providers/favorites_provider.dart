import 'dart:convert';

import 'package:dermatoloska_mobile/providers/base_provider.dart';
import 'package:http/http.dart' as http;
import '../models/favorites.dart';

class FavoritesProvider extends BaseProvider<Favorites> { 

   String? _mainBaseUrl;
   String _endpoint = "OmiljeniProizvodi";///////////////////////////////////////////////////////////////////

  FavoritesProvider() : super("OmiljeniProizvodi"){
    _mainBaseUrl = const String.fromEnvironment("mainBaseUrl", defaultValue: "http://10.0.2.2:7005/"); /////////////////////////////////////////////////////////////////////
  }


  Future<bool> exists(int productId) async {
    final favorites = await get(filter: {"proizvodId": productId});
    return favorites.count > 0;
  }

   @override
  Favorites fromJson(data) {
    return Favorites.fromJson(data);
  }

///////////////////////////////////////////////////////////////////

    Future<dynamic> sendRabbit(dynamic object) async{
     var url = "$_mainBaseUrl$_endpoint";
    
    var uri = Uri.parse(url);
    var jsonRequest = jsonEncode(object);
      var headers = {"Content-Type": "application/json"};

    var response = await  http.post(uri, headers: headers, body:jsonRequest );
    
    if(isValidResponse(response)) {
      var data = jsonDecode(response.body);
      
      return data;
    } else {
      throw  Exception("Unknown error");
    }
  }
///////////////////////////////////////////////////////////////////
}
