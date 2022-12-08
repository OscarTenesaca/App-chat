import 'dart:developer';

import 'package:chat_app/src/services/chat_services.dart';
import 'package:chat_app/src/services/usuario_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../models/user.dart';
import '../services/auth_services.dart';
import '../services/socket_services.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final usuarioServices = UsuarioServices();

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  List<Usuario> usuarios = [];
  // final List<Usuario> usuarios = [
  //   Usuario(uid: '1', nombre: 'Oscar', email: 'test1@test.com', online: true),
  //   Usuario(uid: '2', nombre: 'maria', email: 'test2@test.com', online: false),
  //   Usuario(uid: '3', nombre: 'ana', email: 'test3@test.com', online: true),
  // ];/

  @override
  void initState() {
    _cargarUsuarios();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketServ = Provider.of<SocketService>(context);

    final user = authService.usuario;

    log('${socketServ.getServerStatus}');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${user?.nombre}',
          style: TextStyle(color: Colors.black87),
        ),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.exit_to_app,
            color: Colors.black87,
          ),
          onPressed: () {
            // desconectar socket
            socketServ.disconnectIO();
            Navigator.pushReplacementNamed(context, 'routelogin');
            AuthService.deleteToken();
          },
        ),
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: (socketServ.getServerStatus == ServerStatus.Online)
                ? Icon(Icons.check_circle, color: Colors.blue[400])
                : Icon(Icons.offline_bolt, color: Colors.red[400]),
          )
        ],
      ),
      body: SmartRefresher(
        header: WaterDropHeader(
          complete: Icon(Icons.check, color: Colors.blue[400]),
          waterDropColor: Colors.blue,
        ),
        onRefresh: _cargarUsuarios,
        controller: _refreshController,
        child: _listViewUsuario(),
      ),
    );
  }

  ListView _listViewUsuario() {
    return ListView.separated(
      itemCount: usuarios.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemBuilder: (BuildContext context, int index) =>
          _usuarioListTitle(usuarios[index]),
    );
  }

  ListTile _usuarioListTitle(Usuario usuario) {
    return ListTile(
      title: Text('${usuario.nombre}'),
      leading: CircleAvatar(
        child: Text('${usuario.nombre}'.substring(0, 2)),
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: usuario.online == true ? Colors.green : Colors.red,
            borderRadius: BorderRadius.circular(100)),
      ),
      subtitle: Text(usuario.email),
      onTap: () {
        print(usuario.nombre);
        final chatServ = Provider.of<ChatServices>(context, listen: false);
        chatServ.usuarioPara = usuario;
        Navigator.pushNamed(context, 'routeChat');
      },
    );
  }

  void _cargarUsuarios() async {
    print('nutoehntuh');
    usuarios = (await usuarioServices.getUsuarios())!;
    setState(() {
      _refreshController.refreshCompleted();
    });

    // await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
  }
}
