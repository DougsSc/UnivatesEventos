import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minicurso/widgets/dividing_line.dart';
import 'package:minicurso/widgets/label.dart';

import 'api.dart';

showAlert(BuildContext context, String title, String content) {
  showDialog(
    context: context,
    builder: (BuildContext context) => getDialog(
      title,
      content,
      [getAction('OK', () => Navigator.of(context).pop(), isDefault: true)],
    ),
  );
}

showDefaultError(BuildContext context) {
  showError(
    context,
    ApiError(
      codigo: '',
      mensagem: 'Verifique sua conexão com a internet e tente novamente!',
    ),
  );
}


showError(BuildContext context, ApiError error) {
  showDialog(
    context: context,
    builder: (BuildContext context) => getDialog(
      error.codigo != null ? 'Erro ${error.codigo}' : 'Erro',
      error.mensagem != null
          ? error.mensagem
          : 'Erro desconhecido, contate-nos pelo menu Ajuda',
      [getAction('OK', () => Navigator.of(context).pop(), isDefault: true)],
    ),
  );
}

dynamic getDialog(String title, String content, List<Widget> actions) {
  if (Platform.isIOS) {
    return CupertinoAlertDialog(
        title: Text(title), content: Text(content), actions: actions);
  } else {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
      actions: actions,
      title: Text(title),
      content: Text(content),
    );
  }
}

dynamic getAction(String title, Function onPressed,
    {isDefault = false, isDestructive = false}) {
  if (Platform.isIOS) {
    return CupertinoDialogAction(
        isDefaultAction: isDefault,
        isDestructiveAction: isDestructive,
        child: Text(title),
        onPressed: onPressed);
  } else {
    return FlatButton(
      child: Text(title),
      onPressed: onPressed,
    );
  }
}

showSnackBar(GlobalKey<ScaffoldState> scaffold, String content) {
  scaffold.currentState.showSnackBar(SnackBar(
    content: Text(content),
    backgroundColor: Theme.of(scaffold.currentState.context).primaryColor,
//    duration: ,
    action: SnackBarAction(
      label: 'OK',
      textColor: Colors.white,
      onPressed: () => scaffold.currentState.hideCurrentSnackBar,
    ),
  ));
}

showLoadingSnackBar(GlobalKey<ScaffoldState> scaffold, String content) {
  scaffold.currentState.showSnackBar(SnackBar(
    content: Row(
      children: <Widget>[
        Expanded(child: Text(content)),
        Container(
          height: 20,
          width: 20,
          child: Center(child: CircularProgressIndicator()),
        ),
      ],
    ),
    backgroundColor: Theme.of(scaffold.currentState.context).primaryColor,
  ));
}

showBottomQuestion(context, title, content, button) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.fromLTRB(16, 24,16, 8),
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: const Radius.circular(16.0),
            topRight: const Radius.circular(16.0),
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(width: 50, child: DividingLine()),
              SizedBox(height: 24),
              UniLabel(title),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: UniLabel(
                  content,
//                  fontSize: 16,
                  isBold: false,
                  textAlign: TextAlign.justify,
                ),
              ),
              SizedBox(height: 16),
              Row(children: <Widget>[Expanded(child: button)]),
            ],
          ),
        ),
      );
    },
  );
}
