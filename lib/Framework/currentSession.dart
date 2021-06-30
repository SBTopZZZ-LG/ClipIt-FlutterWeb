import 'package:app/Framework/WebSchemas/Session.dart';

Session? currentSession = null;
String? currentSessionName = null;

void resetSession() {
  currentSession = null;
  currentSessionName = null;
}
