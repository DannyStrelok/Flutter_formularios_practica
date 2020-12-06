import 'dart:convert';

import 'package:flutter_form_validation/src/shared_preferences/user_preferences.dart';
import 'package:http/http.dart' as http;

class UserProvider {

  final String _firebaseToken = 'AIzaSyDE4fuexzBiGlap_Y5XYeN97bRnqdeXlP0';
  final _preferences = new UserPreferences();

  Future<Map<String, dynamic>> login(String email, String password) async {

    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final response = await http.post(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebaseToken',
        body: json.encode(authData)
    );

    Map<String, dynamic> decodedResponse = json.decode(response.body);

    print(decodedResponse);

    if( decodedResponse.containsKey('idToken') ) {
      // GUARDAMOS EL TOKEN EN STORAGE
      _preferences.token = decodedResponse['idToken'].toString();
      return {
        'ok': true,
        'token': decodedResponse['idToken']
      };
    } else {
      return {
        'ok': false,
        'msg': decodedResponse['error']['message']
      };
    }

  }

  Future<Map<String, dynamic>> newUser(String email, String password) async {

    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final response = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseToken',
      body: json.encode(authData)
    );

    Map<String, dynamic> decodedResponse = json.decode(response.body);

    print(decodedResponse);

    if( decodedResponse.containsKey('idToken') ) {
      // GUARDAMOS EL TOKEN EN STORAGE
      _preferences.token = decodedResponse['idToken'].toString();
      return {
        'ok': true,
        'token': decodedResponse['idToken']
      };
    } else {
      return {
        'ok': false,
        'msg': decodedResponse['error']['message']
      };
    }

  }



}