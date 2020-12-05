import 'package:flutter/material.dart';
import 'package:flutter_form_validation/src/blocs/provider.dart';
import 'package:flutter_form_validation/src/screens/home_screen.dart';
import 'package:flutter_form_validation/src/screens/login_screen.dart';

void main() async {
  // AQUÍ PODEMOS EXTRAER DATOS QUE NECESITEMOS ANTES DE TERMINAR LA SPLASH SCREEN
  //await Future.delayed(Duration(seconds: 5), () => print('cargado con retraso'));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        title: 'Formularios',
        initialRoute: 'login',
        routes: {
          'login': (BuildContext context) => LoginScreen(),
          'home': (BuildContext context) => HomeScreen(),
        },
        theme: ThemeData(
          primaryColor: Colors.deepPurple
        ),
      )
    );
  }
}
