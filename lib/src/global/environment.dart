import 'dart:io';

class Environment {
// asi es para url para socket  y services

  static String url =
      Platform.isAndroid ? 'http://10.0.2.2:3000' : 'http://localhost:3000';

  // static String url = 'http://10.0.2.2:3000';
}
