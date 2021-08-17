import 'package:flutter/material.dart';
import 'package:menu/screen/home_page.dart';
import 'package:menu/screen/login_screens.dart';
import 'package:menu/screen/nuevo_item.dart';
import 'package:menu/screen/register_screens.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'login',
      routes: {
        'login': (_) => LoginScreen(),
        'home': (_) => HomePage(),
        'register': (_) => RegisterScreen(),
        'nuevoItem': (_) => NuevoItemPage()
      },
    );
  }
}
