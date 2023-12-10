// ignore_for_file: use_build_context_synchronously

import 'package:dermatoloska_mobile/providers/korisnik_provider.dart';
import 'package:dermatoloska_mobile/providers/order_provider.dart';
import 'package:dermatoloska_mobile/screens/payment_screen.dart';
import 'package:dermatoloska_mobile/screens/product_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:dermatoloska_mobile/providers/cart_provider.dart';
import 'package:provider/provider.dart';

import '../models/cart.dart';
import '../utils/util.dart';
import '../widgets/master_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

   double total = 0;
class _CartScreenState extends State<CartScreen> {
   late CartProvider _cartProvider;
   late OrderProvider _orderProvider;
   late KorisniciProvider _korisniciProvider;

@override
  void initState() {
    super.initState();
  }

 @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cartProvider = context.watch<CartProvider>();
    _orderProvider = context.watch<OrderProvider>();
    _korisniciProvider = context.watch<KorisniciProvider>();
  }


  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Cart",
      child: Column(
        children: [
          Expanded(
          child : _cartProvider.cart.items.isNotEmpty
          ? _buildProductCardList()
          : Center(child: Text("Your cart is empty.")),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total : " + total.toString() + " KM",
                  style: TextStyle(fontSize: 18),
                ),
                _buildBuyButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildProductCardList() {
    return Container(
      child: ListView.builder(
        itemCount: _cartProvider.cart.items.length,
        itemBuilder: (context, index) {
          return _buildProductCard(_cartProvider.cart.items[index]);
        },
      ),
    );
  }


Widget _buildProductCard(CartItem item) {
  return Row(
    children: [
      Container(
        width: 100,
        height: 100,
        child: imageFromBase64String(item.product.slika!),
      ),
      SizedBox(width: 10), 
      Expanded(
        child: ListTile(
          title: Text(item.product.naziv ?? ""),
          subtitle: Text(item.product.cijena.toString()),
          trailing: Row(
            mainAxisSize: MainAxisSize.min, 
            children: [
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {
                  _cartProvider.decreaseQuantity(item.product);
                },
              ),
              Text(item.count.toString()),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  _cartProvider.addToCart(item.product);
                },
              ),
            ],
          ),
        ),
      ),
    ],
  );
}


  Future<int> getPatientId() async {
      final pacijenti = await _korisniciProvider.get(filter: {
        'tipKorisnika': 'pacijent',
      });

      final pacijent = pacijenti.result.firstWhere((korisnik) => korisnik.username == Authorization.username);

      return pacijent.korisnikId!;
    }


  

    Future<String> getPatientLastName() async {
      final pacijenti = await _korisniciProvider.get(filter: {
        'tipKorisnika': 'pacijent',
      });

      final pacijent = pacijenti.result.firstWhere((korisnik) => korisnik.username == Authorization.username);

      return pacijent.prezime!;
    }

     Future<String> getPatientAddress() async {
      final pacijenti = await _korisniciProvider.get(filter: {
        'tipKorisnika': 'pacijent',
      });

      final pacijent = pacijenti.result.firstWhere((korisnik) => korisnik.username == Authorization.username);

      return pacijent.adresa!;
    }

    
     Future<String> getPatientPhone() async {
      final pacijenti = await _korisniciProvider.get(filter: {
        'tipKorisnika': 'pacijent',
      });

      final pacijent = pacijenti.result.firstWhere((korisnik) => korisnik.username == Authorization.username);

      return pacijent.telefon!;
    }

   
Widget _buildBuyButton() {
  return TextButton(
    child: Text("Buy"),
    style: TextButton.styleFrom(
      backgroundColor: Color.fromARGB(255, 168, 204, 235),
      foregroundColor: Colors.black,
    ),
    onPressed: _cartProvider.cart.items.isEmpty ? null : () async {
      List<Map<String, dynamic>> items = [];

      _cartProvider.cart.items.forEach((item) {
        items.add(
          {
            "proizvodID": item.product.proizvodID,
            "kolicina": item.count,
          },
        );
      });
      int patientId = await getPatientId();
      

      Map<String, dynamic> order = {
        "items": items,
        "korisnikId": await getPatientId(),
      };

      var response = await _orderProvider.insert(order);
      
      setState(() {});

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => PaymentScreen(
            items: items,
            korisnikId: patientId,
            narudzbaId: response.narudzbaId,
            iznos:response.iznos
          )),
      );
    },
  );
}
}