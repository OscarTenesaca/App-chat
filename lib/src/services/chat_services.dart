import 'package:chat_app/src/models/mensajes_response.dart';
import 'package:chat_app/src/models/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../global/environment.dart';
import '../utils/dio.dart';
import 'auth_services.dart';

class ChatServices with ChangeNotifier {
  Usuario? usuarioPara;

  final url = Environment.url;

  Future<List<Mensaje>?> getChat(String usuarioId) async {
    final dio = Dio();

    dio.options.headers['x-token'] = await AuthService.getToken();

    try {
      final response =
          await dio.get('$url/api/mensajes/$usuarioId', options: dioOptions);

      final usuariosResponse = mensajesResponseFromJson(response.data);
      return usuariosResponse.mensajes;
    } catch (e) {
      return [];
    }
  }
}
