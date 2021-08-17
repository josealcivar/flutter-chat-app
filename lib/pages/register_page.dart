import 'package:chat_app/services/socket_services.dart';
import 'package:chat_app/widgets/boton_azul.dart';
import 'package:chat_app/widgets/custom_input.dart';
import 'package:chat_app/widgets/custom_label.dart';
import 'package:chat_app/helpers/mostrar_alerta.dart';

import 'package:chat_app/services/auth_service.dart';

import 'package:chat_app/widgets/custom_logo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Logo(titulo: 'Registro'),
                _Form(),
                Labels(
                    ruta: 'login',
                    titulo: 'ya tienes cuenta?',
                    subtitulo: 'Ingresa ahora!'),
                Text('Terminos y condiciones de uso',
                    style: TextStyle(
                      fontWeight: FontWeight.w200,
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  const _Form({Key? key}) : super(key: key);

  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    return Container(
        child: Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: <Widget>[
          CustomImput(
              icon: Icons.person_outline,
              placeholder: 'Nombres',
              keyboardType: TextInputType.text,
              textController: nameCtrl),

          CustomImput(
              icon: Icons.email_outlined,
              placeholder: 'correo',
              keyboardType: TextInputType.emailAddress,
              textController: emailCtrl),

          CustomImput(
            icon: Icons.lock_outline,
            placeholder: 'contrasena',
            keyboardType: TextInputType.text,
            textController: passCtrl,
            isPassword: true,
          ),

          //TODO: crear boton
          BotonAzul(
            text: 'Crear cuenta',
            onPressed: authService.autenticando
                ? null
                : () async {
                    print(nameCtrl.text);
                    print(emailCtrl.text);
                    print(passCtrl.text);
                    FocusScope.of(context).unfocus();

                    final registerOk = await authService.register(
                        nameCtrl.text.trim(),
                        emailCtrl.text.trim(),
                        passCtrl.text.trim());
                    print(registerOk);
                    if (registerOk == true) {
                      // TODO conectar a socket server
                      socketService.connect();
                      Navigator.pushReplacementNamed(context, 'usuario');
                    } else {
                      //Mostrara alerta
                      mostrarAlerta(context, 'registro incorrecto', registerOk);
                    }
                  },
          )
        ],
      ),
    ));
  }
}
