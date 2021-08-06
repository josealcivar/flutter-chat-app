import 'package:chat_app/widgets/boton_azul.dart';
import 'package:chat_app/widgets/custom_input.dart';
import 'package:chat_app/widgets/custom_label.dart';

import 'package:chat_app/widgets/custom_logo.dart';
import 'package:flutter/material.dart';

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
              textController: emailCtrl),

          CustomImput(
              icon: Icons.email_outlined,
              placeholder: 'correo',
              keyboardType: TextInputType.emailAddress,
              textController: passCtrl),

          CustomImput(
            icon: Icons.lock_outline,
            placeholder: 'contrasena',
            keyboardType: TextInputType.text,
            textController: passCtrl,
            isPassword: true,
          ),

          //TODO: crear boton
          BotonAzul(
            text: 'Registrar',
            onPressed: () {
              print(emailCtrl.text);
              print(passCtrl.text);
            },
          )
        ],
      ),
    ));
  }
}
