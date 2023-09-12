import 'package:dermatoloska_mobile/screens/cart_screen.dart';
import 'package:dermatoloska_mobile/screens/product_list_screen.dart';
import 'package:flutter/material.dart';
import '../screens/favorites_screen.dart';
import '../screens/home_page_screen.dart';
import '../screens/my_profile_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/termin_screen.dart';
import '../screens/zdravstveni_karton_screen.dart';

class MasterScreenWidget extends StatefulWidget {
  Widget? child;
  String? title;
  Widget? title_widget; 
  bool showBackButton;
  MasterScreenWidget({this.child, this.title, this.title_widget, this.showBackButton = true, Key? key}) : super(key:key);

  @override
  State<MasterScreenWidget> createState() => _MasterScreenWidgetState();
}

class _MasterScreenWidgetState extends State<MasterScreenWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( 
        title: widget.title_widget ?? Text(widget.title ?? ""), 
      ),
      drawer: Drawer(
        child: ListView(
          children: [
             ListTile(
              title: Text('My profile'),
              onTap: (){
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MyProfileScreen(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Home page'),
              onTap: (){
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => HomePageScreen(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Products'),
              onTap: (){
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ProductListScreen(),
                  ),
                );
              },
            ),
              ListTile(
              title: Text('Orders'),
              onTap: (){
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const OrdersScreen(),
                  ),
                );
              },
            ),
              ListTile(
              title: Text('Appointments'),
              onTap: (){
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const TerminiScreen(),
                  ),
                );
              },
            ),
              ListTile(
              title: Text('Cart'),
              onTap: (){
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CartScreen(),
                  ),
                );
              },
            ),
             ListTile(
              title: Text('Favorites'),
              onTap: (){
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const FavoritesScreen(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Health Record'),
              onTap: (){
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ZdravstveniKartonScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: widget.child,
    );
  }
}