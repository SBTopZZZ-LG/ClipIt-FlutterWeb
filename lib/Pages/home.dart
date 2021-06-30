import 'package:app/fluroRouter.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import '../Prefabs/appBar.dart';
import '../Framework/currentSession.dart';
import '../Framework/httpReq.dart';
import '../Pages/session.dart';

class HomePage extends StatefulWidget {
  static const String route = "/";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _sessionName = "";

  void _createSession() {
    if (!SessionPage.validate(_sessionName)) return;

    // Session will be created on the session page
    FluroRouterClass.router.navigateTo(context, "/$_sessionName",
        transition: TransitionType.inFromRight);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getDefaultAppBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                onChanged: (sessionName) =>
                    setState(() => _sessionName = sessionName),
                decoration: InputDecoration(
                    hintText: "Session ID/Name",
                    errorText: SessionPage.validate(_sessionName)
                        ? null
                        : "Session name must be >= 6 and <= 15 characters. Allowed characters are a-z, A-Z, 0-9, and URL symbols."),
                style: TextStyle(fontSize: 19),
                keyboardType: TextInputType.name,
                maxLength: 15,
                maxLines: 1,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                  "Please note that sessions timeout depending on the duration of inactivity (Approx. 60 minutes)"),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: SessionPage.validate(_sessionName) ? _createSession : null,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "Create Session",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                  "Session will not be created if a session with the specified name/id already exists"),
            ],
          ),
        ),
      ),
    );
  }
}
