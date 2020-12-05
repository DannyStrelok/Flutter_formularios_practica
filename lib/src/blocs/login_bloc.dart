import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_form_validation/src/blocs/validators.dart';

class LoginBloc with Validators {

  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  // RECUPERAR DATOS DEL STREAM
  Stream<String> get emailStream => _emailController.stream.transform(validateEmail);
  Stream<String> get passwordStream => _passwordController.stream.transform(validatePassword);
  Stream<bool> get formValidStream =>
    Rx.combineLatest2(emailStream, passwordStream, (a, b) => true);

  // INSERTAR VALORES AL STREAM, MANDAMOS REFERENCIA
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  // Obtener valores de los streams
  String get email => _emailController.value;
  String get password => _passwordController.value;

  dispose() {
    _emailController?.close();
    _passwordController?.close();
  }

}