import 'package:dermatoloska_desktop/screens/product_list_screen.dart';
import 'package:dermatoloska_desktop/screens/home_page_screen.dart';
import 'package:dermatoloska_desktop/screens/termin_screen.dart';
import 'package:flutter/material.dart';

import '../screens/izvjestaj_screen.dart';
import '../screens/orders_screen.dart';

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
              title: Text('Reports'),
              onTap: (){
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const IzvjestajScreen(),
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