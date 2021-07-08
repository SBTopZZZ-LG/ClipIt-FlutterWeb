import 'dart:math';
import 'package:after_layout/after_layout.dart';
import 'package:app/fluroRouter.dart';
import 'package:fluro/fluro.dart';
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

class _SessionPageState extends State<SessionPage>
    with AfterLayoutMixin<SessionPage> {
  final String sessionName;
  bool _isLoading = true;
  bool _isUpdating = false;

  bool _wasUpdated = false;

  bool _isError = false;

  bool stopRefreshing = false;
  int currentRefreshCode = -1;

  // ignore: non_constant_identifier_names
  final int checkForUpdates_Delay = 3;

  _SessionPageState(this.sessionName);

  TextEditingController contentController = TextEditingController(
      text: currentSession != null ? currentSession!.content : "");

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
          return;
        }

        setState(() {
          _isError = true;
          _isLoading = false;
        });
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

        if (_wasUpdated) {
          _wasUpdated = false;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "Content was updated",
            ),
          ));
        }

        _loadSession();
      } else {
        // Nah, keep going...

        await Future.delayed(Duration(seconds: checkForUpdates_Delay));

        _checkLoadSession(code);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        currentRefreshCode = -1;
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: getDefaultAppBar(context),
        body: SingleChildScrollView(
          child: !_isError
              ? Container(
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
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          OutlinedButton(
                              style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateColor.resolveWith((states) =>
                                          Theme.of(context).primaryColor)),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                          title: Row(
                                            children: [
                                              Icon(Icons.share),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text("Share Link"),
                                            ],
                                          ),
                                          content: Text(
                                              "You can invite other people to your session by sending them your session name, or alternatively sending the link."),
                                          actions: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: OutlinedButton(
                                                style: ButtonStyle(
                                                    foregroundColor: MaterialStateColor
                                                        .resolveWith((states) =>
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
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.copy),
                                                      SizedBox(width: 5),
                                                      Text(
                                                        "Copy session link",
                                                        style: TextStyle(
                                                            fontSize: 18),
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
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: OutlinedButton(
                                                style: ButtonStyle(
                                                    foregroundColor: MaterialStateColor
                                                        .resolveWith((states) =>
                                                            Theme.of(context)
                                                                .primaryColor)),
                                                onPressed: () {
                                                  Navigator.pop(ctx);
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "Okay",
                                                        style: TextStyle(
                                                            fontSize: 18),
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
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 2,
                              color: Theme.of(context).primaryColor,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        padding: const EdgeInsets.all(5),
                        height: 300,
                        child: !_isLoading
                            ? TextField(
                                controller: contentController,
                                maxLength: 5000,
                                maxLines: 1000,
                                style: TextStyle(fontSize: 17),
                              )
                            : Center(
                                child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: CircularProgressIndicator(
                                  color: Theme.of(context).primaryColor,
                                ),
                              )),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                              style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateColor.resolveWith((states) =>
                                          Theme.of(context).primaryColor)),
                              onPressed: _isLoading
                                  ? null
                                  : () {
                                      _loadSession();
                                    },
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Icon(Icons.replay_outlined),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Reload",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              )),
                          SizedBox(
                            width: 10,
                          ),
                          !_isUpdating
                              ? ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateColor.resolveWith(
                                              (states) => Theme.of(context)
                                                  .primaryColor)),
                                  onPressed: _isLoading
                                      ? null
                                      : () {
                                          setState(() {
                                            _isUpdating = true;
                                          });

                                          currentSession!.content =
                                              contentController.text;

                                          updateSession(currentSession!)
                                              .then((value) {
                                            if (value != null) {
                                              // Updated

                                              setState(() {
                                                _isUpdating = false;
                                              });

                                              _wasUpdated = true;
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
                                    child: Row(
                                      children: [
                                        Icon(Icons.save),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "Submit changes",
                                          style: TextStyle(fontSize: 17),
                                        ),
                                      ],
                                    ),
                                  ))
                              : CircularProgressIndicator(
                                  color: Theme.of(context).primaryColor,
                                ),
                        ],
                      )
                    ],
                  ),
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "There was a problem trying to load the session '",
                              style: TextStyle(fontSize: 18),
                            ),
                            Text(
                              "$sessionName",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            Text("'.")
                          ],
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Icon(Icons.circle),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Check your Internet connection",
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Icon(Icons.circle),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Check your Session name/link for any typos",
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Icon(Icons.circle),
                            SizedBox(
                              width: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  "If your session has timed out, you can re-create it from the ",
                                  style: TextStyle(fontSize: 18),
                                ),
                                TextButton(
                                  onPressed: () {
                                    FluroRouterClass.router.navigateTo(
                                        context, "/",
                                        replace: true,
                                        transition: TransitionType.inFromLeft);
                                  },
                                  child: Text(
                                    "Home page",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _loadSession();
  }
}
