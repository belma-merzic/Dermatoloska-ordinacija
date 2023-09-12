import 'package:dermatoloska_desktop/models/narudzba.dart';
import 'package:dermatoloska_desktop/providers/orders_provider.dart';
import 'package:dermatoloska_desktop/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../main.dart';

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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initialValue = {
      'brojNarudzbe': widget.narudzba?.brojNarudzbe,
      'status': widget.narudzba?.status,
      'datum': widget.narudzba?.datum.toString(),
      'iznos': widget.narudzba?.iznos.toString(),
    };
    _ordersProvider = context.read<OrdersProvider>();
    initForm();
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
          child: isLoading ? Container() : _buildForm(),
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

            validator: (value) {
    if (value != null && (value.isEmpty || (value != "Cancelled" && value != "Completed" && value != "Pending"))) {
      return "Valid values are Cancelled, Completed, or Pending";
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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () async {
                   if (_formKey.currentState?.validate() ?? false){
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
}
