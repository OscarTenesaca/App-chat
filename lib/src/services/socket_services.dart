import 'dart:developer';

import 'package:chat_app/src/services/auth_services.dart';
import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../global/environment.dart';

enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  final url = Environment.url;

  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket? _socket;

  ServerStatus get getServerStatus => _serverStatus;

  IO.Socket get getSocket => _socket!;
  Function get emit => _socket!.emit;

  void connectIO() async {
    final token = await AuthService.getToken();

    // Dart client
    // _socket = IO.io('http://localhost:3000', {
    _socket = IO.io(url, {
      'transports': ['websocket'],
      'autoConnect': true,
      'forceNew': true,
      'extraHeaders': {
        'x-token': token,
      }
    });

    _socket?.onConnect((_) {
      log('connect');
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    _socket?.onDisconnect((_) {
      log('disconnect');
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
    // _socket!.on('connect', (_) {
    //   _serverStatus = ServerStatus.Online;
    //   notifyListeners();
    // });

    // _socket!.on('disconnect', (_) {
    //   _serverStatus = ServerStatus.Offline;
    //   notifyListeners();
    // });
  }

  void disconnectIO() {
    _socket?.disconnect();
  }
}
