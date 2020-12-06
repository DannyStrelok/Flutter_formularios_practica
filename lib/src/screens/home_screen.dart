import 'package:flutter/material.dart';
import 'package:flutter_form_validation/src/blocs/provider.dart';
import 'package:flutter_form_validation/src/models/product_model.dart';
import 'package:flutter_form_validation/src/providers/products_provider.dart';

class HomeScreen extends StatelessWidget {
  final productsProvider = new ProductsProvider();

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: _productList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, 'product'),
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }

  Widget _productList() {
    return FutureBuilder(
      future: productsProvider.loadProducts(),
      builder: (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot) {
        if(snapshot.hasData) {
          final products = snapshot.data;
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) => _productItem(context, products[index]),
          );
        }
        return Center(child: CircularProgressIndicator(),);
      },
    );
  }

  Widget _productItem(BuildContext context, ProductModel product) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        productsProvider.removeProduct(product.id);
      },
      child: Card(
        child: Column(
          children: [
            (product.fotoUrl == null)
              ? Image(image: AssetImage('assets/no-image.png'), height: 300.0,)
                : FadeInImage(placeholder: AssetImage('assets/jar-loading.gif'), image: NetworkImage(product.fotoUrl), fit: BoxFit.cover, height: 300.0,),
            ListTile(
            title: Text('${product.titulo} - ${product.valor}'),
            subtitle: Text(product.id),
            onTap: () => Navigator.pushNamed(context, 'product', arguments: product),
            ),
          ],
        ),
      )
    );
  }


}
