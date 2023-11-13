import 'package:dermatoloska_desktop/models/recommendResult.dart';
import 'package:dermatoloska_desktop/providers/korisnik_provider.dart';
import 'package:dermatoloska_desktop/providers/novosti_provider.dart';
import 'package:dermatoloska_desktop/providers/orders_provider.dart';
import 'package:dermatoloska_desktop/providers/product_provider.dart';
import 'package:dermatoloska_desktop/providers/recommend_result_provider.dart';
import 'package:dermatoloska_desktop/providers/stavka_narudzbe_provider.dart';
import 'package:dermatoloska_desktop/providers/termini_provider.dart';
import 'package:dermatoloska_desktop/providers/vrste_proizvoda_provider.dart';
import 'package:dermatoloska_desktop/providers/zdravstveni_karton_provider.dart';
import 'package:dermatoloska_desktop/screens/product_list_screen.dart';
import 'package:dermatoloska_desktop/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Europe/Belgrade')); 
  runApp(MyMaterialApp());
}

class OrderDetailState extends ChangeNotifier {
  Map<String, dynamic>? _orderDetails;

  Map<String, dynamic>? get orderDetails => _orderDetails;

  void updateOrderDetails(Map<String, dynamic> newOrderDetails) {
    _orderDetails = Map<String, dynamic>.from(newOrderDetails);
    notifyListeners();
  }
}

class ProductDetailState extends ChangeNotifier {
  Map<String, dynamic>? _productDetails;

  Map<String, dynamic>? get productDetails => _productDetails;

  void updateProductDetails(Map<String, dynamic> newProductDetails) {
    _productDetails = Map<String, dynamic>.from(newProductDetails);
    notifyListeners();
  }
}

class MyMaterialApp extends StatelessWidget {
  const MyMaterialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => VrsteProizvodaProvider()),
        ChangeNotifierProvider(create: (_) => NovostiProvider()),
        ChangeNotifierProvider(create: (_) => OrdersProvider()),
        ChangeNotifierProvider(create: (_) => OrderDetailState()),
        ChangeNotifierProvider(create: (_) => ProductDetailState()),
        ChangeNotifierProvider(create: (_) => TerminiProvider()),
        ChangeNotifierProvider(create: (_) => KorisniciProvider()),
        ChangeNotifierProvider(create: (_) => ZdravstveniKartonProvider()),
        ChangeNotifierProvider(create: (_) => RecommendResultProvider()),
        ChangeNotifierProvider(create: (_) => StavkaNarudzbeProvider()),
      ],
      child: MaterialApp(
        title: 'RS II Material app',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: LoginPage(),
      ),
    );
  }
}


class LoginPage extends StatelessWidget {
   LoginPage({super.key});

   TextEditingController _usernameController = new TextEditingController();
   TextEditingController _passwordController = new TextEditingController();
   late ProductProvider _productProvider;

  @override
  Widget build(BuildContext context) {
    _productProvider = context.read<ProductProvider>();
    return Scaffold( 
      appBar: AppBar(title: Text("Login"),),
      body: Center( 
        child: Container(
          constraints: BoxConstraints(maxHeight: 400, maxWidth: 400), 
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(children: [
                Image.asset("assets/images/log.png", height: 150,width: 300,), 
                TextField(
                  decoration: InputDecoration(
                    labelText: "Username",
                    prefixIcon: Icon(Icons.email)
                  ),
                  controller: _usernameController,
                ),
                SizedBox(height: 8,),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: Icon(Icons.password)
                  ),
                  controller: _passwordController,
                  obscureText: true,
                ),
                SizedBox(height: 8,),
                ElevatedButton(onPressed: () async{
                  var username = _usernameController.text;
                  var password = _passwordController.text;

                  print("login proceed $username $password");

                  Authorization.username = username;
                  Authorization.password = password;

                  try {
                    await _productProvider.get();
  
                    Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(builder: (context) {
                                  return const ProductListScreen();
                                }));
                  } on Exception catch (e) {
                    showDialog(
                          context: context, 
                          builder: (BuildContext context) => AlertDialog(
                           title: Text("Error"),
                           content: Text(e.toString()),
                           actions: [
                            TextButton(onPressed: ()=> Navigator.pop(context), child: Text("OK"))
                           ],
                          ));
                  }
                }, child: Text("Login"))
              ]),
            ),
          ),
        ),
      ),
    );
  }
}