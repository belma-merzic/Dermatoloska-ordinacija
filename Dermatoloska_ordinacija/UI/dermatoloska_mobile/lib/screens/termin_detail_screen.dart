import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/korisnik.dart';
import '../models/search_result.dart';
import '../models/termin.dart';
import '../providers/korisnik_provider.dart';
import '../providers/termini_provider.dart';
import '../utils/util.dart';

class TerminDetailScreen extends StatefulWidget {
  final Termin? termin;

  TerminDetailScreen({this.termin});

  @override
  _TerminDetailScreenState createState() => _TerminDetailScreenState();
}

class _TerminDetailScreenState extends State<TerminDetailScreen> {
  late DateTime _modifiedDatum;
  int? _modifiedDoktorId;
  late DateTime _initialDateTime;

  late KorisniciProvider _korisniciProvider;
  late TerminiProvider _terminiProvider;
  SearchResult<Korisnik>? result;
  List<Termin>? _termini;
  int? _selectedDoctor;

  bool _isDateModified = false;
  bool _isSaveButtonEnabled = false;

  SearchResult<Termin>? terminiResult;

  @override
  void initState() {
    super.initState();
    _korisniciProvider = Provider.of<KorisniciProvider>(context, listen: false);
    _terminiProvider = TerminiProvider();

    _modifiedDatum = widget.termin?.datum ?? DateTime.now();
    _modifiedDoktorId = widget.termin?.korisnikIdDoktor;

    _initialDateTime = _modifiedDatum;

    _fetchPacijenti();
    _fetchTerminiForPatient();
    _fetchOcuppiedAppointments();
  }

  Future<void> _fetchOcuppiedAppointments() async {
    try {
      var data = await _terminiProvider.get(filter: {
        'datum': _modifiedDatum.toIso8601String(),
      });

      setState(() {
        terminiResult = data;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _fetchPacijenti() async {
    try {
      var data = await _korisniciProvider.get(filter: {
        'tipKorisnika': 'uposlenik',
      });

      setState(() {
        result = data;
        if (result?.result.isNotEmpty == true) {
          _selectedDoctor = _modifiedDoktorId ?? result!.result[0].korisnikId;
        } else {
          _selectedDoctor = null;
        }
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _fetchTerminiForPatient() async {
    try {
      var terminiData = await _terminiProvider.get();
      setState(() {
        _termini = terminiData.result;
      });
    } catch (e) {
      print(e);
    }
  }

 bool _isDateTimeOccupied(DateTime dateTime) {
  if (_termini != null) {
    for (var termin in _termini!) {
      if (dateTime.isBefore(termin.datum!.add(Duration(minutes: 30))) &&
          termin.datum!.isBefore(dateTime.add(Duration(minutes: 30)))) {
        return true;
      }
    }
  }
  return false;
}

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Appointment'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.0),
              DropdownButton<int>(
                value: _selectedDoctor,
                onChanged: (newValue) {
                  setState(() {
                    _selectedDoctor = newValue!;
                  });
                },
                items: result?.result
                        .map<DropdownMenuItem<int>>((Korisnik korisnik) {
                      return DropdownMenuItem<int>(
                        value: korisnik.korisnikId,
                        child: Text(korisnik.ime!),
                      );
                    }).toList() ??
                    [],
                isExpanded: true,
                disabledHint: Text(
                  _selectedDoctor != null
                      ? 'Selected Doctor ID: $_selectedDoctor'
                      : 'Select a Doctor',
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Date:',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                DateFormat('dd.MM.yyyy - HH:mm').format(_modifiedDatum),
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: _modifiedDatum,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
          
                      if (selectedDate != null) {
                        final selectedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(_modifiedDatum),
                        );
          
                        if (selectedTime != null) {
                          
                          setState(() {
                            _modifiedDatum = DateTime(
                              selectedDate.year,
                              selectedDate.month,
                              selectedDate.day,
                              selectedTime.hour,
                              selectedTime.minute,
                            );
                            _isDateModified = true;
                            _isSaveButtonEnabled = true;
                          });
                          await _fetchOcuppiedAppointments();
                        }
                      }
                    },
                    child: Text('Select Date and Time'),
                  ),
                  ElevatedButton(
                    onPressed: _isSaveButtonEnabled
                        ? () {
                            _saveNewTermin();
                          }
                        : null,
                    child: Text('Save'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    (terminiResult == null || terminiResult!.result.isEmpty)
                        ? Text('No occupied appointments')
                        : Text('Occupied appointments')
                  ],
                ),
              ),
              
              Expanded(
                child: 
                 (terminiResult == null || terminiResult!.result.isEmpty) ? Container() :
               ListView.builder(
                    itemCount: terminiResult!.result.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ListTile(
                            title: Text(terminiResult!.result[index].datum.toString(),
                           
                              ),
                          ),
                          const Divider(
                            color: Colors.black,
                            thickness: 1,
                          )
                        ],
                      );
                    },
                  ),
              )
            ],
          ),
        ),
      ),
    );
  }

  
  void _saveNewTermin() async {
    if (_termini == null) {
      return;
    }

    Future<int> getPatientId() async {
      final pacijenti = await _korisniciProvider.get(filter: {
        'tipKorisnika': 'pacijent',
      });

      final pacijent = pacijenti.result.firstWhere(
          (korisnik) => korisnik.username == Authorization.username);

      return pacijent.korisnikId!;
    }

    final pacijent = await getPatientId();
    final selectedDateTime = _modifiedDatum;

    if (_isDateTimeOccupied(selectedDateTime)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Date and Time Occupied'),
            content: Text('The selected date and time are already occupied.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      final newTermin = Termin(
        null,
        _selectedDoctor,
        pacijent,
        _modifiedDatum,
      );

      try {
        if (_isDateTimeOccupied(_modifiedDatum)) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Date and Time Occupied'),
                content:
                    Text('The selected date and time are already occupied.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          final insertedTermin = await TerminiProvider().insert(newTermin);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Appointment successfully added.'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, insertedTermin);
        }
      } catch (e) {
        print(e);
      }
    }
  }
}
