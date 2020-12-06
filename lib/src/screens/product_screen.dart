import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_form_validation/src/models/product_model.dart';
import 'package:flutter_form_validation/src/providers/products_provider.dart';
import 'package:flutter_form_validation/src/utils/utils.dart' as Utils;

class ProductScreen extends StatefulWidget {

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {

  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  ProductModel product = new ProductModel();
  final productProvider = new ProductsProvider();
  bool _isSaving = false;

  File _image;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {

    final ProductModel productArguments = ModalRoute.of(context).settings.arguments;
    if(productArguments != null) {
      product = productArguments;
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Producto'),
        actions: [
          IconButton(icon: Icon(Icons.photo_size_select_actual), onPressed: _selectPicture),
          IconButton(icon: Icon(Icons.camera_alt), onPressed: _takePicture),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                _showPicture(),
                SizedBox(height: 15.0,),
                Divider(),
                SizedBox(height: 15.0,),
                _fieldName(),
                _fieldPrice(),
                _fieldAvailable(),
                _submitButton(context)
              ],
            ),
          ),
        ),
      )
    );
  }

  Widget _fieldName() {
    return TextFormField(
      initialValue: product.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Producto',
      ),
      onSaved: (value) => product.titulo = value,
      validator: (value) {
        if(value.length < 3) {
          return 'Nombre demasiado corto';
        }
        return null;
      },
    );
  }

  Widget _fieldPrice() {
    return TextFormField(
      initialValue: product.valor.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Precio',
      ),
      onSaved: (value) => product.valor = double.parse(value),
      validator: (value) {
        if( Utils.isNumeric(value) ) {
          return null;
        }
        return 'Solo valores numéricos';
      },
    );
  }

  Widget _submitButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: RaisedButton(
        onPressed: (_isSaving) ? null : () => _submit(context),
        child: Icon(Icons.save),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),
        color: Colors.deepPurple,
        textColor: Colors.white,
      ),
    );
  }

  Widget _fieldAvailable() {
    return SwitchListTile(
      value: product.disponible,
      title: Text('Disponible'),
      activeColor: Colors.deepPurple,
      onChanged: (value) => setState((){
        product.disponible = value;
      }),
    );
  }

  void _submit(BuildContext context) async {

    // SI NO ES VÁLIDO NO CONTINUAMOS
    if( !formKey.currentState.validate() ) return;
    formKey.currentState.save();

    setState(() {
      _isSaving = true;
    });


    if(_image != null) {
      product.fotoUrl = await productProvider.uploadPicture(_image);

    }

    if(product.id == null){
      productProvider.insertProduct(product);
    } else {
      productProvider.editProduct(product);
    }

    // setState(() {
    //   _isSaving = false;
    // });
    showSnackbar('Registro guardado');

    Navigator.popAndPushNamed(context, 'home');

  }

  void showSnackbar(String msg) {
    final snackbar = SnackBar(
      content: Text(msg),
      duration: Duration(microseconds: 1500),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }


  _showPicture() {

    print(product.fotoUrl);

    if(product.fotoUrl != null) {
      return FadeInImage(
        placeholder: AssetImage('assets/jar-loading.gif'),
        image: NetworkImage(product.fotoUrl),
        fit: BoxFit.contain,
        height: 200.0,
        width: double.infinity,
      );
    } else {
      return Image(
        image: AssetImage( _image?.path ?? 'assets/no-image.png'),
        height: 300.0,
        fit: BoxFit.cover,
      );
    }

  }

  _selectPicture() async {
    _processImage(ImageSource.gallery);
  }

  _takePicture() async {
    _processImage(ImageSource.camera);
  }

  _processImage( ImageSource type ) async {
    final pickedFile = await picker.getImage(source: type);
    setState(() {
      if(pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('NADA SELECCIONADO');
        _image = null;
        product.fotoUrl = null;
      }
    });
  }

}
