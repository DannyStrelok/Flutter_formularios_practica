import 'package:flutter/material.dart';
import 'package:flutter_form_validation/src/blocs/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final bloc = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('email: ${bloc.email}'),
          Divider(),
          Text('password: ${bloc.password}'),
        ],
      ),
    );
  }
}
