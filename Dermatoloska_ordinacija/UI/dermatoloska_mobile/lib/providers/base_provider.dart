import 'dart:convert';
import 'package:dermatoloska_mobile/models/search_result.dart';
import 'package:dermatoloska_mobile/utils/util.dart';
import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'dart:async';

abstract class BaseProvider<T> with ChangeNotifier{ 
  static String? _baseUrl;
  String _endpoint = "";

   HttpClient client = new HttpClient();
  IOClient? http;

  BaseProvider(String endpoint){
   _endpoint = endpoint;
   _baseUrl = const String.fromEnvironment("baseUrl", defaultValue: "http://10.0.2.2:5192/");

   client.badCertificateCallback = (cert, host, port) => true;
    http = IOClient(client);
  } 

 Future<SearchResult<T>> get({dynamic filter}) async{ 
  var url = "$_baseUrl$_endpoint";

  if(filter != null){
    var queryString = getQueryString(filter);
    url = "$url?$queryString";
  }
  
  var uri = Uri.parse(url);
  var headers = createHeaders(); 

  var response = await http!.get(uri, headers: headers);

  if(isValidResponse(response))
  {
      print("response: ${response.request}");
      var data = jsonDecode(response.body); 
      
      var result = SearchResult<T>();

      result.count = data['count']; 

      for(var item in data['result']){ 
        result.result.add(fromJson(item));
      }
      return result;
   }else{
    throw new Exception("Unknown error");
   }
  }

Future<T> getById(int id) async {
  var url = "$_baseUrl$_endpoint/$id";
  var uri = Uri.parse(url);
  var headers = createHeaders();

  var response = await http!.get(uri, headers: headers);

  if (isValidResponse(response)) {
    print("response: ${response.request}");
    var data = jsonDecode(response.body);
    return fromJson(data);
  } else {
    throw new Exception("Failed to get item with ID $id");
  }
 }

 Future<T> insert(dynamic request) async{
    var url = "$_baseUrl$_endpoint";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var jsonRequest = jsonEncode(request); 
    var response = await http!.post(uri, headers: headers, body: jsonRequest);

    if(isValidResponse(response)){
      print("response: ${response.request}");
      var data = jsonDecode(response.body); 
      return fromJson(data);
    }else{
      throw new Exception("Unknown error");
    }
 }

  Future<T> update(int id, [dynamic request]) async{
    var url = "$_baseUrl$_endpoint/$id";
    print(url);
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var jsonRequest = jsonEncode(request);
    var response = await http!.put(uri, headers: headers, body: jsonRequest);

    if(isValidResponse(response)){
      print("response: ${response.request}");
      var data = jsonDecode(response.body); 
      return fromJson(data);
    }else{
    throw new Exception("Unknown error");
    }
  }

 Future<T> delete(int? id) async{
  var url ="$_baseUrl$_endpoint/$id";
  var uri = Uri.parse(url);
  var headers = createHeaders();

  var response = await http!.delete(uri,headers: headers);

  if(isValidResponse(response)){
    print("response: ${response.request}");
    var data = jsonDecode(response.body);
    return fromJson(data);
  }else{
    throw new Exception("Failed to delete product with ID $id");
  }
 }

 T fromJson(data){
  throw new Exception("Method not implemented");
 }

 bool isValidResponse(Response response)
 {
  if(response.statusCode < 299 ){
    return true;
  }
  else if(response.statusCode == 401){
    throw new Exception("Unauthorized");
  }
  else{
    print(response.body);
    throw new Exception("Something bad happened please try again");
  }
 }

   Future<List<T>> recom(int id, [dynamic search]) async {
    var url = Uri.parse("$_baseUrl$_endpoint/$id/Recommend");
    Map<String, String> headers = createHeaders();
    var response = await http!.get(url, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
    print(data);
      return data.map((x) => fromJson(x)).cast<T>().toList();
    } else {
      throw Exception("Exception... handle this gracefully");
    }
  }

  Map<String, String> createHeaders(){
    String username = Authorization.username ?? "";
    String password = Authorization.password ?? "";

    print("passed creds: $username, $password");

    String basicAuth = "Basic ${base64Encode(utf8.encode('$username:$password'))}";

    var headers = {
      "Content-Type": "application/json",
      "Authorization": basicAuth
    };
    return headers;
  }

   String getQueryString(Map params, 
      {String prefix = '&', bool inRecursion = false}) {
    String query = '';
    params.forEach((key, value) {
      if (inRecursion) {
        if (key is int) {
          key = '[$key]';
        } else if (value is List || value is Map) {
          key = '.$key';
        } else {
          key = '.$key';
        }
      }
      if (value is String || value is int || value is double || value is bool) {
        var encoded = value;
        if (value is String) {
          encoded = Uri.encodeComponent(value);
        }
        query += '$prefix$key=$encoded';
      } else if (value is DateTime) {
        query += '$prefix$key=${(value as DateTime).toIso8601String()}';
      } else if (value is List || value is Map) {
        if (value is List) value = value.asMap();
        value.forEach((k, v) {
          query +=
              getQueryString({k: v}, prefix: '$prefix$key', inRecursion: true);
        });
      }
    });
    return query;
  }


  Future<dynamic> SignUp(dynamic body) async {
    var url = "$_baseUrl$_endpoint";
    var uri = Uri.parse(url);
    var jsonRequest = jsonEncode(body);

    var response = await http!.post(uri,
        headers: {'Content-type': 'application/json'}, body: jsonRequest);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data) as T;
    } else {
      return null;
    }
  }
}