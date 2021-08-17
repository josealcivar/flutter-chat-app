import 'package:chat_app/global/evironment.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  Online,
  Offline,
  Connecting,
}

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => this._serverStatus;

  IO.Socket get socket => this._socket;
  Function get emit => this._socket.emit;

  // SocketService() {
  //   this.connect();
  // }

  void connect() async {
    final token = await AuthService.getToken();
    print(token);
    // String urlSocket = 'https://flutter-socket-server-jose.herokuapp.com/';
    String urlSocket = Enviroment.socketUrl;
    print("esta aqui");
    this._socket = IO.io(
        urlSocket,
        IO.OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .enableAutoConnect()
            .enableForceNew()
            .setExtraHeaders({'x-token': token}) // optional
            .build());

    // , {
    //   'transports': ['websocket'],
    //   'autoConnect': true
    // });
    //

    this._socket.onConnect((_) {
      print('connect');
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });
    print("hola");

    this._socket.onDisconnect((_) {
      this._serverStatus = ServerStatus.Offline;
      print('disconnect');
      notifyListeners();
    });
    // socket.on('fromServer', (_) => print(_));

    this._socket.on('emitir-mensaje', (payload) {
      print('emitir-mensaje: $payload');
    });
  }

  void disconnect() {
    this._socket.disconnect();
  }
}
