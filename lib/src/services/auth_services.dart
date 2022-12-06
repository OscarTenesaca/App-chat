import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../global/environment.dart';
import '../models/login_response.dart';
import '../models/user.dart';
import '../utils/dio.dart';

class AuthService with ChangeNotifier {
  Usuario? usuario;
  bool _autenticando = false;

// Create storage
  final _storage = new FlutterSecureStorage();

  bool get getAutenticando => _autenticando;

  set setAutenticando(bool valor) {
    _autenticando = valor;
    notifyListeners();
  }

  final url = Environment.url;

  // get de token

  static Future<String?> getToken() async {
    final _storage = FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;
  }

  static Future<void> deleteToken() async {
    final _storage = FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  // LOGIN
  Future<bool> customerLogin(Map body) async {
    setAutenticando = true;

    final response =
        await Dio().post('$url/api/login/', data: body, options: dioOptions);

    setAutenticando = false;
    if (response.statusCode == 200) {
      final loginResponse = loginResponseFromJson(response.data);
      usuario = loginResponse.usuario;
      // TODO: tocken
      await _guardarToken(loginResponse.token);
      return true;
    } else {
      return false;
    }
  }

  // Register

  Future customerRegister(Map body) async {
    setAutenticando = true;

    final response =
        await Dio().post('$url/api/login/new', data: body, options: dioOptions);

    setAutenticando = false;

    if (response.statusCode == 200) {
      final loginResponse = loginResponseFromJson(response.data);
      usuario = loginResponse.usuario;
      // TODO: tocken
      await _guardarToken(loginResponse.token);
      return true;
    } else {
      return response.data['msg'];
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'token');

    final dio = Dio();
    dio.options.headers['x-token'] = token;

    final response = await dio.get('$url/api/login/renew', options: dioOptions);

    if (response.statusCode == 200) {
      final loginResponse = loginResponseFromJson(response.data);
      usuario = loginResponse.usuario;
      // TODO: tocken
      await _guardarToken(loginResponse.token);
      return true;
    } else {
      logout();
      return false;
    }
  }

  Future _guardarToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    await _storage.delete(key: 'token');
  }
}
