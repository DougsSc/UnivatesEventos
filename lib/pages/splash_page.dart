import 'package:flutter_svg/svg.dart';
import 'package:minicurso/entitys/user.dart';
import 'package:minicurso/pages/login/login_page.dart';
import 'package:minicurso/pages/home/home_page.dart';
import 'package:minicurso/utils/db_helper.dart';
import 'package:minicurso/utils/nav.dart';
import 'package:flutter/material.dart';
import 'package:minicurso/utils/session.dart' as session;

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Future delay = Future.delayed(Duration(seconds: 3));
    Future db = DatabaseHelper.getInstance().db;
    Future<User> fCliente = User.get();

    Future.wait([delay, db, fCliente]).then((List values) {
      User cliente = values[2];

      if (cliente != null && cliente.token != null) {
        session.user = cliente;
        pushReplacement(context, HomePage());
      } else {
        pushReplacement(context, LoginPage());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Column(
        children: [
          Expanded(child: Container()),
          SvgPicture.asset(
            'assets/images/logo.svg',
            color: Colors.white,
          ),
          SizedBox(height: 16),
          CircularProgressIndicator(),
          Expanded(child: Container()),
        ],
      ),
    );
  }
}
