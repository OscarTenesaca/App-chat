import 'package:flutter/material.dart';

import '../pages/chat_page.dart';
import '../pages/loading_page.dart';
import '../pages/login_page.dart';
import '../pages/register_page.dart';
import '../pages/users_pages.dart';

final Map<String, WidgetBuilder> appRoutes = {
  'routeUser': (_) => UserPage(),
  'routeChat': (_) => ChatPage(),
  'routelogin': (_) => LoginPage(),
  'routeRegister': (_) => RegisterPage(),
  'routeLoading': (_) => loadingPage(),
};
