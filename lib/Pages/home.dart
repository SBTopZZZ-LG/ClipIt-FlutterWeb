import 'package:app/fluroRouter.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import '../Prefabs/appBar.dart';
import '../Pages/session.dart';

class HomePage extends StatefulWidget {
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
      appBar: getDefaultAppBar(context),
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
                        : "Session name must be >= 6 and <= 15 characters. Allowed characters are a-z, A-Z, 0-9, dashes(-) and underscores '_'."),
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
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Theme.of(context).primaryColor)),
                onPressed:
                    SessionPage.validate(_sessionName) ? _createSession : null,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "Create/Join Session",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
