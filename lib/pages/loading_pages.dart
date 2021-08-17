import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/pages/user_page.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/socket_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (context, snapshop) {
          return Center(
            child: Text('Loading...'),
          );
        },
      ),
    );
  }

  Future checkLoginState(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final socketService = Provider.of<SocketService>(context);

    final autenticado = await authService.isLoggedIn();

    if (autenticado) {
      socketService.connect();
      // Navigator.pushReplacementNamed(context, 'usuario');

      Navigator.pushReplacement(
          context, PageRouteBuilder(pageBuilder: (_, __, ___) => UsersPage()));
    } else {
      Navigator.pushReplacement(
          context, PageRouteBuilder(pageBuilder: (_, __, ___) => LoginPage()));
      // Navigator.pushReplacementNamed(context, 'login');
    }
  }
}
