import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:dermatoloska_desktop/models/recommendResult.dart';
import 'package:dermatoloska_desktop/providers/base_provider.dart';
import 'package:flutter/widgets.dart';
//import 'package:dermatoloska_desktop/models/cart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../models/product.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';


class RecommendResultProvider<T> extends BaseProvider<RecommendResult>{
  RecommendResultProvider(): super("RecommendResult");
 
 @override
  RecommendResult fromJson(data) {
    return RecommendResult.fromJson(data);
  }

   Future trainData() async {
    var url = "http://localhost:5192/RecommendResult/TrainModel";

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.post(uri, headers: headers);
    print(response);
    if(isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      throw  Exception("Unknown error");
    }
  }

  Future deleteData() async {
    var url = "http://localhost:5192/RecommendResult/ClearRecommendation";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.delete(uri, headers: headers);
    
    if(isValidResponse(response)) {
      
    } else {
      throw  Exception("Unknown error");
    }
  }
}
