import 'dart:io';

class Enviroment {
  static String apiUrl = Platform.isAndroid
      ? 'http://192.168.100.5:3001/api'
      : 'http://localhost:3001/api';
  static String socketUrl = Platform.isAndroid
      ? 'http://192.168.100.5:3001'
      : 'http://localhost:3001';
}
