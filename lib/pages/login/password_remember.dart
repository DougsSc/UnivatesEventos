import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:minicurso/utils/alert.dart';
import 'package:minicurso/utils/api.dart';
import 'package:minicurso/utils/validator.dart';
import 'package:minicurso/widgets/button.dart';
import 'package:minicurso/widgets/text_field.dart';

import 'login_api.dart';

class PasswordRemember extends StatefulWidget {
  @override
  _PasswordRememberState createState() => _PasswordRememberState();
}

class _PasswordRememberState extends State<PasswordRemember> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _loadController = StreamController<bool>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0064B2),
      appBar: AppBar(centerTitle: true, title: Text("Lembrar Senha")),
      body: _body(),
    );
  }

  _body() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: SvgPicture.asset(
                    'assets/images/logo.svg',
                    color: Colors.white,
                  ),
                ),
                Text(
                  "Esqueceu a senha?",
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
                SizedBox(height: 16),
                Text(
                  "Fique tranquilo, enviaremos um email para você contendo um link para a alteração da sua senha.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                SizedBox(height: 24),
                Text(
                  "ATENÇÃO: Este link possuí duração limitada.",
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: UniTextField(
                    "digite seu email",
                    controller: _emailController,
                    backgroundColor: Colors.white,
                    validator: _validatorEmail,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: StreamBuilder<bool>(
                        stream: _loadController.stream,
                        initialData: false,
                        builder: (context, snapshot) {
                          return UniButton(
                            "enviar",
                            showProgress: snapshot.data,
                            onPressed: _onClickSend,
                            color: const Color(0xffFF7800),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _onClickSend() async {
    if (!_formKey.currentState.validate()) return;

    try {
      ApiResponse response = await LoginApi.rememberPassword(
        _emailController.text,
      );

      if (response.ok) {
        Navigator.of(context).pop(true);
      } else {
        showError(context, response.result);
      }
    } catch (e) {
      print(e);
      showDefaultError(context);
    }
  }

  String _validatorEmail(String value) {
    if (!FieldValidator.isValidEmail(value)) return "Email inválido";
    return null;
  }
}
