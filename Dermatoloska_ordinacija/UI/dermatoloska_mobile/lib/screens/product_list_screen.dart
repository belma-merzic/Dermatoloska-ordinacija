import 'package:dermatoloska_mobile/providers/korisnik_provider.dart';
import 'package:dermatoloska_mobile/providers/product_provider.dart';
import 'package:dermatoloska_mobile/screens/product_detail_screen.dart';
import 'package:dermatoloska_mobile/utils/util.dart';
import 'package:dermatoloska_mobile/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../models/product.dart';
import '../models/search_result.dart';
import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';
import 'package:provider/provider.dart';


import '../providers/recommend_result_provider.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late ProductProvider _productProvider;
  late CartProvider _cartProvider;
  late FavoritesProvider _favoritesProvider;
  late KorisniciProvider _korisniciProvider;
  SearchResult<Product>? result;
  SearchResult<Product>? resultRecomm;
  bool isLoading = true;
  TextEditingController _ftsController = new TextEditingController();
  TextEditingController _sifraController = new TextEditingController();
  final _formKey = GlobalKey<FormBuilderState>();
  List<Product> dataRecomm = [];

  late RecommendResultProvider _recommendResultProvider = RecommendResultProvider();

  String _selectedSortDirection = 'ascending';

  @override
  void initState() {
    super.initState();
    _fetchProducts();
      _favoritesProvider = Provider.of<FavoritesProvider>(context, listen: false);
      _korisniciProvider = Provider.of<KorisniciProvider>(context, listen: false);
      _recommendResultProvider = context.read<RecommendResultProvider>();

     // _recommendResultProvider.trainData();
  }

  Future<void> _fetchProducts() async {
    try {
      _productProvider = Provider.of<ProductProvider>(context, listen: false);
      _cartProvider = Provider.of<CartProvider>(context, listen: false);
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
      title_widget: Text("Products"),
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearch(),
              Container(
                height: 200,
                child: GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      childAspectRatio: 4 / 3,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 30),
                  scrollDirection: Axis.horizontal,
                  children: _buildProductCardList(result, false),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Recommended products:",  style: TextStyle(color: Colors.blueGrey,fontSize: 25,fontWeight: FontWeight.w600),),
              SizedBox(height: 15),

              Container(
                height: 200,
                child: GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      childAspectRatio: 4 / 3,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 30),
                  scrollDirection: Axis.horizontal,
                  children: _buildProductCardList(resultRecomm, true),
                ),
              )
            ],
          ),
        ),
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
              decoration: InputDecoration(labelText: "Product name"),
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
        ],
      ),
    ),
  );
}


List<Widget> _buildProductCardList(dataX, bool rec) {
    if (rec == true && (result?.result.isEmpty ?? true)) {
  return [Text("No recommended articles")];
}
if (rec == false && (result?.result.isEmpty ?? true)) {
  return [Text("Loading...")];
}

List<Widget> list = (dataX?.result ?? [])
    .map((x) => Container(
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProductDetailsScreen(x),
              ),
            );
                    },
                    child: Container(
                      height: 100,
                      width: 100,
                      child: x.slika == null
                          ? Text("No image")
                          : imageFromBase64String(x.slika!),
                    ),
                  ),
                  Text(x.naziv ?? ""),
                  Text("${formatNumber(x.cijena)} KM"),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.shopping_cart),
                        onPressed: () async {
                          _cartProvider.addToCart(x);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            backgroundColor: Colors.green,
                            duration: Duration(milliseconds: 1000),
                            content: Text("Successful added to cart."),
                          ));
                          Product _x = x;
                          int id = _x.proizvodID!;
                          try{
                          var recommendResult = await _recommendResultProvider.get();
                          var filteredRecommendation = recommendResult.result.where((x) => x.proizvodId == id).toList();
                          if (filteredRecommendation.isNotEmpty) {
                            var matchingRecommendation = filteredRecommendation.first;
                           
                            print(recommendResult);

                            int prviProizvodID = matchingRecommendation.prviProizvodId!;
                            int drugiProizvodID = matchingRecommendation.drugiProizvodId!;
                            int treciProizvodID = matchingRecommendation.treciProizvodId!;
                           
                          var prviRecommendedProduct = await _productProvider.getById(prviProizvodID);
                          var drugiRecommendedProduct = await _productProvider.getById(drugiProizvodID);
                          var treciRecommendedProduct = await _productProvider.getById(treciProizvodID);
                           
                            setState(() {
                               resultRecomm = SearchResult<Product>()
                              ..result = [prviRecommendedProduct, drugiRecommendedProduct, treciRecommendedProduct]
                              ..count = 3; 
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("No matching recommendations found"),
                            ));
                          } 
                          }on Exception catch (e){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Something bad happened."),));
                          }
                          },
                      ),
                      IconButton(
              icon: Icon(Icons.favorite),
              onPressed: () async {
                final isProductFavorite =
                  await _favoritesProvider.exists(x.proizvodID!);

                if (!isProductFavorite) {
                  _favoritesProvider.sendRabbit({
                     "datumDodavanja": DateTime.now().toUtc().toIso8601String(),
                    "ProizvodId": x.proizvodID,
                    "KorisnikId": await getPatientId(),
                  });
                
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.green,
                      duration: Duration(milliseconds: 1000),
                      content:
                        Text("Item ${x.naziv} successfully added to favorites."),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Product is already in favorites."),
                    ),
                  );
                }
              },
            ),
                    ],
                  ),
                ],
              ),
            ))
        .cast<Widget>()
        .toList();
    return list;
  }

 Future<int> getPatientId() async {
    final pacijenti = await _korisniciProvider.get(filter: {
      'tipKorisnika': 'pacijent',
    });

    final pacijent = pacijenti.result.firstWhere((korisnik) => korisnik.username == Authorization.username);

    return pacijent.korisnikId!;
  }
}