import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';

import './Pages/home.dart';
import './Pages/session.dart';
import './fluroRouter.dart';

//

void main() {
  FluroRouterClass.setupRouter();

  runApp(MaterialApp(
    initialRoute: HomePage.route,
    onGenerateRoute: FluroRouterClass.router.generator,
  ));
}
