import 'package:flutter/material.dart';
import 'package:minicurso/utils/session.dart' as session;
import 'package:minicurso/pages/card/list_cards.dart';
import 'package:minicurso/pages/profile/profile_page.dart';
import 'package:minicurso/utils/helper.dart';
import 'package:minicurso/utils/nav.dart';
import 'package:minicurso/widgets/list_tile_menu.dart';

class DrawerList extends StatelessWidget {
  Function updateState;

  DrawerList(this.updateState);

  UserAccountsDrawerHeader _header() {
    print('Session.user: ${session.user.email}');
    return UserAccountsDrawerHeader(
      accountName: Text(session.user.name),
      accountEmail: Text(session.user.email),
      currentAccountPicture: ClipOval(child: getUserImage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final drawerItems = [
      ListTileMenu(
        Icons.payment,
        "Pagamento",
        onTap: () => _onClickInputCard(context),
      ),
      ListTileMenu(
        Icons.settings,
        "Configurações",
        onTap: () => _onClickConfig(context),
      ),
    ];

    return Drawer(
      child: Container(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () => _onClickProfile(context),
                child: _header(),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 24),
                  children: drawerItems,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onClickInputCard(BuildContext context) {
    Navigator.pop(context);
    push(context, ListCards());
  }

  _onClickProfile(BuildContext context) {
    Navigator.pop(context);
    push(context, ProfilePage());
  }

  _onClickConfig(BuildContext context) {
    Navigator.pop(context);
    push(context, ProfilePage());
  }
}
