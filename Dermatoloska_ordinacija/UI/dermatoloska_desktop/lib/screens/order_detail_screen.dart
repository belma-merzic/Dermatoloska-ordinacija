import 'package:dermatoloska_desktop/models/narudzba.dart';
import 'package:dermatoloska_desktop/models/stavkaNarudzbe.dart';
import 'package:dermatoloska_desktop/providers/orders_provider.dart';
import 'package:dermatoloska_desktop/providers/stavka_narudzbe_provider.dart';
import 'package:dermatoloska_desktop/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../providers/product_provider.dart';

class OrderDetailScreen extends StatefulWidget {
  Narudzba? narudzba;

  OrderDetailScreen({super.key, this.narudzba});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late OrdersProvider _ordersProvider;
  late StavkaNarudzbeProvider stavkaNarudzbeProvider;
  late ProductProvider productProvider;
  List<StavkaNarudzbe> stavkeNarudzbe = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initialValue = {
      'brojNarudzbe': widget.narudzba?.brojNarudzbe,
      'status': widget.narudzba?.status,
      'datum': widget.narudzba?.datum.toString(),
      'iznos': widget.narudzba?.iznos.toString()
    };
    _ordersProvider = context.read<OrdersProvider>();
    stavkaNarudzbeProvider = StavkaNarudzbeProvider();
    productProvider = ProductProvider();
    _fetchStavkeNarudzbe();

    initForm();
  }

  Future<void> _fetchStavkeNarudzbe() async {
    if (widget.narudzba == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      var narudzbaId = widget.narudzba?.narudzbaId;
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
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future initForm() async {
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var orderDetailState = Provider.of<OrderDetailState>(context, listen: false);

    return MasterScreenWidget(
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.all(16),
          child: isLoading ? Container() : SingleChildScrollView(
            child: _buildForm(),
          ) ,
        ),
      ),
      title: "Order ${this.widget.narudzba?.brojNarudzbe}" ?? "Order details",
    );
  }

  FormBuilder _buildForm() {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      child: Column(
        children: [
          FormBuilderTextField(
            decoration: InputDecoration(labelText: "Order number"),
            name: 'brojNarudzbe',
            readOnly: true,
          ),
          SizedBox(height: 10),
          FormBuilderTextField(
            decoration: InputDecoration(labelText: "Status"),
            name: 'status',
            onChanged: (value) {
             final currentValue = _initialValue['status'];
             print(currentValue);
            },
            validator: (value) {
                if (value != null && value.isNotEmpty) {
                  final currentValue = _initialValue['status'];
                  final newValue = value;

                  final allowedTransitions = {
        'Pending': ['Completed', 'Cancelled'],
        'Cancelled': ['Pending'],
        'Completed': ['Pending'],
      };

      if (currentValue != newValue) {
        if (allowedTransitions.containsKey(currentValue) &&
            allowedTransitions[currentValue] != null &&
            !allowedTransitions[currentValue]!.contains(newValue)) {
          return "Invalid status transition (Allowed transitions: Pending -> Completed/Cancelled; Cancelled -> Pending; Completed -> Pending)";
        }
      }
    }
    return null;
            },
          ),
          SizedBox(height: 10),
          FormBuilderTextField(
            decoration: InputDecoration(labelText: "Total amount"),
            name: 'iznos',
            readOnly: true,
          ),
          SizedBox(height: 10),
          FormBuilderTextField(
            decoration: InputDecoration(labelText: "Order date"),
            name: 'datum',
            readOnly: true,
          ),
          SizedBox(height: 20),

        Text(
          'Order details :',
          style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.normal,
          ),
)       ,
         // Prikazivanje stavki narudžbe
    if (stavkeNarudzbe.isNotEmpty)
    ...stavkeNarudzbe.asMap().entries.map((entry) {
    final index = entry.key;
    final stavka = entry.value;

    return Column(
      children: [
        FormBuilderTextField(
          decoration: InputDecoration(labelText: 'Quantity'),
          name: 'kolicina',
          readOnly: true,
          initialValue: stavka.kolicina.toString(),
        ),
        /* FormBuilderTextField(
          decoration: InputDecoration(labelText: 'Proizvod ID'),
          name: 'proizvodId',
          readOnly: true,
          initialValue: stavka.proizvodId.toString(),
        ), */
        FutureBuilder<String>(
          future: _getProductName(stavka.proizvodId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return FormBuilderTextField(
                decoration: InputDecoration(labelText: 'Product name'),
                name: 'nazivProizvoda_$index',
                readOnly: true,
                initialValue: snapshot.data ?? 'N/A',
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
        SizedBox(height: 20),
      ],
    );
  }).toList(),

          SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();
                    print(_formKey.currentState?.value);

                    var request = Map<String, dynamic>.from(_formKey.currentState!.value);

                    try {
                      if (widget.narudzba == null) {
                        await _ordersProvider.insert(request);
                      } else {
                        print(request);
                        await _ordersProvider.update(
                          widget.narudzba!.narudzbaId!,
                          request,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Order status successfully updated.'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    } on Exception catch (e) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Text("Error"),
                          content: Text(e.toString()),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("OK"),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                },
                child: Text("Save"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<String> _getProductName(int? productId) async {
    if (productId == null) {
      return 'N/A';
    }

    try {
      var product = await productProvider.getById(productId);
      return product.naziv ?? 'N/A';
    } catch (e) {
      return 'N/A';
    }
  }
  
  bool isValidStatusTransition(String? currentStatus, String? newStatus) {
  if (currentStatus == newStatus) {
    return true;
  }

  switch (currentStatus) {
    case "Pending":
      return newStatus == "Completed" || newStatus == "Cancelled";
    case "Cancelled":
      return newStatus == "Pending";
    case "Completed":
      return newStatus == "Pending";
    default:
      throw Exception("Invalid status transition");
  }
}
}