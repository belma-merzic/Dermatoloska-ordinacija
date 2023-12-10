import 'package:dermatoloska_desktop/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/novost.dart';
import '../providers/novosti_provider.dart';

class NovostDetailScreen extends StatefulWidget {
  Novost? novost;
  NovostDetailScreen({super.key, this.novost});

  @override
  State<NovostDetailScreen> createState() => _NovostDetailScreenState();
}

class _NovostDetailScreenState extends State<NovostDetailScreen> {

  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late NovostiProvider _novostProvider;
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
      _novostProvider = context.read<NovostiProvider>(); 
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
      // ignore: sort_child_properties_last
      child: Column(
        children: [
        isLoading ? Container() : _buildForm(),  
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(padding: EdgeInsets.all(10),
            child: ElevatedButton(onPressed: () async {
              _formKey.currentState?.saveAndValidate();

              print(_formKey.currentState?.value);
    
              var request = new Map.from(_formKey.currentState!.value); 
              
              try {
                if(widget.novost == null) { 
                    await _novostProvider.insert(request);
                    ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('News successfully added.'),
                      backgroundColor: Colors.green,
                     ));
                     _formKey.currentState?.reset();
                     Navigator.pop(context, 'reload');
                } else{
                  print(request);
                  await _novostProvider.update(widget.novost!.novostId!, request);
                   ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('News successfully updated.'),
                      backgroundColor: Colors.green,
                     ));
                     Navigator.pop(context, 'reload');
                }
              }on Exception catch (e) {
                    showDialog(
                          context: context, 
                          builder: (BuildContext context) => AlertDialog(
                           title: Text("Error"),
                           content: Text(e.toString()),
                           actions: [
                            TextButton(onPressed: ()=> Navigator.pop(context), child: Text("OK"))
                           ],
                          ));
                  }
            }, child: Text("Save")),)
        ],)
      ]), 
      title: this.widget.novost?.naslov ?? "News",
    );
  }

  FormBuilder _buildForm() {
    return FormBuilder(
  key: _formKey,
  initialValue: _initialValue,
  child: Row(
       children: [
        Expanded(
          child: FormBuilderTextField(
            decoration: InputDecoration(labelText: "Title"),
            name: 'naslov',
            ),
        ),
        SizedBox(width: 10,),
          Expanded(
            child: FormBuilderTextField(
            decoration: InputDecoration(labelText: "Content"),
            name: 'sadrzaj',
            ),
          ),
          SizedBox(width: 10,),
          Expanded(
            child: FormBuilderTextField(
            decoration: InputDecoration(labelText: "Publication Date"),
            name: 'datumObjave',
            controller: _dateController,
            readOnly: true, 
          ),
),
      ],
    ),
  );
  }
}