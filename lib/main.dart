import 'package:flutter/material.dart';
import 'package:flutter_form_validation/src/blocs/provider.dart';
import 'package:flutter_form_validation/src/screens/home_screen.dart';
import 'package:flutter_form_validation/src/screens/login_screen.dart';
import 'package:flutter_form_validation/src/screens/product_screen.dart';
import 'package:flutter_form_validation/src/screens/register_screen.dart';
import 'package:flutter_form_validation/src/shared_preferences/user_preferences.dart';

void main() async {
  // AQUÍ PODEMOS EXTRAER DATOS QUE NECESITEMOS ANTES DE TERMINAR LA SPLASH SCREEN
  //await Future.delayed(Duration(seconds: 5), () => print('cargado con retraso'));
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = new UserPreferences();
  await preferences.initPreferences();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final prefs = new UserPreferences();

    final String _initialRoute = (prefs.token != '') ? 'home' : 'login';

    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Formularios',
        initialRoute: _initialRoute,
        routes: {
          'login': (BuildContext context) => LoginScreen(),
          'home': (BuildContext context) => HomeScreen(),
          'product': (BuildContext context) => ProductScreen(),
          'registro': (BuildContext context) => RegisterScreen(),
        },
        theme: ThemeData(
          primaryColor: Colors.deepPurple
        ),
      )
    );
  }
}
