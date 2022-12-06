import 'package:chat_app/src/pages/login_page.dart';
import 'package:chat_app/src/pages/users_pages.dart';
import 'package:chat_app/src/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class loadingPage extends StatelessWidget {
  const loadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Center(
            child: Text(
              'Espere...',
            ),
          );
        },
      ),
    );
  }

  Future checkLoginState(BuildContext context) async {
    final authService = Provider.of<AuthService>(context);
    final autenticado = await authService.isLoggedIn();

    if (autenticado) {
      //socket
      // Navigator.pushReplacementNamed(context, 'routeUser');

      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
              pageBuilder: (_, __, ___) => UserPage(),
              transitionDuration: Duration(milliseconds: 0)));
    } else {
      // Navigator.pushReplacementNamed(context, 'routelogin');
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
              pageBuilder: (_, __, ___) => LoginPage(),
              transitionDuration: Duration(milliseconds: 0)));
    }
  }
}
