import 'dart:async';

import 'package:flutter/material.dart';
import 'package:minicurso/pages/profile/profile_api.dart';
import 'package:minicurso/utils/alert.dart';
import 'package:minicurso/utils/api.dart';
import 'package:minicurso/widgets/button.dart';
import 'package:minicurso/widgets/text_field.dart';

class PasswordChange extends StatefulWidget {
  @override
  _PasswordChangeState createState() => _PasswordChangeState();
}

class _PasswordChangeState extends State<PasswordChange> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _passwordC = TextEditingController();
  final _newPasswordC = TextEditingController();
  final _confirmNewPasswordC = TextEditingController();

  final _passwordF = FocusNode();
  final _newPasswordF = FocusNode();
  final _confirmNewPasswordF = FocusNode();

  final _loaderC = StreamController<bool>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(centerTitle: true, title: Text('Alterar Senha')),
      body: _body(),
    );
  }

  _body() {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: <Widget>[
            UniTextField(
              'Senha atual',
              password: true,
              controller: _passwordC,
              focusNode: _passwordF,
              nextFocus: _newPasswordF,
            ),
            SizedBox(height: 4),
            UniTextField(
              'Nova senha',
              password: true,
              controller: _newPasswordC,
              focusNode: _newPasswordF,
              nextFocus: _confirmNewPasswordF,
            ),
            SizedBox(height: 4),
            UniTextField(
              'Confirmar senha',
              password: true,
              controller: _confirmNewPasswordC,
              focusNode: _confirmNewPasswordF,
            ),
            SizedBox(height: 16),
            StreamBuilder<bool>(
              stream: _loaderC.stream,
              initialData: false,
              builder: (context, snapshot) {
                return UniButton(
                  'Alterar',
                  showProgress: snapshot.data,
                  onPressed: _onClickChange,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  _onClickChange() async {
    _loaderC.add(true);

    final password = _passwordC.text;
    final newPassword = _newPasswordC.text;
    final confirmNewPassword = _confirmNewPasswordC.text;

    if (password.isEmpty) {
      showSnackBar(_scaffoldKey, "Senha inválida!");
      return;
    } else if (newPassword.isEmpty) {
      showSnackBar(_scaffoldKey, "Nova senha inválida");
      return;
    } else if (newPassword != confirmNewPassword) {
      showSnackBar(_scaffoldKey,
          "Nosa Senha e Confirmar senha devem ser iguais");
      return;
    }

    try {
      ApiResponse response = await ProfileApi.changePassword(
        password,
        newPassword,
      );

      if (response.ok) {
        Navigator.pop(context, true);
      } else {
        showError(context, response.result);
      }
    } catch (e) {
      print(e);
      showError(
        context,
        ApiError(
          codigo: '',
          mensagem: 'Verifique sua conexão com a internet e tente novamente!',
        ),
      );
    }

    _loaderC.add(false);
  }
}
