import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:minicurso/entitys/user.dart';
import 'package:minicurso/pages/home/home_page.dart';
import 'package:minicurso/pages/login/password_remember.dart';
import 'package:minicurso/utils/alert.dart';
import 'package:minicurso/utils/api.dart';
import 'package:minicurso/utils/session.dart' as session;
import 'package:minicurso/utils/nav.dart';
import 'package:minicurso/widgets/button.dart';
import 'package:minicurso/widgets/label.dart';
import 'package:minicurso/widgets/text_field.dart';

import 'login_api.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();

  final _streamController = StreamController<bool>.broadcast();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).primaryColor,
      body: _body(),
    );
  }

  _body() {
    return Theme(
      data: ThemeData(
        primaryColor: Theme.of(context).accentColor,
        primaryColorDark: Theme.of(context).accentColor,
      ),
      child: SafeArea(
        child: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 48, bottom: 32),
                  child: SvgPicture.asset(
                    'assets/images/logo.svg',
                    color: Colors.white,
                  ),
                ),
                UniTextField(
                  "código do aluno",
                  keyboardType: TextInputType.number,
                  controller: _loginController,
                  backgroundColor: Colors.white,
                  validator: _isOnlyNumbers,
                ),
                SizedBox(height: 4),
                UniTextField(
                  "senha",
                  controller: _passwordController,
                  password: true,
                  backgroundColor: Colors.white,
                  keyboardType: TextInputType.visiblePassword,
                  validator: _validateIsEmpty,
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    GestureDetector(
                      onTap: _onClickPasswordRemember,
                      child: Text(
                        "Esqueci minha senha >",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: StreamBuilder<bool>(
                        stream: _streamController.stream,
                        initialData: false,
                        builder: (context, snapshot) {
                          return UniButton(
                            "acessar",
                            onPressed: snapshot.data ? null : _onClickOpen,
                            showProgress: snapshot.data,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Flexible(flex: 4, child: _horizontalLine()),
                    SizedBox(width: 16),
                    Flexible(
                      flex: 2,
                      child: Text(
                        "ou",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Flexible(flex: 4, child: _horizontalLine()),
                  ],
                ),
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: StreamBuilder<bool>(
                          stream: _streamController.stream,
                          initialData: false,
                          builder: (context, snapshot) {
                            return GestureDetector(
                              onTap: snapshot.data ? null : _onClickSocialLogin,
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).accentColor,
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(2.0),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(left: 5),
                                      width: 40,
                                      alignment: Alignment.topLeft,
                                      child: Center(
                                        child: Image.asset(
                                          "assets/images/g-logo.png",
                                          height: 40,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: UniLabel(
                                        'Entrar com @univates.com.br',
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _horizontalLine() => Container(height: 1.0, color: Colors.white);

  _onClickPasswordRemember() async {
    bool success = await push(context, PasswordRemember());
    if (success != null && success) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Email será enviado em alguns instantes!'),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () => _scaffoldKey.currentState.hideCurrentSnackBar,
        ),
      ));
    }
  }

  _onClickSocialLogin() async {
    _streamController.add(true);
    await Future.delayed(Duration(seconds: 3));
    _streamController.add(false);
  }

  _onClickOpen() async {
    if (!_formKey.currentState.validate()) return;

    _streamController.add(true);

    String login = _loginController.text;
    String password = _passwordController.text;

    try {
      ApiResponse response = await LoginApi.login(login, password);

      if (response.ok) {
        User user = response.result;
        if (user != null) {
          user.save();
          session.user = user;

          pushReplacement(context, HomePage());
        }
      } else {
        if (response.result is ApiError) showError(context, response.result);
      }
    } catch (e) {
      print(e);
      showDefaultError(context);
    }

    _streamController.add(false);
  }

  String _validateIsEmpty(String value) {
    if (value.isEmpty) return "Preencha este campo";
    return null;
  }

  String _isOnlyNumbers(String value) {
    var isOnlyNumbers = RegExp("^[0-9]*\$").hasMatch(value);
    if (!isOnlyNumbers) return "Digite apenas seu código";
    return null;
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }
}
