import 'package:dermatoloska_mobile/providers/korisnik_provider.dart';
import 'package:dermatoloska_mobile/providers/zdravstveni_karton_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/util.dart';

class ZdravstveniKartonScreen extends StatefulWidget {
  ZdravstveniKartonScreen({Key? key}) : super(key: key);

  @override
  State<ZdravstveniKartonScreen> createState() => _ZdravstveniKartonScreenState();
}

class _ZdravstveniKartonScreenState extends State<ZdravstveniKartonScreen> {
  final ZdravstveniKartonProvider _zdravstveniKartonProvider = ZdravstveniKartonProvider();
  late KorisniciProvider _korisniciProvider;
  String? _karton;
  int? _zdravstveniKartonId; 
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _korisniciProvider = Provider.of<KorisniciProvider>(context, listen: false);
    _fetchZdravstveniKarton();
  }

  Future<void> _fetchZdravstveniKarton() async {
    setState(() {
      isLoading = true;
    });

    Future<int> getPatientId() async {
      final pacijenti = await _korisniciProvider.get(filter: {
        'tipKorisnika': 'pacijent',
      });

      final pacijent = pacijenti.result.firstWhere((korisnik) => korisnik.username == Authorization.username);

      return pacijent.korisnikId!;
    }

    final pacijentId = await getPatientId();

    try {
      var result = await _zdravstveniKartonProvider.get(filter: {
        'korisnikId': pacijentId,
      });

      if (result.result.isNotEmpty) {
        setState(() {
          _zdravstveniKartonId = result.result[0].zdravstveniKartonId; 
          _karton = result.result[0].sadrzaj;

          print(_karton);
          isLoading = false;
        });
      } else {
        setState(() {
          _zdravstveniKartonId = null;
          _karton = null;
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Health Record'),
      ),
      body: SingleChildScrollView( 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (isLoading)
              CircularProgressIndicator(),
            if (_karton != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: TextEditingController(text: _karton),
                  style: TextStyle(fontSize: 16),
                  onChanged: (newText) {
                    setState(() {
                      _karton = newText;
                    });
                  },
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
          ],
        ),
      ),
    );
  }
}