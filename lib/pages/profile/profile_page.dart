import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:minicurso/entitys/user.dart';
import 'package:minicurso/pages/login/login_page.dart';
import 'package:minicurso/pages/profile/password_change_page.dart';
import 'package:minicurso/pages/profile/profile_api.dart';
import 'package:minicurso/utils/alert.dart';
import 'package:minicurso/utils/api.dart';
import 'package:minicurso/utils/helper.dart';
import 'package:minicurso/utils/nav.dart';
import 'package:minicurso/utils/session.dart' as session;
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:minicurso/widgets/button.dart';
import 'package:minicurso/widgets/dividing_line.dart';
import 'package:minicurso/widgets/label.dart';
import 'package:minicurso/widgets/text_field.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _nameController = TextEditingController(text: session.user.name);
  final _emailController = TextEditingController(text: session.user.email);
  final _cpfController =
      TextEditingController(text: formatCpf(session.user.cpf));
  final _loadController = StreamController<bool>();

  final _cpfMaskFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  File _image;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(centerTitle: true, title: Text('Configurações')),
      body: _body(),
    );
  }

  _body() {
    return SafeArea(
      child: ListView(
        children: <Widget>[
          Card(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: _onClickImage,
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          child: ClipOval(child: getUserImage(image: _image)),
                        ),
                        Expanded(
                            child: UniLabel(
                          'Trocar imagem de perfil',
                          textAlign: TextAlign.end,
                        )),
                        Icon(
                          Icons.chevron_right,
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  UniTextField('Nome', controller: _nameController),
                  SizedBox(height: 2),
                  UniTextField('Email', controller: _emailController),
                  SizedBox(height: 2),
                  UniTextField(
                    'CPF',
                    controller: _cpfController,
                    inputFormaters: [_cpfMaskFormatter],
                    readOnly: true,
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: StreamBuilder<bool>(
                          stream: _loadController.stream,
                          initialData: false,
                          builder: (context, snapshot) {
                            return UniButton(
                              'alterar',
                              showProgress: snapshot.data,
                              onPressed: _onClickChange,
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: InkWell(
              onTap: _onClickPasswordChange,
              child: Container(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: <Widget>[
                    Expanded(child: UniLabel('alterar senha')),
                    Icon(Icons.chevron_right, color: Colors.blueGrey),
                  ],
                ),
              ),
            ),
          ),
          Card(
            child: InkWell(
              onTap: _onClickLogout,
              child: Container(
                padding: EdgeInsets.all(16),
                child: UniLabel('sair'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _onClickImage() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18.0),
              topRight: Radius.circular(18.0),
            ),
          ),
          padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 50,
                  margin: EdgeInsets.only(bottom: 8),
                  child: DividingLine(),
                ),
                Divider(),
                ListTile(title: UniLabel('Substituir foto de perfil')),
//                Divider(),
                ListTile(
                  leading: Icon(
                    Icons.camera_alt,
                    color: Theme.of(context).primaryColor,
                  ),
                  trailing: Icon(Icons.chevron_right),
                  onTap: _onClickCamera,
                  title: Text('Câmera'),
                ),
                ListTile(
                  leading: Icon(
                    Icons.image,
                    color: Theme.of(context).primaryColor,
                  ),
                  trailing: Icon(Icons.chevron_right),
                  onTap: _onClickGallery,
                  title: Text('Galeria'),
                ),
                Divider(),
              ],
            ),
          ),
        );
      },
    );
  }

  _onClickCamera() async {
    Navigator.pop(context);
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) setState(() => _image = File(pickedFile.path));
  }

  _onClickGallery() async {
    Navigator.pop(context);
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) setState(() => _image = File(pickedFile.path));
  }

  _onClickChange() async {
    _loadController.add(true);

    var newEmail = _emailController.text;
    var newName = _nameController.text;

    if (newEmail.isEmpty) {
      showSnackBar(_scaffoldKey, "Email inválido!");
      return;
    } else if (newName.isEmpty) {
      showSnackBar(_scaffoldKey, "Nome inválido");
      return;
    }

    if (newEmail == session.user.email) newEmail = null;
    if (newName == session.user.name) newName = null;

    try {
      ApiResponse response = await ProfileApi.profile(
        name: newName,
        newEmail: newEmail,
        photo: _image,
      );

      if (response.ok) {
        User user = response.result;
//        print('cliente: ${cliente.toMap()}');
        if (user != null) {
          user.save();
          setState(() => session.user = user);
//          print('Session: ${session.cliente.nome}');
        }
        showSnackBar(_scaffoldKey, "Perfil atualizado com sucesso!");
      } else {
        showError(context, response.result);
      }
    } catch (e) {
      print(e);
      showDefaultError(context);
    }

    _loadController.add(false);
  }

  _onClickPasswordChange() async {
    bool success = await push(context, PasswordChange());
    if (success != null)
      showSnackBar(_scaffoldKey, "Senha alterada com sucesso!");
  }

  _onClickLogout() {
    showBottomQuestion(
      context,
      'Sair',
      'Você tem certeza que deseja sair?',
      UniButton(
        'Confirmar',
        onPressed: () {
          ProfileApi.logout();
          User().save();
          pushAndRemoveUntil(context, LoginPage());
        },
      ),
    );
  }
}
