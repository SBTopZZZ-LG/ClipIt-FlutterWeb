import 'package:flutter/material.dart';

import './fluroRouter.dart';

void main() {
  FluroRouterClass.setupRouter();

  runApp(MaterialApp(
    onGenerateRoute: FluroRouterClass.router.generator,
  ));
}
