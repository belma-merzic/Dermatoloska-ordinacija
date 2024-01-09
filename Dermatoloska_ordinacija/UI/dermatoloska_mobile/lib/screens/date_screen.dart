import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../models/search_result.dart';
import '../models/termin.dart';
import '../providers/termini_provider.dart';

class DateTest extends StatefulWidget {
  const DateTest({super.key});

  @override
  State<DateTest> createState() => _DateTestState();
}

class _DateTestState extends State<DateTest> {
  DateTime? selectedDate;
  late TerminiProvider _terminiProvider;
  SearchResult<Termin>? terminiResult;
  int hour = 0;

  @override
  void initState() {
    super.initState();
    _terminiProvider = TerminiProvider();
  }

  Future<void> _fetchOcuppiedAppointments() async {
    try {
      var data = await _terminiProvider.get(filter: {
        'datum': selectedDate!.toIso8601String(),
      });

      setState(() {
        terminiResult = data;
      });
    } catch (e) {
      print(e);
    }
  }

  bool isOcuppiedHour(int h) {
    if (terminiResult == null || terminiResult!.result.isEmpty) {
      return false; 
    }

    for (int i = 0; i < terminiResult!.result.length; i++) {
      if (terminiResult!.result[i].datum!.hour == h) {
        return true; 
      }
    }

    return false;
  }

  bool isPastDate(DateTime datetime) {
    DateTime currentDate = DateTime.now();
    if (datetime.year < currentDate.year) {
      return true; // if the year is in the past
    }
    if (datetime.year == currentDate.year &&
        datetime.month < currentDate.month) {
      return true; // if same year but past month
    }
    if (datetime.year == currentDate.year &&
        datetime.month == currentDate.month &&
        datetime.day <= currentDate.day) {
      return true; // if same year but past month but current or past day
    }

    return false;
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) async {
    setState(() {
      if (args.value is DateTime) {
        selectedDate = args.value;

        print(selectedDate);
      }
    });
    await _fetchOcuppiedAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New appointment"),
      ),
      body: Column(
        children: [
          Row(
            children: [
              SfDateRangePicker(
                onSelectionChanged: _onSelectionChanged,
                selectionMode: DateRangePickerSelectionMode.single,
              ),
            ],
          ),
          const Divider(
            color: Colors.black,
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                selectedDate == null ? Text('') : Text('Appointments')
              ],
            ),
          ),
          const Divider(
            color: Colors.black,
            thickness: 3,
          ),
          Expanded(
            child: (selectedDate == null || isPastDate(selectedDate!) == true)
                ? Container()
                : ListView.builder(
                    itemCount: 13,
                    itemBuilder: (context, index) {
                      final currentHour = index + 8;
                      final isOccupied = isOcuppiedHour(currentHour);

                      return Column(
                        children: [
                          InkWell(
                            onTap: isOccupied
                                ? null
                                : () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        title: Text("Confirm appointment"),
                                        content: Text(
                                          "Appointment on ${DateFormat('dd/MM/yyyy').format(selectedDate!)} at ${currentHour}:00",
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: (() {
                                              Navigator.pop(context);
                                            }),
                                            child: Text("Cancel"),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              try {
                                                selectedDate = DateTime(
                                                  selectedDate!.year,
                                                  selectedDate!.month,
                                                  selectedDate!.day,
                                                  currentHour,
                                                );
                                                print(selectedDate);

                                                Navigator.pop(context);
                                                Navigator.pop(
                                                    context, selectedDate);
                                              } catch (e) {
                                                print(e.toString());
                                              }
                                            },
                                            child: const Text('Ok'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                            child: ListTile(
                              title: Text(
                                "${currentHour}:00 h",
                                style: TextStyle(
                                  color: isOccupied
                                      ? Colors.red
                                      : Colors.green,
                                ),
                              ),
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
    );
  }
}
