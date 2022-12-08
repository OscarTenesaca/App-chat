import 'dart:developer';

import 'package:chat_app/src/models/user.dart';
import 'package:chat_app/src/models/usuario_response.dart';
import 'package:chat_app/src/services/auth_services.dart';
import 'package:dio/dio.dart';

import '../global/environment.dart';
import '../utils/dio.dart';

class UsuarioServices {
  final url = Environment.url;

  Future<List<Usuario>?> getUsuarios() async {
    final dio = Dio();

    dio.options.headers['x-token'] = await AuthService.getToken();

    try {
      final response = await dio.get('$url/api/usuarios/', options: dioOptions);

      final usuariosResponse = usuariosResponseFromJson(response.data);
      return usuariosResponse.usuario;
    } catch (e) {
      return [];
    }
  }
}
