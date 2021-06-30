import 'package:app/Framework/WebSchemas/Session.dart';
import 'package:app/Framework/currentSession.dart';
import 'package:app/Framework/httpReq.dart';
import 'package:app/Pages/session.dart';
import 'package:flutter/material.dart';

import '../Prefabs/appBar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _sessionName = "";

  bool _validate() {
    const String allowedChars =
        "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~:/?#[]@!\$&'()*+,;=";
    if (_sessionName.length >= 6) {
      for (String char in _sessionName.characters.toList()) {
        if (!allowedChars.contains(char)) return false;
      }

      return true;
    }
    return false;
  }

  void _createSession() {
    if (!_validate()) return;

    createSession(_sessionName).then((value) {
      if (value != null) {
        // Creation success

        currentSessionName = _sessionName;

        Navigator.push(
            context, MaterialPageRoute(builder: (ctx) => SessionPage()));
      } else {
        // Failed to create

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to create a session"),
          ),
        );
      }
    });
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
                    errorText: _validate()
                        ? null
                        : "Session name must be >= 6 characters. Allowed characters are a-z, A-Z, 0-9, and URL symbols."),
                style: TextStyle(fontSize: 19),
                keyboardType: TextInputType.name,
                maxLength: 20,
                maxLines: 1,
              ),
              // SizedBox(
              //   height: 10,
              // ),
              // Row(
              //   children: [
              //     Text("Your session link will look like, "),
              //     Text(
              //       "https://site.com/$_sessionName",
              //       style: TextStyle(fontWeight: FontWeight.bold),
              //     ),
              //   ],
              // ),
              SizedBox(
                height: 10,
              ),
              Text(
                  "Please note that sessions timeout depending on the duration of inactivity (Approx. 60 minutes)"),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: _validate() ? _createSession : null,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      "Create Session",
                      style: TextStyle(fontSize: 18),
                    ),
                  )),
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
