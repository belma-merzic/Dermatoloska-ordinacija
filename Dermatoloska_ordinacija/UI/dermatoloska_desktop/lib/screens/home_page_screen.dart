import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dermatoloska_desktop/models/novost.dart';
import 'package:dermatoloska_desktop/providers/novosti_provider.dart';
import 'package:dermatoloska_desktop/screens/novost_detail_screen.dart';

class HomePageScreen extends StatefulWidget {
  HomePageScreen({Key? key}) : super(key: key);

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  final NovostiProvider _novostiProvider = NovostiProvider();
  List<Novost> _novosti = [];
  bool isLoading = true;
  TextEditingController _naslovController = TextEditingController();
  bool _isSortAscending = true; 

  @override
  void initState() {
    super.initState();
    _fetchNovosti();
  }

  Future<void> _fetchNovosti() async {
    try {
      var result = await _novostiProvider.get(filter: {
        'naslov': _naslovController.text,
      });
      print(result);

      setState(() {
        _novosti = result.result;
        _sortNovosti();
        isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  void _sortNovosti() {
    _novosti.sort((a, b) {
      if (_isSortAscending) {
        return a.datumObjave!.compareTo(b.datumObjave!);
      } else {
        return b.datumObjave!.compareTo(a.datumObjave!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Column(
        children: [
          _buildSearch(),
          _buildDataListView(),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _naslovController,
              onChanged: (_) => _fetchNovosti(),
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          SizedBox(width: 16.0),
          DropdownButton<String>(
            value: _isSortAscending ? 'older_to_newer' : 'newer_to_older',
            onChanged: (value) {
              setState(() {
                if (value == 'older_to_newer') {
                  _isSortAscending = true;
                } else {
                  _isSortAscending = false;
                }
                _sortNovosti();
              });
            },
            items: [
              DropdownMenuItem(
                value: 'older_to_newer',
                child: Text('Older to Newer'),
              ),
              DropdownMenuItem(
                value: 'newer_to_older',
                child: Text('Newer to Older'),
              ),
            ],
          ),
          SizedBox(width: 8),
          ElevatedButton(
            onPressed: () async {
              var refresh = await
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NovostDetailScreen(novost: null),
                ));

                if(refresh == 'reload'){
                  _fetchNovosti();
                }
            },
            child: Text("Add"),
          ),
        ],
      ),
    );
  }

  Widget _buildDataListView() {
    if (isLoading) {
      return Expanded(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_novosti.isEmpty) {
      return Expanded(
        child: Center(
          child: Text('No news found.'),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: _novosti.length,
        itemBuilder: (context, index) {
          var novost = _novosti[index];
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
                  onTap: () async {
                    var refresh = await
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => NovostDetailScreen(novost: novost),
                      ),
                    );
                    if(refresh == 'reload'){
                  _fetchNovosti();
                }
                  },
                  title: Text(novost.naslov ?? ''),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(novost.sadrzaj ?? ''),
                      SizedBox(height: 8),
                      Text(
                        'Published on: ${DateFormat('yyyy-MM-dd').format(novost.datumObjave ?? DateTime.now())}',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _showDeleteConfirmationDialog(novost); 
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  
  void _showDeleteConfirmationDialog(Novost novost) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this news?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await _deleteNovost(novost);
                Navigator.of(context).pop(); 
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteNovost(Novost novost) async {
    try {
      await _novostiProvider.delete(novost.novostId); 
      setState(() {
        _novosti.removeWhere((item) => item.novostId == novost.novostId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('News "${novost.naslov}" deleted successfully.'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete item "${novost.naslov}".'),
        ),
      );
    }
  }
}