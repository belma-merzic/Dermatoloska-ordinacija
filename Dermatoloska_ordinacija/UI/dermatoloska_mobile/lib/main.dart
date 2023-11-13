import 'package:dermatoloska_mobile/models/recommendResult.dart';
import 'package:dermatoloska_mobile/providers/cart_provider.dart';
import 'package:dermatoloska_mobile/providers/dojam_provider.dart';
import 'package:dermatoloska_mobile/providers/favorites_provider.dart';
import 'package:dermatoloska_mobile/providers/korisnik_provider.dart';
import 'package:dermatoloska_mobile/providers/novosti_provider.dart';
import 'package:dermatoloska_mobile/providers/order_provider.dart';
import 'package:dermatoloska_mobile/providers/product_provider.dart';
import 'package:dermatoloska_mobile/providers/recenzija_provider.dart';
import 'package:dermatoloska_mobile/providers/recommend_result_provider.dart';
import 'package:dermatoloska_mobile/providers/termini_provider.dart';
import 'package:dermatoloska_mobile/providers/transakcija_provider.dart';
import 'package:dermatoloska_mobile/providers/vrste_proizvoda_provider.dart';
import 'package:dermatoloska_mobile/providers/zdravstveni_karton_provider.dart';
import 'package:dermatoloska_mobile/screens/product_list_screen.dart';
import 'package:dermatoloska_mobile/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyMaterialApp());
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
        ChangeNotifierProvider(create: (_) => NovostiProvider()),
        ChangeNotifierProvider(create: (_) => TerminiProvider()),
        ChangeNotifierProvider(create: (_) => KorisniciProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => ProductDetailState()),
        ChangeNotifierProvider(create: (_) => VrsteProizvodaProvider()),
        ChangeNotifierProvider(create: (_) => DojamProvider()),
        ChangeNotifierProvider(create: (_) => RecenzijaProvider()),
        ChangeNotifierProvider(create: (_) => ZdravstveniKartonProvider()),
        ChangeNotifierProvider(create: (_) => TransakcijaProvider()),
        ChangeNotifierProvider(create: (_) => RecommendResultProvider()),
      ],
      child: MaterialApp(
        title: 'RS II Material app',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: Welcome(),
      ),
    );
}
}

class Welcome extends StatelessWidget {
  const Welcome({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; 
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text('WELCOME TO DERMAGLOW', style: TextStyle(fontFamily: 'YourCustomFont', fontWeight: FontWeight.bold, fontSize: 24, color: Colors.blue,),),
              ),

              SizedBox(height: size.height * 0.02),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  child: Text("LOGIN"),
                  ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignUpPage()));
                  },
                  child: Text("SIGN UP"),
                  )
            ],
          ),
        ),
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
  
                    Navigator.of(context).push( 
                    MaterialPageRoute(builder: (context) => const ProductListScreen()
                    ),
                    );
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

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

   TextEditingController _firstnameController=new TextEditingController();
  TextEditingController _lastnameController=new TextEditingController();
  TextEditingController _usernameController=new TextEditingController();
  TextEditingController _emailController=new TextEditingController();
  TextEditingController _phoneController=new TextEditingController();
  TextEditingController _addressController=new TextEditingController();
  TextEditingController _genderController=new TextEditingController();
  TextEditingController _passwordController=new TextEditingController();
  TextEditingController _confirmPasswordController=new TextEditingController();

  late KorisniciProvider _korisniciProvider;


  @override
  Widget build(BuildContext context) {
        _korisniciProvider = Provider.of<KorisniciProvider>(context, listen: false);


    return Scaffold(
      appBar: AppBar(title: Text("Sign Up")),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxHeight: 600, maxWidth: 400),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
              Image.asset("assets/images/log.png", height: 150,width: 300,),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "First Name",
                      prefixIcon: Icon(Icons.person),
                    ),
                    controller: _firstnameController,
                  ),
                  SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Last Name",
                      prefixIcon: Icon(Icons.person),
                    ),
                    controller: _lastnameController,
                  ),
                  SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Username",
                      prefixIcon: Icon(Icons.account_circle),
                    ),
                    controller: _usernameController,
                  ),
                  SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon: Icon(Icons.email),
                    ),
                    controller: _emailController,
                  ),
                  SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Phone",
                      prefixIcon: Icon(Icons.phone),
                    ),
                    controller: _phoneController,
                  ),
                  SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Address",
                      prefixIcon: Icon(Icons.location_on),
                    ),
                    controller: _addressController,
                  ),
                  SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Select gender: 1-MALE, 2-FEMALE",
                      prefixIcon: Icon(Icons.transgender),
                    ),
                    controller: _genderController,
                  ),
                  SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: Icon(Icons.lock),
                    ),
                    controller: _passwordController,
                     obscureText: true,
                  ),
                  SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Confirm Password",
                      prefixIcon: Icon(Icons.lock),
                    ),
                    controller: _confirmPasswordController,
                     obscureText: true,
                  ),
                  SizedBox(height: 8),
                 ElevatedButton(
              onPressed: () async {
                if (_firstnameController.text.isEmpty ||
                    _lastnameController.text.isEmpty ||
                    _emailController.text.isEmpty ||
                    _phoneController.text.isEmpty ||
                    _addressController.text.isEmpty ||
                    _usernameController.text.isEmpty ||
                    _passwordController.text.isEmpty ||
                    _confirmPasswordController.text.isEmpty ||
                    _genderController.text.isEmpty) {
                  showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text("Error"),
                            content: Text("All fields are required!"),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context), child: Text("OK")),
                            ],
                          ),
                        );
                }else if(_genderController.text.toUpperCase() != '1' && _genderController.text.toUpperCase() != '2')
                     showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text("Error"),
                            content: Text("Please enter '1' or '2' for gender."),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context), child: Text("OK")),
                            ],
                          ),
                        );
                 else if (_passwordController.text !=_confirmPasswordController.text) {
                  showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text("Error"),
                            content: Text("Password needs to match the confirmation password."),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context), child: Text("OK")),
                            ],
                          ),
                        );
                } else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_emailController.text)) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text("Error"),
                            content: Text("Incorrect email format."),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context), child: Text("OK")),
                            ],
                          ),
                        );
                } else if (!RegExp(r"^(?:\+?\d{10}|\d{9})$").hasMatch(_phoneController.text)) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text("Error"),
                            content: Text("Incorrect phone format."),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context), child: Text("OK")),
                            ],
                          ),
                        );
                } else {
                  Map order = {
                    "ime": _firstnameController.text,
                    "prezime": _lastnameController.text,
                    "username": _usernameController.text,
                    "email": _emailController.text,
                    "telefon": _phoneController.text,
                    "adresa": _addressController.text,
                    "password": _passwordController.text,
                    "passwordPotvrda": _confirmPasswordController.text,
                    "spolId": _genderController.text,
                    "tipKorisnikaId": 1
                  };

                  var x = await _korisniciProvider.SignUp(order);
                  print(x);
                  if (x != null) {
                    Authorization.username = _usernameController.text;
                    Authorization.password = _passwordController.text;

                    Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const ProductListScreen()
                    ),
                    );
                  }
                }
              },
              child: Center(child: Text("Sign up")),
            ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}