import 'package:dermatoloska_desktop/models/stavkaNarudzbe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';
import '../models/korisnik.dart';
import '../models/narudzba.dart';
import '../models/search_result.dart';
import '../models/zdravstveni_karton.dart';
import '../providers/korisnik_provider.dart';
import '../providers/orders_provider.dart';
import '../providers/product_provider.dart';
import '../providers/stavka_narudzbe_provider.dart';
import '../providers/zdravstveni_karton_provider.dart';
import 'package:printing/printing.dart';

class IzvjestajScreen extends StatefulWidget {
  const IzvjestajScreen({Key? key}) : super(key: key);

  @override
  State<IzvjestajScreen> createState() => _IzvjestajScreenState();
}

class _IzvjestajScreenState extends State<IzvjestajScreen> {
  late KorisniciProvider _korisniciProvider;
  late OrdersProvider _narudzbeProvider;
  late ZdravstveniKartonProvider _zdravstveniKartonProvider;
  late StavkaNarudzbeProvider stavkaNarudzbeProvider;
  late ProductProvider productProvider;



  SearchResult<Korisnik>? result;
  List<Narudzba>? _narudzbe;
  List<ZdravstveniKarton>? _zdravstveniKarton;
  List<StavkaNarudzbe> stavkeNarudzbe = [];

  int? _selectedPatient;
  String _selectedReportType = 'Narudzbe';

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _korisniciProvider = Provider.of<KorisniciProvider>(context, listen: false);
    _narudzbeProvider = Provider.of<OrdersProvider>(context, listen: false);
    _zdravstveniKartonProvider = Provider.of<ZdravstveniKartonProvider>(context, listen: false);
    stavkaNarudzbeProvider = StavkaNarudzbeProvider();
    productProvider = ProductProvider();


    _fetchPacijenti();
  }

  Future<void> _fetchPacijenti() async {
    try {
      var data = await _korisniciProvider.get(filter: {
        'tipKorisnika': 'pacijent',
      });

      setState(() {
        result = data;
        if (result?.result.isNotEmpty == true) {
          _selectedPatient = result!.result[0].korisnikId;
          if (_selectedReportType == 'Narudzbe') {
            _fetchNarudzbeForPatient(_selectedPatient!);
          } else if (_selectedReportType == 'Zdravstveni karton') {
            _fetchZdravstveniKartonForPatient(_selectedPatient!);
          }
        } else {
          _selectedPatient = null;
        }
      });
    } catch (e) {
      print(e);
    }
  }

Future<void> _fetchDataForSelectedType(int patientId) async {
  if (_selectedReportType == 'Narudzbe') {
    await _fetchNarudzbeForPatient(patientId);
  } else if (_selectedReportType == 'Zdravstveni karton') {
    await _fetchZdravstveniKartonForPatient(patientId);
  }
}


  Future<void> _fetchNarudzbeForPatient(int patientId) async {
    try {
      var narudzbeData = await _narudzbeProvider.get(filter: {
        'korisnikId': patientId,
      });
      setState(() {
        _narudzbe = narudzbeData.result;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _fetchZdravstveniKartonForPatient(int patientId) async {
    try {
      var zdravstveniKartonData = await _zdravstveniKartonProvider.get(filter: {
        'korisnikId': patientId,
      });
      setState(() {
        _zdravstveniKarton = zdravstveniKartonData.result;
      });
    } catch (e) {
      print(e);
    }
  }


Widget _buildContent() {
  if (_selectedPatient == null) {
    return Text('Please select a patient');
  }

  if (_selectedReportType == 'Zdravstveni karton') {
    if (_zdravstveniKarton == null) {
      return FutureBuilder<void>(
        future: _fetchZdravstveniKartonForPatient(_selectedPatient!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error loading data');
          } else {
            return _buildZdravstveniKartonContent();
          }
        },
      );
    } else {
      return _buildZdravstveniKartonContent();
    }
  } else if (_selectedReportType == 'Narudzbe') {
    if (_narudzbe == null) {
      return FutureBuilder<void>(
        future: _fetchNarudzbeForPatient(_selectedPatient!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error loading data');
          } else {
            return _buildNarudzbeContent();
          }
        },
      );
    } else {
      return _buildNarudzbeContent();
    }
  }
  return Text('Select a report type');
}


  Widget _buildNarudzbeContent() {
    return Container(
    height: 300, 
    child: ListView.builder(
      itemCount: _narudzbe!.length,
      itemBuilder: (context, index) {
        var narudzba = _narudzbe![index];
        //var data =  _fetchStavkeNarudzbe(narudzba);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                title: Text(narudzba.brojNarudzbe ?? ''),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${narudzba.iznos.toString()} KM"),
                    SizedBox(height: 8),
                    Text(
                      'Created on: ${narudzba.datum != null ? DateFormat('yyyy-MM-dd').format(narudzba.datum!) : 'Unknown Date'}',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
               ElevatedButton(
  onPressed: () async {
    await _fetchStavkeNarudzbe(narudzba);
    // ignore: use_build_context_synchronously
    showDialog(context: context, builder: (BuildContext context) {
      print(stavkeNarudzbe);
      return AlertDialog(
        title: Text("Details"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (stavkeNarudzbe != null) 
              for (var stavka in stavkeNarudzbe!) // Prolazite kroz sve stavke narudžbe
                Column(
                  children: [
                    Text("Quantity: ${stavka.kolicina.toString()}"),
                    //Text("Product ID: ${stavka.proizvodId.toString()}"),
                    FutureBuilder<String>(
                      future: getProductName(stavka.proizvodId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return Text("Product Name: ${snapshot.data ?? 'N/A'}");
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    ),
                    Divider(), // razdvajač između stavki
                  ],
                ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Close"),
          ),
        ],
      );
    });
  },
  child: Text("Details"),
),


                   ],
                ),
              ),
            ),
          ),
        );
      },
    ),
    );
  }

  Future<String> getProductName(int? proizvodId) async{
     if (proizvodId == null) {
      return 'N/A';
    }

    try {
      var product = await productProvider.getById(proizvodId);
      print(product.naziv);
      return product.naziv ?? 'N/A';
    } catch (e) {
      return 'N/A';
    }
  }

