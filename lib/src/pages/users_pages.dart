import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../models/user.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final List<User> usuarios = [
    User(uid: '1', nombre: 'Oscar', email: 'test1@test.com', online: true),
    User(uid: '2', nombre: 'maria', email: 'test2@test.com', online: false),
    User(uid: '3', nombre: 'ana', email: 'test3@test.com', online: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mi nombre',
          style: TextStyle(color: Colors.black87),
        ),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.exit_to_app,
            color: Colors.black87,
          ),
          onPressed: () {},
        ),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10),
            child: Icon(Icons.check_circle, color: Colors.blue[400]),
            // child: Icon(Icons.offline_bolt, color: Colors.red[400]),
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

  ListTile _usuarioListTitle(User usuario) {
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
    );
  }

  void _cargarUsuarios() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }
}
