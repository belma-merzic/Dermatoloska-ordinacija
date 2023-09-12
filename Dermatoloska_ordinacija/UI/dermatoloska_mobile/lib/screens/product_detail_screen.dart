import 'package:dermatoloska_mobile/providers/dojam_provider.dart';
import 'package:dermatoloska_mobile/providers/korisnik_provider.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/recenzija.dart';
import '../models/search_result.dart';
import '../providers/recenzija_provider.dart';
import '../utils/util.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  ProductDetailsScreen(this.product);

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late KorisniciProvider _korisniciProvider;
  late DojamProvider _dojamProvider;
  late RecenzijaProvider _recenzijaProvider;
  TextEditingController _reviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _korisniciProvider = KorisniciProvider();
    _dojamProvider = DojamProvider();
    _recenzijaProvider = RecenzijaProvider();
    //fetchRecenzije(widget.product.proizvodID!);
  }

  Future<int> getPatientId() async {
    final pacijenti = await _korisniciProvider.get(filter: {
      'tipKorisnika': 'pacijent',
    });

    final pacijent = pacijenti.result.firstWhere(
        (korisnik) => korisnik.username == Authorization.username);

    return pacijent.korisnikId!;
  }

  Future<bool> hasUserRated() async {
    final patientId = await getPatientId();

    final existingRating = await _dojamProvider.exists(
      korisnikId: patientId,
      proizvodId: widget.product.proizvodID!,
    );
    return existingRating;
  }

  void postReview() async {
    final patientId = await getPatientId();

    await _recenzijaProvider.insert({
      "sadrzaj": _reviewController.text,
      "datum": DateTime.now().toIso8601String(),
      "korisnikId": patientId,
      "proizvodId": widget.product.proizvodID,
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Review posted")),
    );
    setState(() {
      _reviewController.clear();
    });
  }

  Future<List<Recenzija>> fetchRecenzije(int proizvodId) async{
    final recenzijeResult = await _recenzijaProvider.get(filter: {
      "proizvodId" : proizvodId
    });

    return recenzijeResult.result.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.naziv ?? "Product Details"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 100,
                height: 100,
                child: widget.product.slika != ""
                    ? imageFromBase64String(widget.product.slika!)
                    : Text("No Image"),
              ),
              SizedBox(height: 16),
              Text(
                widget.product.naziv ?? "",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "Cijena: ${formatNumber(widget.product.cijena) + " KM"}",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.thumb_up),
                    color: Colors.green,
                    onPressed: () async {
                      final hasRated = await hasUserRated();
                      if (hasRated) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("You have already rated this product")),
                        );
                      } else {
                        await _dojamProvider.insert({
                          "isLiked": true,
                          "korisnikId": await getPatientId(),
                          "proizvodId": widget.product.proizvodID,
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("You liked this product")),
                        );
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.thumb_down),
                    color: Colors.red,
                    onPressed: () async {
                      final hasRated = await hasUserRated();
                      if (hasRated) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("You have already rated this product")),
                        );
                      } else {
                        await _dojamProvider.insert({
                          "isLiked": false,
                          "korisnikId": await getPatientId(),
                          "proizvodId": widget.product.proizvodID,
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("You disliked this product")),
                        );
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Text("Recenzije:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              FutureBuilder<SearchResult<Recenzija>>(
                future: _recenzijaProvider.get(filter: {"proizvodId": widget.product.proizvodID}),
                builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else if (!snapshot.hasData || snapshot.data!.result.isEmpty) {
                  return Text("Nema recenzija za ovaj proizvod.");
                } else {
                  final recenzijeList = snapshot.data!.result;
                return Column(
                  children: recenzijeList.map((recenzija) {
                    return Card( 
                      elevation: 3, 
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                      child: ListTile(
                      title: Text(recenzija.sadrzaj!),
                      ),
                    );
                  }).toList(),
                );
              }},),

              SizedBox(height: 30),
              Container(
                width: double.infinity, // Ensures TextField has a finite width
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _reviewController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: "Write a review...",
                      ),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: postReview,
                      child: Text("Post"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
