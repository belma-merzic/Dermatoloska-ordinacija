import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:dermatoloska_mobile/models/korisnik.dart'; 
import 'package:dermatoloska_mobile/providers/korisnik_provider.dart'; 
import 'package:dermatoloska_mobile/utils/util.dart'; 
import 'package:dermatoloska_mobile/widgets/master_screen.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import '../providers/zdravstveni_karton_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;


class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {

  final _formKey = GlobalKey<FormBuilderState>();
  late KorisniciProvider _korisniciProvider;
  late Future<Korisnik> _korisnikFuture;
  bool _isLoading = true;

    final ZdravstveniKartonProvider _zdravstveniKartonProvider = ZdravstveniKartonProvider();
  String? _karton;
  int? _zdravstveniKartonId; 

  @override
  void initState() {
    super.initState();
    _korisniciProvider = Provider.of<KorisniciProvider>(context, listen: false);

    _loadKorisnikData();
    _fetchZdravstveniKarton();
  }

  Future<void> _loadKorisnikData() async {
    final korisnikId = await getPatientId();
    _korisnikFuture = _korisniciProvider.getById(korisnikId);

    await Future.delayed(Duration(milliseconds: 300));

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _fetchZdravstveniKarton() async {
    setState(() {           ////////////////////////////////////////////////////////////////////////////////
      _isLoading = true;
    });

    /*Future<int> getPatientId() async {
      final pacijenti = await _korisniciProvider.get(filter: {
        'tipKorisnika': 'pacijent',
      });

      final pacijent = pacijenti.result.firstWhere((korisnik) => korisnik.username == Authorization.username);

      return pacijent.korisnikId!;
    }*/

    final pacijentId = await getPatientId();  ////////////////////////////////////////////////////////////////////////////////

    try {
      var result = await _zdravstveniKartonProvider.get(filter: {
        'korisnikId': pacijentId,
      });

      if (result.result.isNotEmpty) {
        setState(() {
          _zdravstveniKartonId = result.result[0].zdravstveniKartonId; 
          _karton = result.result[0].sadrzaj;

          print(_karton);
          _isLoading = false;
        });
      } else {
        setState(() {
          _zdravstveniKartonId = null;
          _karton = null;
          _isLoading = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<int> getPatientId() async {
    final pacijenti = await _korisniciProvider.get(filter: {
      'tipKorisnika': 'pacijent',
    });

    final pacijent = pacijenti.result.firstWhere(
        (korisnik) => korisnik.username == Authorization.username);

    return pacijent.korisnikId!;
  }



  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return FutureBuilder<Korisnik>(
        future: _korisnikFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error loading data');
          } else {
            final korisnikData = snapshot.data;

            return MasterScreenWidget(
              title_widget: Text("My Profile"),
               child: FormBuilder(
                key: _formKey,
                child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  FormBuilderTextField(
                      name: 'ime', 
                      initialValue: korisnikData?.ime ?? '',
                      enabled: false, 
                      decoration: InputDecoration(
                        labelText: 'First name',
                        prefixIcon: Icon(Icons.person),
                      ),
                  ),
                    FormBuilderTextField(
                      name: 'prezime', 
                      initialValue: korisnikData?.prezime ?? '',
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: 'Last name',
                        prefixIcon: Icon(Icons.person),
                      ),
                  ),
                  FormBuilderTextField(
                      name: 'username',
                      initialValue: korisnikData?.username ?? '',
                      enabled: false, // Read-only
                      decoration: InputDecoration(
                        labelText: 'Username',
                        prefixIcon: Icon(Icons.account_circle),
                      ),
                  ),
                  FormBuilderTextField(
                      name: 'email',
                      initialValue: korisnikData?.email ?? '',
                      enabled: true, // Read-only
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                      ),
                  ),
                  FormBuilderTextField(
                      name: 'telefon',
                      initialValue: korisnikData?.telefon ?? '',
                      enabled: true, // Editable
                      decoration: InputDecoration(
                        labelText: 'Phone',
                        prefixIcon: Icon(Icons.phone),
                      ),
                  ),
                  FormBuilderTextField(
                      name: 'adresa',
                      initialValue: korisnikData?.adresa ?? '',
                      enabled: true, // Editable
                      decoration: InputDecoration(
                        labelText: 'Address',
                        prefixIcon: Icon(Icons.location_on),
                      ),
                  ),
                  SizedBox(height: 20),
                 ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState != null) {
                      if (_formKey.currentState!.saveAndValidate()) {
                        var request = Map<String, dynamic>.from(_formKey.currentState!.value);

                       if (request['email'].isEmpty || request['telefon'].isEmpty || request['adresa'].isEmpty) {
                         showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                            title: Text("Warning"),
                            content: Text("Fields cannot be empty. Please fill in all fields."),
                            actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("OK"),
                             ),
                            ],
                         ),
                        );
                       return; 
                       }


                    if (!RegExp(r"^(?:\+?\d{10}|\d{9})$").hasMatch(request['telefon'])) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                            title: Text("Warning"),
                            content: Text("Invalid phone number format. Please enter a valid phone number."),
                            actions: [
                             TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("OK"),
                             ),
                            ],
                          ),
                        );
                      return;
                    }

                    if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+$").hasMatch(request['email'])) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                          title: Text("Warning"),
                          content: Text("Invalid email format. Please enter a valid email address."),
                          actions: [
                           TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("OK"),
                           ),
                          ],
                         ),
                        );
                      return;
                    }

                   try {
                     await _korisniciProvider.update(korisnikData!.korisnikId!, request);
                     ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(
                        backgroundColor: Colors.green,
                        duration: Duration(milliseconds: 1000),
                        content: Text("'My profile' successfully updated!"),));
                   } catch (e) {
                      showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                      title: Text("Error"),
                      content: Text(e.toString()),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context), child: Text("OK")),
                      ],
                      ),
                    );
                  }
                  }
                }else {
                  print("_formKey.currentState is null");
                }
              },
            child: Text('Save'),
            ),
            SizedBox(height: 20),
            _buildHealthRecordContent(),
          ],
         ),
        ),),);
        }
      },
     );
    }
  }
  
  Widget _buildHealthRecordContent() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (_isLoading)
            CircularProgressIndicator(),
          if (_karton != null)
       FormBuilderTextField(
  name: 'health_record',
  initialValue: _karton ?? '',
  onChanged: (newText) {
    setState(() {
      _karton = newText;
    });
  },
  style: TextStyle(fontSize: 16),
  decoration: InputDecoration(
    labelText: 'Health Record',
  ),
)

          else
            Text(
              'No health record available',
              style: TextStyle(fontSize: 16),
            ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (_karton != null && _zdravstveniKartonId != null) {
                try {
                  await _zdravstveniKartonProvider.update(_zdravstveniKartonId!, {
                      'sadrzaj': _karton,
                    });
                    _fetchZdravstveniKarton();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Health Record successfully updated.'),
                          backgroundColor: Colors.green,
                        ),
                      );
                } catch (e) {
                  print(e);
                }
              }
            },
            child: Text('Save'),
          ),
          SizedBox(height: 20,),
          ElevatedButton(
  onPressed: () async {
    final pdf = await generatePDFReport();
    await _printPDFReport(pdf);
    // Add code to save or display the PDF here.
    // You can use a package like 'printing' to print the PDF.
    // For example, you can display the PDF using 'open_file' package.
  },
  child: Text('Print'),
)

        ],
      ),
    );
  }


  Future<pw.Document> generatePDFReport() async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Text(_karton ?? 'No health record available'),
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

  }