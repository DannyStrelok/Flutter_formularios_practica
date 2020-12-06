import 'package:flutter/material.dart';
import 'package:flutter_form_validation/src/blocs/products_bloc.dart';
import 'package:flutter_form_validation/src/blocs/provider.dart';
import 'package:flutter_form_validation/src/models/product_model.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final productsBloc = Provider.productsBloc(context);
    productsBloc.loadProducts();

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: _productList(productsBloc),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, 'product'),
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }

  Widget _productList(ProductsBloc productsBloc) {

    return StreamBuilder(
      stream: productsBloc.productsStream,
      builder: (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot) {
        if(snapshot.hasData) {
          final products = snapshot.data;
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) => _productItem(context, products[index], productsBloc),
          );
        }
        return Center(child: CircularProgressIndicator(),);
      },
    );

    // return FutureBuilder(
    //   future: productsProvider.loadProducts(),
    //   builder: (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot) {
    //     if(snapshot.hasData) {
    //       final products = snapshot.data;
    //       return ListView.builder(
    //         itemCount: products.length,
    //         itemBuilder: (context, index) => _productItem(context, products[index]),
    //       );
    //     }
    //     return Center(child: CircularProgressIndicator(),);
    //   },
    // );
  }

  Widget _productItem(BuildContext context, ProductModel product, ProductsBloc productsBloc) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        productsBloc.deleteProduct(product.id);
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
