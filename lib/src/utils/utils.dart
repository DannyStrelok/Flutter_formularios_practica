
import 'package:flutter/material.dart';

bool isNumeric(String value) {

  if(value.isEmpty) return false;

  final n = num.tryParse(value);

  return (n == null) ? false : true;

}

void showAlert(BuildContext context, String msg) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Datos incorrectos'),
        content: Text(msg),
        actions: [
          FlatButton(
            child: Text('Cerrar'),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      );
    }
  );
}