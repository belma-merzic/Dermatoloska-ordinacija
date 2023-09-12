import 'package:dermatoloska_mobile/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import '../models/novost.dart';

class NovostDetailScreen extends StatefulWidget {
  Novost? novost;
  NovostDetailScreen({super.key, this.novost});

  @override
  State<NovostDetailScreen> createState() => _NovostDetailScreenState();
}

class _NovostDetailScreenState extends State<NovostDetailScreen> {

  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};

  final _dateController = TextEditingController();

  bool isLoading = true; 

  @override
  void initState() { 
    super.initState();
    _initialValue = {
      'naslov' : widget.novost?.naslov,
      'sadrzaj' : widget.novost?.sadrzaj,
      'datumObjave' : widget.novost?.datumObjave,
      };
      initForm();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void _setCurrentDate() {
  final currentDate = DateTime.now();
  final formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);
  _dateController.text = formattedDate;
}

  Future initForm() async{
    setState(() {
      isLoading = false;
    });

     _setCurrentDate(); 
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: Column(
        children: [
          isLoading ? Container() : _buildForm(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(padding: EdgeInsets.all(10),),
            ],
          )
        ],
      ),
      title: this.widget.novost?.naslov ?? "Novost details",
    );
  }

  FormBuilder _buildForm() {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      child: Column( 
        children: [
          FormBuilderTextField(
            decoration: InputDecoration(labelText: "Title"),
            name: 'naslov',
            readOnly: true,
          ),
          SizedBox(height: 10), 
          FormBuilderTextField(
            decoration: InputDecoration(labelText: "Content"),
            name: 'sadrzaj',
            readOnly: true,
          ),
          SizedBox(height: 10), 
          FormBuilderTextField(
            decoration: InputDecoration(labelText: "Publication Date"),
            name: 'datumObjave',
            controller: _dateController,
            readOnly: true,
          ),
        ],
      ),
    );
  }
}
