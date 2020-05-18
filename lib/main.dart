import 'package:flutter/material.dart';
import 'package:flutter_movie/pages/card.dart';
import 'package:flutter_movie/pages/login_page.dart';
import 'package:flutter_movie/pages/main_page.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    theme: ThemeData(primarySwatch: Colors.amber),
    routes: {
      '/': (BuildContext context) => LoginPage(),
      '/main-page': (BuildContext context) => MainPage(),
      '/card-page': (BuildContext context) => CardPage(),
    },
  ));
}
