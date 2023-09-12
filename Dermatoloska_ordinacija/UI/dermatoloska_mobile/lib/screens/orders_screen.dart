import 'package:dermatoloska_mobile/models/narudzba.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dermatoloska_mobile/providers/order_provider.dart';
import 'package:provider/provider.dart';
import '../providers/korisnik_provider.dart';
import '../utils/util.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
    final OrderProvider _ordersProvider = OrderProvider();
  late KorisniciProvider _korisniciProvider;

    List<Narudzba> _narudzba = [];
    bool isLoading = true;
    
  @override
  void initState() {
    super.initState();
    _korisniciProvider = Provider.of<KorisniciProvider>(context, listen: false);
    _fetchNarudzbe();
  }

Future<void> _fetchNarudzbe() async {
  Future<int> getPatientId() async {
      final pacijenti = await _korisniciProvider.get(filter: {
        'tipKorisnika': 'pacijent',
      });

      final pacijent = pacijenti.result.firstWhere((korisnik) => korisnik.username == Authorization.username);

      return pacijent.korisnikId!;
    }


    final pacijentId = await getPatientId();
    print(pacijentId.toString());

    try {
      var result = await _ordersProvider.get(filter: {
        'korisnikId' : pacijentId
      });
      print(result.result);
      setState(() {
        _narudzba = result.result;
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      body: Column(
        children: [
          _buildDataListView(),
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

    if (_narudzba.isEmpty) {
      return Expanded(
        child: Center(
          child: Text('No orders found.'),
        ),
      );
    }

    return Expanded(
  child: ListView.builder(
    itemCount: _narudzba.length,
    itemBuilder: (context, index) {
      var narudzba = _narudzba[index];
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
                  Text(narudzba.iznos.toString()),
                  SizedBox(height: 8),
                  Text(
                    'Created on: ${narudzba.datum != null ? DateFormat('yyyy-MM-dd').format(narudzba.datum!) : 'Unknown Date'}',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
              trailing: Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: _getStatusColor(narudzba.status),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: Text(
                  narudzba.status ?? 'Unknown Status',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      );
    },
  ),
);
 }
 
  _getStatusColor(String? status) {
    if (status == 'Pending') {
    return Colors.orange;
  } else if (status == 'Completed') {
    return Colors.green;
  } else if (status == 'Cancelled') {
    return Colors.red;
  }
  return Colors.grey; 
  }
}