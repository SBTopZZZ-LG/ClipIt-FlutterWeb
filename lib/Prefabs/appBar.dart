import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

PreferredSizeWidget getDefaultAppBar() {
  return AppBar(
    title: Row(
      children: [
        Text(
          "ClipIt",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          "Ver. 1.0",
          style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w300,
              color: Colors.grey.shade300),
        ),
        SizedBox(
          width: 20,
        ),
        TextButton(
            onPressed: () {
              _launchUrl();
            },
            child: Text(
              "View Source Code",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ))
      ],
    ),
  );
}

void _launchUrl() async {
  const url = "https://github.com/SBTopZZZ-LG/ClipIt-FlutterWeb";
  if (await canLaunch(url))
    await launch(url);
  else
    // can't launch url, there is some error
    throw "Could not launch $url";
}
