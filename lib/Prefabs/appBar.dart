import 'package:flutter/material.dart';

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
      ],
    ),
  );
}
