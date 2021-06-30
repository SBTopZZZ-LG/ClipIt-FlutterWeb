import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Framework/currentSession.dart';
import '../Framework/httpReq.dart';
import '../Prefabs/appBar.dart';

class SessionPage extends StatefulWidget {
  final String sessionName;

  SessionPage(this.sessionName);

  static bool validate(String sessionName) {
    const String allowedChars =
        "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_-";
    if (sessionName.length >= 6) {
      for (String char in sessionName.characters.toList()) {
        if (!allowedChars.contains(char)) return false;
      }

      return true;
    }
    return false;
  }

  @override
  _SessionPageState createState() => _SessionPageState(sessionName);
}

class _SessionPageState extends State<SessionPage> {
  final String sessionName;
  bool _isLoading = true;

  bool stopRefreshing = false;
  int currentRefreshCode = -1;

  _SessionPageState(this.sessionName) {
    _createLoadSession();
  }

  TextEditingController contentController = TextEditingController(
      text: currentSession != null ? currentSession!.content : "");

  void _createLoadSession() async {
    createSession(sessionName).then((value) {
      if (value) {
        _loadSession();
      } else {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (ctx) => AlertDialog(
                  title: Row(
                    children: [
                      Icon(Icons.error),
                      SizedBox(
                        width: 5,
                      ),
                      Text("Error"),
                    ],
                  ),
                  content: Text(
                      "There was a problem trying to create the session. Please try again later, or check your session."),
                  actions: [
                    OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Dismiss",
                            style: TextStyle(fontSize: 18),
                          ),
                        ))
                  ],
                ));
      }
    });
  }

  void _loadSession() {
    if (sessionName == "<invalid>") {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
                title: Row(
                  children: [
                    Icon(Icons.error),
                    SizedBox(
                      width: 5,
                    ),
                    Text("Error"),
                  ],
                ),
                content: Text(
                    "There was a problem trying to access the session. Please try again later, or check your session."),
                actions: [
                  OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Dismiss",
                          style: TextStyle(fontSize: 18),
                        ),
                      ))
                ],
              ));
      return;
    }

    setState(() {
      _isLoading = true;
      getSession(sessionName).then((value) {
        if (value != null) {
          currentSession = value;

          setState(() {
            _isLoading = false;

            contentController.text = currentSession!.content;
          });

          currentRefreshCode = Random().nextInt(1000);
          _checkLoadSession(currentRefreshCode);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "Failed to load content",
            ),
          ));
        }
      });
    });
  }

  void _checkLoadSession(int code) {
    if (stopRefreshing || currentRefreshCode != code) {
      return;
    }

    checkSession(currentSession!).then((value) async {
      if (value) {
        // Gotta update

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Content was updated",
          ),
        ));

        _loadSession();
      } else {
        // Nah, keep going...

        await Future.delayed(Duration(seconds: 5));

        _checkLoadSession(code);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getDefaultAppBar(context),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "Session",
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    sessionName,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  OutlinedButton(
                      style: ButtonStyle(
                          foregroundColor: MaterialStateColor.resolveWith(
                              (states) => Theme.of(context).primaryColor)),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                                  title: Text("Share Link"),
                                  content: Text(
                                      "You can invite other people to your session by sending them your session name, or alternatively sending the link."),
                                  actions: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: OutlinedButton(
                                        style: ButtonStyle(
                                            foregroundColor:
                                                MaterialStateColor.resolveWith(
                                                    (states) =>
                                                        Theme.of(context)
                                                            .primaryColor)),
                                        onPressed: () {
                                          Clipboard.setData(ClipboardData(
                                              text:
                                                  "https://clip-it-web.herokuapp.com/#/$sessionName"));

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                              "Copied to Clipboard",
                                            ),
                                          ));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Row(
                                            children: [
                                              Icon(Icons.copy),
                                              SizedBox(width: 5),
                                              Text(
                                                "Copy session name",
                                                style: TextStyle(fontSize: 18),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: OutlinedButton(
                                        style: ButtonStyle(
                                            foregroundColor:
                                                MaterialStateColor.resolveWith(
                                                    (states) =>
                                                        Theme.of(context)
                                                            .primaryColor)),
                                        onPressed: () {
                                          Navigator.pop(ctx);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Okay",
                                                style: TextStyle(fontSize: 18),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          "Share link",
                          style: TextStyle(fontSize: 17),
                        ),
                      ))
                ],
              ),
              SizedBox(
                height: 35,
              ),
              !_isLoading
                  ? Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 2,
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      padding: const EdgeInsets.all(5),
                      height: 300,
                      child: TextField(
                        controller: contentController,
                        maxLength: 5000,
                        maxLines: 1000,
                        style: TextStyle(fontSize: 17),
                      ),
                    )
                  : Center(
                      child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    )),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                      style: ButtonStyle(
                          foregroundColor: MaterialStateColor.resolveWith(
                              (states) => Theme.of(context).primaryColor)),
                      onPressed: _isLoading
                          ? null
                          : () {
                              _loadSession();
                            },
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          "Reload",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      )),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateColor.resolveWith(
                              (states) => Theme.of(context).primaryColor)),
                      onPressed: _isLoading
                          ? null
                          : () {
                              currentSession!.content = contentController.text;

                              updateSession(currentSession!).then((value) {
                                if (value != null) {
                                  // Updated
                                  _loadSession();

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                      "You updated the content",
                                    ),
                                  ));
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                      "Failed to update content",
                                    ),
                                  ));
                                }
                              });
                            },
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          "Submit changes",
                          style: TextStyle(fontSize: 17),
                        ),
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
