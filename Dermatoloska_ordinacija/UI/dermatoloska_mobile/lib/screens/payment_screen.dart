import 'dart:convert';

import 'package:dermatoloska_mobile/models/transakcija.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';
import 'package:provider/provider.dart';

import '../models/TransakcijaUpsertRequest.dart';
import '../providers/product_provider.dart';
import '../providers/transakcija_provider.dart';
import 'package:http/http.dart' as http;


class PaymentScreen extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final int korisnikId;
  final int? narudzbaId; 
  final double? iznos;

  PaymentScreen({required this.items, required this.korisnikId, required this.narudzbaId, required this.iznos, super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late Future<double> total;
  late List<Map<String, dynamic>> itemList = [];
  late ProductProvider _productProvider;
  late TransakcijaProvider _transakcijaProvider;

  @override
  void initState() {
    super.initState();
    _productProvider = Provider.of<ProductProvider>(context, listen: false);
    _transakcijaProvider = Provider.of<TransakcijaProvider>(context, listen: false);
    total = calculateTotalAmount(widget.items);
    _navigateToPaypalCheckout();
  }

void _navigateToPaypalCheckout() async {
  double totalAmount = await total; // Pričekajte izračun ukupnog iznosa
  await buildItemList(widget.items);

  Navigator.of(context).pushReplacement(MaterialPageRoute(
    builder: (BuildContext context) => PaypalCheckout(
      sandboxMode: true,
      clientId: "AWKCtp1D13eNQNe-fd7ujF0i-Cv4zUxhrd2q4D4qMUnKDjHRSVonKq-yHmG8d8nPg3NunJTKvldTDFVY",
      secretKey: "EKL3tGhOxJZYeyufMqNaLrJkHI0Z2Z6qF9FINKp8ht8V8wOLp9bV8mQ9nlA8FoxE0pkFcDif_ifpSv_b",
      returnURL: "return.example.com",
      cancelURL: "cancel.example.com",
      transactions: [
        {
          "amount": {
            "total": totalAmount.toStringAsFixed(2), // Ispravite ovdje da koristite totalAmount
            "currency": "USD",
            "details": {
              "subtotal": totalAmount.toStringAsFixed(2),
              "shipping": '0',
              "shipping_discount": 0
            },
          },
          "description": "The payment transaction description.",
          //"payment_options": {
          //  "allowed_payment_method": "INSTANT_FUNDING_SOURCE"
          //},
          "item_list": {"items": itemList},
        }
      ],
      note: "Contact us for any questions on your order.",
      onSuccess: (Map params) async {
        print("onSuccess: $params");

       Transakcija request = Transakcija(
        null,
        widget.narudzbaId,
        widget.iznos,
        params['data']['id'],
        params['data']['state'],
        );
  await _transakcijaProvider.insert(request);
      },
      onError: (error) {
        print("onError: $error");
        Navigator.pop(context);
      },
      onCancel: () {
        print('Payment canceled');
      },
    ),
  ));
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "PayPal Checkout",
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Center(
      ),
    );
  }

  Future<double> calculateTotalAmount(List<Map<String, dynamic>> items) async {
    double total = 0;
    for (var item in items) {
      int proizvodID = item["proizvodID"];
      int quantity = item["kolicina"];

      // Fetch the product details using GetById
      final product = await _productProvider.getById(proizvodID);

      if (product != null) {
        // Use the fetched product's price for calculation
        double price = product.cijena!;
        total += price * quantity;
      }
    }
    return total;
  }

  Future<void> buildItemList(
    List<Map<String, dynamic>> items,
  ) async {
    itemList.clear();
    print("LALALALALLALALA");
    print(items.length.toString());
    double totalAmount = 0;

    for (var i = 0; i < items.length; i++) {
      print("555555555555555555555555");
      print(widget.items);
      print(items.length);
      if (i < items.length) {
        print("USLOOOO OVDJE");
        int proizvodID = items[i]["proizvodID"];
        final product = await _productProvider.getById(proizvodID);
        if (product != null) {
          String productName = product.naziv!;
          int quantity = items[i]["kolicina"];
          double price = product.cijena!;
          totalAmount += price * quantity;
          itemList.add({
            "name": productName,
            "quantity": quantity,
            "price": price.toStringAsFixed(2),
            "currency": "USD",
          });
          print("LISTAAAAAAAAAAAAAAAAAAAAAA");
          print(itemList);
        }
      } else {
        print("BEBEBEBEBEB");
      }
    }

    print("Total Amount: $totalAmount");
  }
}
