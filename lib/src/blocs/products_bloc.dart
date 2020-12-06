import 'dart:io';

import 'package:flutter_form_validation/src/providers/products_provider.dart';
import 'package:rxdart/rxdart.dart';

import 'package:flutter_form_validation/src/models/product_model.dart';

class ProductsBloc {

  final _productsController = new BehaviorSubject<List<ProductModel>>();
  final _loadingController = new BehaviorSubject<bool>();

  final _productsProvider = new ProductsProvider();

  Stream<List<ProductModel>> get productsStream => _productsController.stream;
  Stream<bool> get loading => _loadingController.stream;

  void loadProducts() async {
    final products = await _productsProvider.loadProducts();
    _productsController.sink.add(products);
  }

  void insertProduct( ProductModel product ) async {
    _loadingController.sink.add(true);
    await _productsProvider.insertProduct(product);
    _loadingController.sink.add(false);
  }

  Future<String> uploadPicture( File picture ) async {
    _loadingController.sink.add(true);
    final pictureUrl = await _productsProvider.uploadPicture(picture);
    _loadingController.sink.add(false);
    return pictureUrl;
  }

  void updateProduct( ProductModel product ) async {
    _loadingController.sink.add(true);
    await _productsProvider.editProduct(product);
    _loadingController.sink.add(false);
  }

  void deleteProduct( String id ) async {
    await _productsProvider.removeProduct(id);
  }

  dispose() {
    _productsController?.close();
    _loadingController?.close();
  }

}