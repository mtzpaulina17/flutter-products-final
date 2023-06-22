import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;
import 'package:productos_app/share_preferences/preferences.dart';


class AuthService extends ChangeNotifier {

  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String _firebaseToken = 'AIzaSyB4Gucc_AjNli4Tb7Js3ZDcEjxWsFLOiM8';

  // Si retornamos algo, es un error, si no, todo bien!
  Future<String?> createUser( String email, String password ) async {

    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final url = Uri.https(_baseUrl, '/v1/accounts:signUp', {
      'key': _firebaseToken
    });

    final resp = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodedResp = json.decode( resp.body );

    //print(decodedResp['idToken']);

    //String token = decodedResp['idToken'];

    if ( decodedResp.containsKey('idToken') ) {
        // Token hay que guardarlo en un lugar seguro

        Preferences.setToken(decodedResp['idToken']);

        //await storage.write(key: 'token', value: decodedResp['idToken']);
        // decodedResp['idToken'];
        return null;
    } else {
      return decodedResp['error']['message'];
    }

  }

    Future<String?> login( String email, String password ) async {

    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final url = Uri.https(_baseUrl, '/v1/accounts:signInWithPassword', {
      'key': _firebaseToken
    });

    final resp = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodedResp = json.decode( resp.body );

    if ( decodedResp.containsKey('idToken') ) {
        // Token hay que guardarlo en un lugar seguro
        // decodedResp['idToken'];
        
        Preferences.setToken(decodedResp['idToken']);
        //await storage.write(key: 'token', value: decodedResp['idToken']);
        return null;
    } else {
      return decodedResp['error']['message'];
    }

  }

  Future logout() async {
    await Preferences.clearPrefs();
    return;
  }

  String readToken()  {
    return Preferences.getToken();
  }

  Future<bool> checkToken () async {
    final token = readToken();
    return await token.isNotEmpty;
  }

}