_fetchStavkeNarudzbe(Narudzba narudzba) async {
  print("NARUDZBA KOJA JE POSLANA U FUNKCIJU");
  print(narudzba.brojNarudzbe);
  if (narudzba == null) {
    setState(() {
      isLoading = false;
    });
    return;
  }
  try {
    var narudzbaId = narudzba.narudzbaId;
    if (narudzbaId != null) {
      var result = await stavkaNarudzbeProvider.getStavkeNarudzbeByNarudzbaId(narudzbaId);
      setState(() {
        stavkeNarudzbe = result;
        isLoading = false;
      });
    }
  } catch (e) {
    // Handle error
    print(e);
    setState(() {
      isLoading = false;
      stavkeNarudzbe = []; 
    });
  }
}



  Widget _buildZdravstveniKartonContent() {
    return Column(
      children: _zdravstveniKarton!.map((zdravstveniKarton) {
        return Text(zdravstveniKarton.sadrzaj.toString());
      }).toList(),
    );
  }

  pw.Widget _generatePDFContent() {
  if (_selectedReportType == 'Narudzbe' && _narudzbe != null) {
    return pw.Column(
      children: _narudzbe!.map((narudzba) {
        print("printanje broja narudzbe");
        print(narudzba.brojNarudzbe);
        return pw.Container(
          padding: pw.EdgeInsets.symmetric(vertical: 8.0),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('Broj narudzbe: ${narudzba.brojNarudzbe ?? ''}'),
              pw.Text('Iznos: ${narudzba.iznos} KM'),
              pw.Text('Status: ${narudzba.status}'),
              pw.Text(
                'Datum: ${narudzba.datum != null ? DateFormat('yyyy-MM-dd').format(narudzba.datum!) : 'Unknown Date'}',
              ),
            ],
          ),
        );
      }).toList(),
    );
  } else if (_selectedReportType == 'Zdravstveni karton' && _zdravstveniKarton != null) {
    return pw.Column(
      children: _zdravstveniKarton!.map((zdravstveniKarton) {
        return pw.Text(zdravstveniKarton.sadrzaj.toString());
      }).toList(),
    );
  } else {
    return pw.Text('No data available for the selected report type.');
  }
}


Future<pw.Document> _generatePDFReport() async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black, width: 2),
            ),
            padding: pw.EdgeInsets.all(20),
            child: pw.Column(
              children: [
                pw.Text('PDF Report Content', style: pw.TextStyle(fontSize: 20)),
                pw.SizedBox(height: 20),
                _generatePDFContent(), 
              ],
            ),
          ),
        );
      },
    ),
  );

  return pdf;
}

  Future<void> _printPDFReport(pw.Document pdf) async {
    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("usao u build");
    return Scaffold(
      appBar: AppBar(
        title: Text('Reports'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(child: 
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.0),
            DropdownButton<int>(
              value: _selectedPatient,
              onChanged: (newValue) {
                setState(() {
                  _selectedPatient = newValue!;
                });
              },
              items: result?.result.map<DropdownMenuItem<int>>((Korisnik korisnik) {
                return DropdownMenuItem<int>(
                  value: korisnik.korisnikId,
                  child: Text(korisnik.ime!),
                );
              }).toList() ?? [],
              hint: Text('Odaberi pacijenta'),
            ),

            SizedBox(height: 16.0),

        DropdownButton<String>(
          value: _selectedReportType,
          onChanged: (newValue) {
            setState(() {
              _selectedReportType = newValue!;
            });
          _fetchDataForSelectedType(_selectedPatient!); 
          },
        items: <String>['Narudzbe', 'Zdravstveni karton']
        .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
        }).toList(),
        hint: Text('Odaberi tip reporta'),
        ),
            SizedBox(height: 32.0),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: EdgeInsets.all(16.0),
              child: _buildContent(),
            ),

            SizedBox(height: 32.0),

            ElevatedButton(
              onPressed: () async{
                final pdf = await _generatePDFReport();
                await _printPDFReport(pdf);
              },
              child: Text('Save and Print Report'),
            ),
          ],
        ),
      ),
      ),
    );
  }
  
}