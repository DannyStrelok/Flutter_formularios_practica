import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter_form_validation/src/models/product_model.dart';
import 'package:mime/mime.dart';

class ProductsProvider {

  final String _url = 'https://flutter-proyectos-c866b-default-rtdb.europe-west1.firebasedatabase.app';

  Future<bool> insertProduct(ProductModel product) async {
    
    final url = '$_url/productos.json';
    
    final resp = await http.post(url, body: productModelToJson(product) );

    final decodedData = json.decode(resp.body);
    print(decodedData);

    return true;
    
  }

  Future<bool> editProduct(ProductModel product) async {

    final url = '$_url/productos/${product.id}.json';

    final resp = await http.put(url, body: productModelToJson(product) );

    final decodedData = json.decode(resp.body);
    print(decodedData);

    return true;

  }


  Future<int> removeProduct(String id) async {

    final url = '$_url/productos/$id.json';

    final resp = await http.delete(url);

    print( json.decode(resp.body) );

    return 1;

  }

  Future<List<ProductModel>> loadProducts() async {

    final url = '$_url/productos.json';
    final resp = await http.get(url);

    final Map<String, dynamic> decodedData = json.decode(resp.body);
    final List<ProductModel> products = new List();

    if(decodedData == null) return [];

    decodedData.forEach((key, product) {
      final prodTemp = ProductModel.fromJson(product);
      prodTemp.id = key;
      products.add(prodTemp);
    });

    return products;

  }

  Future<String> uploadPicture( File picture ) async {

    final url = Uri.parse('https://api.cloudinary.com/v1_1/dip6wxhbw/image/upload?upload_preset=odabcx5h');
    final mimeType = lookupMimeType(picture.path).split('/');
    print(mimeType);

    final request = http.MultipartRequest(
      'POST',
      url
    );

    final file = await http.MultipartFile.fromPath('file', picture.path, contentType: MediaType( mimeType[0], mimeType[1] ) );

    request.files.add(file);

    final streamResponse = await request.send();

    final response = await http.Response.fromStream(streamResponse);

    if(response.statusCode != 200 && response.statusCode != 201) {
      print('ERROR AL SUBIR IMAGEN');
      print(response.body);
      return null;
    }

    final responseData = json.decode(response.body);
    print(responseData);

    return responseData['secure_url'];

  }


}