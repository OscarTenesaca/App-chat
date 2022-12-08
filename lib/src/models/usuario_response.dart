// To parse this JSON data, do
//
//     final usuariosResponse = usuariosResponseFromJson(jsonString);

import 'dart:convert';

import 'package:chat_app/src/models/user.dart';

// UsuariosResponse usuariosResponseFromJson(String str) =>
//     UsuariosResponse.fromJson(json.decode(str));
UsuariosResponse usuariosResponseFromJson(str) =>
    UsuariosResponse.fromJson(str);

String usuariosResponseToJson(UsuariosResponse data) =>
    json.encode(data.toJson());

class UsuariosResponse {
  UsuariosResponse({
    this.ok,
    this.usuario,
  });

  bool? ok;
  List<Usuario>? usuario;

  factory UsuariosResponse.fromJson(Map<String, dynamic> json) =>
      UsuariosResponse(
        ok: json["ok"],
        usuario:
            List<Usuario>.from(json["usuario"].map((x) => Usuario.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "usuario": List<dynamic>.from(usuario!.map((x) => x.toJson())),
      };
}
