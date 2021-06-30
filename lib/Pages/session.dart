import 'dart:math';

import 'package:app/Framework/currentSession.dart';
import 'package:app/Framework/httpReq.dart';
import 'package:flutter/material.dart';

import 'package:app/Prefabs/appBar.dart';
import 'package:flutter/services.dart';

class SessionPage extends StatefulWidget {
  @override
  _SessionPageState createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage> {
  bool stopRefreshing = false;
  int currentRefreshCode = -1;

  TextEditingController contentController = TextEditingController(
      text: currentSession != null ? currentSession!.content : "");

  void _loadSession() {
    getSession(currentSessionName!).then((value) {
      if (value != null) {
        currentSession = value;
        contentController.text = currentSession!.content;

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

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (ctx) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: new Text('No'),
                ),
              ),
              TextButton(
                onPressed: () {
                  stopRefreshing = true;

                  // Reset static values
                  resetSession();

                  Navigator.of(ctx).pop(true);
                },
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: new Text('Yes'),
                ),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    _loadSession();

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: getDefaultAppBar(),
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
                      currentSessionName!,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    OutlinedButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                    title: Text("Share Link"),
                                    content: Text(
                                        "You can invite other people to your session by sending them your session name."),
                                    actions: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: OutlinedButton(
                                          onPressed: () {
                                            Clipboard.setData(ClipboardData(
                                                text: currentSessionName));

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
                                                  style:
                                                      TextStyle(fontSize: 18),
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
                                          onPressed: () {
                                            Navigator.pop(ctx);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "Okay",
                                                  textAlign: TextAlign.center,
                                                  style:
                                                      TextStyle(fontSize: 18),
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
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  padding: const EdgeInsets.all(5),
                  height: 300,
                  child: TextField(
                    controller: contentController,
                    maxLength: 5000,
                    maxLines: 1000,
                    style: TextStyle(fontSize: 17),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // OutlinedButton(
                    //     onPressed: () {
                    //       contentController.text = "";
                    //     },
                    //     child: Padding(
                    //       padding: const EdgeInsets.all(10),
                    //       child: Text(
                    //         "Clear",
                    //         style: TextStyle(
                    //             fontSize: 17, color: Colors.deepOrange),
                    //       ),
                    //     )),
                    // SizedBox(
                    //   width: 10,
                    // ),
                    OutlinedButton(
                        onPressed: () {
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
                        onPressed: () {
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
      ),
    );
  }
}
