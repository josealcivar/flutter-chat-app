import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:chat_app/global/evironment.dart';

import 'package:chat_app/models/login_response.dart';
import 'package:chat_app/models/usuario.dart';
import 'package:flutter/cupertino.dart';

class AuthService with ChangeNotifier {
  late Usuario usuario;
  bool _autenticando = false;
  final _storage = new FlutterSecureStorage();

  // sirve para notificar que esta autenticando
  bool get autenticando => this._autenticando;
  set autenticando(bool valor) {
    this._autenticando = valor;
    notifyListeners();
  }

//Getters del token de forma estatica
  static Future<String?> getToken() async {
    final _storage = new FlutterSecureStorage();
    return await _storage.read(key: 'token');
  }

  static Future deleteToken() async {
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
    // return token;
  }

  Future<bool> login(String email, String password) async {
    this.autenticando = true;

    final data = {'email': email, 'password': password};
    print("data");
    print(data);
    final url = Uri.parse('${Enviroment.apiUrl}/login');
    final resp = await http.post(url,
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(data));
    print("body");
    print(resp.body);
    this.autenticando = false;
    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.usuario = loginResponse.usuario;
      await this._guardarToken(loginResponse.token); // guarda el token
      // TODO guardar token en lugar seguro
      return true;
    } else {
      return false;
    }
  }

  Future register(String nombre, String email, String password) async {
    this.autenticando = true;
    final data = {'nombre': nombre, 'email': email, 'password': password};

    final url = Uri.parse('${Enviroment.apiUrl}/login/new');
    final resp = await http.post(url,
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    this.autenticando = false;

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.usuario = loginResponse.usuario;
      await this._guardarToken(loginResponse.token);

      return true;
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await this._storage.read(key: 'token');
    final url = Uri.parse('${Enviroment.apiUrl}/login/renew');

    final resp = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json',
      'x-token': '$token'
    });
    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.usuario = loginResponse.usuario;
      await this._guardarToken(loginResponse.token);
      return true;
    } else {
      this.logOut();
      return false;
    }
  }

  Future _guardarToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future logOut() async {
    await _storage.delete(key: 'token');
  }
}
