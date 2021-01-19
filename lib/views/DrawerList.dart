import 'package:desappega/utils/nav.dart';
import 'package:desappega/utils/sign_in.dart';
import 'package:desappega/views/MySales.dart';
import 'package:desappega/widgets/list_tile_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


import 'Login.dart';

class DrawerList extends StatelessWidget {
  DrawerList();

  _header() {
    return UserAccountsDrawerHeader(
      accountName: Text("CAMILA SBRUSSI"),
      accountEmail: Text("camila.sbrussi@universo.univates.br"),
      currentAccountPicture: ClipOval(
        child: Image.asset(
          'images/user_photo.png',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final drawerItems = [
      ListTileMenu(
        Icons.favorite_border,
        "Meus Anúncios",
        onTap: () => _onClickMySales(context),
      ),
      ListTileMenu(
        Icons.settings,
        "Logout",
        onTap: () => _onClickLogout(context),
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
                onTap: () => {},
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

  _onClickMySales(BuildContext context) {
    Navigator.pop(context);
    push(context, MySales());
  }

  _onClickLogout(BuildContext context) {
    Navigator.pop(context);
    _logoutUser();
    signOutGoogle();
    push(context, Login());
  }

  _logoutUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
  }
}
