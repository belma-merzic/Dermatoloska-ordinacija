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
  final int? selectedPatient;

  TerminDetailScreen({this.termin, this.selectedPatient});

  @override
  _TerminDetailScreenState createState() => _TerminDetailScreenState();
}

class _TerminDetailScreenState extends State<TerminDetailScreen> {
  late DateTime _modifiedDatum;
  int? _modifiedDoktorId;
  int? _modifiedPacijentId;

  late KorisniciProvider _korisniciProvider;
  late TerminiProvider _terminiProvider;
  SearchResult<Korisnik>? result;
  List<Termin>? _termini;
  int? _selectedPatient;

  bool get _isEditing => widget.termin != null;

  @override
  void initState() {
    super.initState();
    _korisniciProvider = Provider.of<KorisniciProvider>(context, listen: false);
    _terminiProvider = TerminiProvider();

    _modifiedDatum = widget.termin?.datum ?? DateTime.now();
    _modifiedDoktorId = widget.termin?.korisnikIdDoktor;
    _modifiedPacijentId = widget.selectedPatient ?? null;

    _fetchPacijenti();
    _fetchTerminiForPatient(_selectedPatient ?? _modifiedPacijentId ?? -1);
  }

  bool _isDateTimeOccupied(DateTime dateTime) {
  if (_termini != null) {
    for (var termin in _termini!) {
      if (termin.datum == dateTime) {
        return true;
      }
    }
  }
  return false;
}


  Future<void> _fetchPacijenti() async {
    try {
      var data = await _korisniciProvider.get(filter: {
        'tipKorisnika': 'pacijent',
      });

      setState(() {
        result = data;
        if (result?.result.isNotEmpty == true) {
          _selectedPatient = _modifiedPacijentId ?? result!.result[0].korisnikId;

          print("SELEKTOVANI");
          print(_selectedPatient);
        } else {
          _selectedPatient = null;
        }
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _fetchTerminiForPatient(int patientId) async {
    try {
      var terminiData = await _terminiProvider.get(filter: {
        'korisnikIdPacijent': patientId,
      });
      setState(() {
        _termini = terminiData.result;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Appointment' : 'Add Appointment'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.0),
            DropdownButton<int>(
              value: _selectedPatient,
              onChanged: _isEditing ? null : (newValue) {
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
              isExpanded: true,
              disabledHint: Text(
                _selectedPatient != null
                    ? 'Selected Patient ID: $_selectedPatient'
                    : 'Select a Patient',
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
                        });
                      }
                    }
                  },
                  child: Text('Change Date'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_isEditing) {
                      _saveModifiedTermin();
                    } else {
                      _saveNewTermin();
                    }
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

void _saveModifiedTermin() async {
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
    widget.termin!.datum = _modifiedDatum;
    widget.termin!.korisnikIdDoktor = _modifiedDoktorId;
    widget.termin!.korisnikIdPacijent = _modifiedPacijentId;

    try {
      await TerminiProvider().update(widget.termin!.terminId!, widget.termin!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Appointment "${widget.termin?.terminId}" successfully updated.'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, widget.termin);
    } catch (e) {
      print(e);
    }
  }
}


void _saveNewTermin() async {
  Future<int> getDoctorId() async {
    final doctors = await _korisniciProvider.get(filter: {
      'tipKorisnika': 'uposlenik',
    });

    final doctor = doctors.result.firstWhere((korisnik) => korisnik.username == Authorization.username);

    return doctor.korisnikId!;
  }

  final doktor = await getDoctorId();
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
      doktor,
      _selectedPatient,
      _modifiedDatum,
    );

    try {
      final insertedTermin = await TerminiProvider().insert(newTermin);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Appointment "${insertedTermin.terminId}" successfully added.'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, insertedTermin);
    } catch (e) {
      print(e);
    }
  }
}

}