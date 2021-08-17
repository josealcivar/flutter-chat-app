// import 'dart:ui';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/socket_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:chat_app/models/usuario.dart';

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final usuarios = [
    new Usuario(
        online: true, email: 'email@mail.com', nombre: 'juan', uid: '1'),
    new Usuario(
        online: false, email: 'test1@mail.com', nombre: 'maria', uid: '2'),
    new Usuario(
        online: true, email: 'test2@mail.com', nombre: 'jose', uid: '3'),
    new Usuario(
        online: true, email: 'test3@mail.com', nombre: 'Arturo', uid: '4'),
  ];

  @override
  Widget build(BuildContext context) {
    final authServise = Provider.of<AuthService>(context, listen: false);
    final socketService = Provider.of<SocketService>(context);
    final usuario = authServise.usuario;
    return Scaffold(
      appBar: AppBar(
        title: Text(usuario.nombre,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black87)),
        elevation: 3,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.exit_to_app,
            color: Colors.blue.shade900,
          ),
          onPressed: () {
            //TODO desconcetarnos del socket server

            AuthService.deleteToken();
            socketService.disconnect();
            Navigator.pushReplacementNamed(context, 'login');
          },
        ),
        actions: <Widget>[
          Container(
              margin: EdgeInsets.only(right: 10),
              child: (socketService.serverStatus == ServerStatus.Online)
                  ? Icon(Icons.check_circle, color: Colors.green)
                  : Icon(Icons.offline_bolt, color: Colors.red)),
        ],
      ),
      body: SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          onRefresh: _cargarUsuarios,
          header: WaterDropHeader(
            complete: Icon(Icons.check, color: Colors.blue.shade400),
          ),
          child: _listViewUsuarios()),
    );
  }

  ListView _listViewUsuarios() {
    return ListView.separated(
        physics: BouncingScrollPhysics(),
        itemBuilder: (_, i) => _usuarioListTile(usuarios[i]),
        separatorBuilder: (_, i) => Divider(),
        itemCount: usuarios.length);
  }

  ListTile _usuarioListTile(Usuario usuario) {
    return ListTile(
        title: Text(usuario.nombre),
        leading: CircleAvatar(
          child: Text(usuario.nombre.substring(0, 2)),
        ),
        trailing: Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
                color: usuario.online ? Colors.green.shade300 : Colors.red,
                borderRadius: BorderRadius.circular(200))));
  }

  void _cargarUsuarios() async {
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }
}
