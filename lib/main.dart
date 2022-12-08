import 'package:chat_app/src/services/auth_services.dart';
import 'package:chat_app/src/services/chat_services.dart';
import 'package:chat_app/src/services/socket_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/routes/routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => SocketService()),
        ChangeNotifierProvider(create: (_) => ChatServices()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        routes: appRoutes,
        initialRoute: 'routeLoading',
      ),
    );
  }
}
