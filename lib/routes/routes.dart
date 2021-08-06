import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/pages/loading_pages.dart';
import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/pages/register_page.dart';
import 'package:chat_app/pages/user_page.dart';
import 'package:flutter/cupertino.dart';

// final Map<String, dynamic> appRoutes = {
final Map<String, Widget Function(BuildContext)> appRoutes = {
  'usuarios': (_) => UsersPage(),
  'chat': (_) => ChatsPage(),
  'login': (_) => LoginPage(),
  'register': (_) => RegisterPage(),
  'loading': (_) => LoadingPage(),
};
