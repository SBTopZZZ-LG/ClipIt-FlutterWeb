import 'package:fluro/fluro.dart';
import 'package:fluro/fluro.dart' as fluro;

import 'package:app/Pages/home.dart';
import 'package:app/Pages/session.dart';

class FluroRouterClass {
  static final router = fluro.FluroRouter();

  static final _homeHandler = Handler(
    handlerFunc: (context, parameters) {
      return HomePage();
    },
  );
  static final _sessionHandler = Handler(
    handlerFunc: (context, parameters) {
      return SessionPage(
          parameters["name"] == null ? "<invalid>" : parameters["name"]![0]);
    },
  );

  static void setupRouter() {
    router.define(
      '/',
      handler: _homeHandler,
    );
    router.define(
      '/:name',
      handler: _sessionHandler,
    );
  }
}
