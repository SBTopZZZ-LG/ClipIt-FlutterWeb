import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

PreferredSizeWidget getDefaultAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: Theme.of(context).backgroundColor,
    centerTitle: true,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "ClipIt",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          "2.2",
          style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w300,
              color: Colors.white.withOpacity(0.5)),
        ),
        SizedBox(
          width: 20,
        ),
        OutlinedButton(
            onPressed: () {
              _launchUrl();
            },
            child: Text(
              "View Source Code",
              style: TextStyle(
                  fontSize: 18,
                  //fontWeight: FontWeight.bold,
                  color: Colors.white),
            ))
      ],
    ),
    leading: Container(),
  );
}

void _launchUrl() async {
  const url = "https://github.com/SBTopZZZ-LG/ClipIt-FlutterWeb";
  if (await canLaunch(url)) await launch(url);
}
