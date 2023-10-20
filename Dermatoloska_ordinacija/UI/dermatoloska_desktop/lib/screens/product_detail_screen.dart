// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'dart:io';
import 'package:dermatoloska_desktop/models/product.dart';
import 'package:dermatoloska_desktop/models/search_result.dart';
import 'package:dermatoloska_desktop/models/vrste_proizvoda.dart';
import 'package:dermatoloska_desktop/providers/product_provider.dart';
import 'package:dermatoloska_desktop/providers/vrste_proizvoda_provider.dart';
import 'package:dermatoloska_desktop/widgets/master_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class ProductDetailScreen extends StatefulWidget {
  Product? product;
  ProductDetailScreen({super.key, this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {

  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late VrsteProizvodaProvider _vrsteProizvodaProvider;
  late ProductProvider _productProvider;

  SearchResult<VrsteProizvoda>? VrsteProizvodaResult;
  bool isLoading = true; 

  @override
  void initState() { 
    super.initState();
    _initialValue = {
      'sifra' : widget.product?.sifra,
      'naziv' : widget.product?.naziv,
      'cijena' : widget.product?.cijena.toString(),
      'dostupno' : widget.product?.dostupno.toString(),
      'vrstaId' : widget.product?.vrstaId.toString(),
      };

      _vrsteProizvodaProvider = context.read<VrsteProizvodaProvider>(); 
      _productProvider = context.read<ProductProvider>(); 

      initForm();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future initForm() async{
    VrsteProizvodaResult = await _vrsteProizvodaProvider.get();
    print(VrsteProizvodaResult);

    //kada se sve ucitalo u setState
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var productDetailState = Provider.of<ProductDetailState>(context, listen: false);

    return MasterScreenWidget(                        
      // ignore: sort_child_properties_last
      child: Column(children: [
        isLoading ? Container() : _buildForm(), 
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(padding: EdgeInsets.all(10),
            child: ElevatedButton(onPressed: () async {
               final isPriceValid = _formKey.currentState!.fields['cijena']?.validate();
    if (isPriceValid == null || !isPriceValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fix the price before saving.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
              _formKey.currentState?.saveAndValidate();

              print(_formKey.currentState?.value);
    
              var request = new Map.from(_formKey.currentState!.value); 
              request['slika'] = _base64Image;

              print(request['slika']);
              
              try {
                if(widget.product == null) { 
                    await _productProvider.insert(request);
                     ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Product successfully added.'),
                      backgroundColor: Colors.green,
                     ),
                    );
                } else{
                  print(request);
                  await _productProvider.update(widget.product!.proizvodID!, request);
                   ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Product successfully updated.'),
                      backgroundColor: Colors.green,
                     ),
                    );
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
      title: this.widget.product?.naziv ?? "Product details",
    );
  }

  FormBuilder _buildForm() {
    return FormBuilder(
  key: _formKey,
  initialValue: _initialValue,
  child:  Column(children: [
    Row(
      children: [
        Expanded(
          child: FormBuilderTextField(
            decoration: InputDecoration(labelText: "Product code"),
            name: 'sifra',
            ),
        ),
        SizedBox(width: 10,),
          Expanded(
            child: FormBuilderTextField(
            decoration: InputDecoration(labelText: "Product name"),
            name: 'naziv',
            ),
          ),
      ],
    ),
    Row(
      children: [
        Expanded(child: FormBuilderDropdown<String>(
  name: 'vrstaId',
  decoration: InputDecoration(
    labelText: 'Product Type',
    suffix: IconButton(
      icon: const Icon(Icons.close),
      onPressed: () {
        _formKey.currentState!.fields['vrstaId']
            ?.reset();
      },
    ),
  ),
  items: VrsteProizvodaResult?.result
      .map((item) => DropdownMenuItem(
            alignment: AlignmentDirectional.center,
            value: item.vrstaId.toString(),
            child: Text(item.naziv ?? ""),
          ))
      .toList() ?? [],
),),
Expanded(
          child: FormBuilderTextField(
  decoration: InputDecoration(labelText: "Price"),
  name: 'cijena',
  validator: (value) {
    if (value!.isEmpty) {
      return "Price is required";
    }
    final cijena = double.tryParse(value);
    if (cijena == null) {
      return "Price must be a number";
    }
    if (cijena < 0 || cijena > 10000) {
      return "Price must be between 0 and 10,000";
    }
    return null; 
  },
)

        ),
      ],
    ),
    Row(children: [
      Expanded(child: 
      FormBuilderField(
        name: 'imageId',
        builder: ((field){
          return InputDecorator(decoration: InputDecoration(label: Text('Select image'), errorText: field.errorText), 
          child: ListTile(
            leading: Icon(Icons.photo),
            title: Text('Select image here'),
            trailing: Icon(Icons.file_upload),
            onTap: getImage,
          ),
          );
        }),
      ))
    ],)
  ],
  )
    );
  }
  
  File? _image;
  String? _base64Image;

  Future getImage() async {
    var result = await FilePicker.platform.pickFiles(type: FileType.image);

    if(result != null && result.files.single.path != null){ 
      _image = File(result.files.single.path!);
      _base64Image = base64Encode(_image!.readAsBytesSync());
    }
  }
}