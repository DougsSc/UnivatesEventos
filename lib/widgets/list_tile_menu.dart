import 'package:flutter/material.dart';

class ListTileMenu extends StatelessWidget {
  IconData icon;
  String title;
  Function onTap;

  ListTileMenu(this.icon, this.title, {this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).primaryColor,
        size: 30,
      ),
      title: Text(
        title,
        style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16),
      ),
      onTap: onTap,
    );
  }
}
