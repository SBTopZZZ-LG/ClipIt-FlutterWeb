import 'package:flutter/material.dart';

import './fluroRouter.dart';

const String VERSION = "2.3.2";

void main() {
  FluroRouterClass.setupRouter();

  runApp(MaterialApp(
      color: Color.fromARGB(255, 186, 49, 39),
      title: "ClipIt",
      onGenerateRoute: FluroRouterClass.router.generator,
      theme: ThemeData(
          fontFamily: 'PTSans',
          backgroundColor: Color.fromARGB(255, 235, 64, 52),
          primaryColor: Color.fromARGB(255, 186, 49, 39))));
}
