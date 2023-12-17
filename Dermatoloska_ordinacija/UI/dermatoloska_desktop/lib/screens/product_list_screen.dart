import 'dart:convert';
import 'dart:io';

import 'package:dermatoloska_desktop/models/recommendResult.dart';
import 'package:dermatoloska_desktop/providers/product_provider.dart';
import 'package:dermatoloska_desktop/providers/recommend_result_provider.dart';
import 'package:dermatoloska_desktop/screens/product_detail_screen.dart';
import 'package:dermatoloska_desktop/utils/util.dart';
import 'package:dermatoloska_desktop/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../models/product.dart';
import '../models/search_result.dart';
import 'package:provider/provider.dart';



class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late ProductProvider _productProvider;
  late RecommendResultProvider _recommendResultProvider;
  SearchResult<Product>? result;
  bool isLoading = true;
  TextEditingController _ftsController = new TextEditingController();
  TextEditingController _sifraController = new TextEditingController();
  final _formKey = GlobalKey<FormBuilderState>();

  String _selectedSortDirection = 'ascending';

  @override
  void initState() {
    super.initState();
    _productProvider = Provider.of<ProductProvider>(context, listen: false);
    _recommendResultProvider = Provider.of<RecommendResultProvider>(context, listen: false);
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      var data = await _productProvider.get(filter: {
        'fts': _ftsController.text,
        'sifra': _sifraController.text,
      });

      setState(() {
        result = data;
        if (_selectedSortDirection == 'ascending') {
          result?.result.sort((a, b) => a.cijena!.compareTo(b.cijena!));
        } else {
          result?.result.sort((a, b) => b.cijena!.compareTo(a.cijena!));
        }
        isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title_widget: Text("Product list"),
      child: Column(
        children: [
          _buildSearch(),
          _buildDataListView(),
        ],
      ),
    );
  }
  Widget _buildSearch() {
    return FormBuilder(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(labelText: "Product name or product code"),
                controller: _ftsController,
                onChanged: (_) => _fetchProducts(),
              ),
            ),
            SizedBox(width: 8),
            DropdownButton<String>(
              value: _selectedSortDirection,
              onChanged: (newValue) {
                setState(() {
                  _selectedSortDirection = newValue!;
                  _fetchProducts();
                });
              },
              items: <String>['ascending', 'descending']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(width: 8),


            ElevatedButton(
              onPressed: () async {
                try {
                await _recommendResultProvider.trainData();
                } catch (e) {
               String errorMessage = 'An error occurred';

        if (e is Exception && e.toString().isNotEmpty) {
        final regex = RegExp(r'status code: (.+)$');
        final match = regex.firstMatch(e.toString());

        if (match != null) {
          errorMessage = match.group(1)!;
        }
      }

       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          duration: Duration(seconds: 3),
        ),
      );
              }
              },
              child: Text("Train Recomm"),
            ),


             ElevatedButton(
              onPressed: () async {
                try {
                await _recommendResultProvider.deleteData();
                } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                content: Text('Error'),
                duration: Duration(seconds: 2),
                ),
               );
              }
              },
              child: Text("Delete Recomm"),
            ),





            ElevatedButton(
              onPressed: () async {
                var refresh = await 
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ProductDetailScreen(product: null,),
                  ));
                  
                  if(refresh == 'reload'){
                    _fetchProducts();
                  }
              },
              child: Text("Add"),
            ),
          ],
        ),
      ),
    );
  }

 Widget _buildDataListView() {
  if (result?.result == null) {
    return Center(
      child: Text('No products found.'),
    );
  }

  return Expanded(
    child: SingleChildScrollView(
      child: DataTable(
        columns: [
          const DataColumn(
            label: const Expanded(
              child: const Text(
                'Product code',
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
          const DataColumn(
            label: const Expanded(
              child: const Text(
                'Product name',
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
          const DataColumn(
            label: const Expanded(
              child: const Text(
                'Price',
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
          const DataColumn(
            label: const Expanded(
              child: const Text(
                'Image',
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
          const DataColumn(
            label: const Expanded(
              child: const Text(''),
            ),
          ),
        ],
        rows: result!.result.map(
          (Product e) => DataRow(
            onSelectChanged: (selected) async {
              //if (selected == true) {
                var refresh = await
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ProductDetailScreen(product: e),
                  ));

                  if(refresh == 'reload'){
                    _fetchProducts();
                  }
              //}
            },
            cells: [
              DataCell(Text(e.sifra ?? "")),
              DataCell(Text(e.naziv ?? "")),
              DataCell(Text(formatNumber(e.cijena))),
              DataCell(
                e.slika != "" || e.slika == null
                    ? Container(
                        width: 100,
                        height: 100,
                        child: imageFromBase64String(e.slika!),
                      )
                    : imageFromBase64String(base64Encode(File('assets/images/no-image.jpg').readAsBytesSync())),//Text(""),
              ),
              DataCell(
                IconButton(
                  icon: Icon(Icons.delete),
                 onPressed: () {
                      _showDeleteConfirmationDialog(e); 
                    },
                ),
              ),
            ],
          ),
        ).toList(),
      ),
    ),
  );
}

  void _showDeleteConfirmationDialog(Product e) {
       showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this item?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await _deleteProduct(e);
                Navigator.of(context).pop(); 
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

    Future<void> _deleteProduct(Product product) async {
    try {
      await _productProvider.delete(product.proizvodID);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product  deleted successfully.'),
          duration: Duration(seconds: 2),
        ),
      );
      _fetchProducts();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete product.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}