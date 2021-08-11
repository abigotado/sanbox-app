import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CallPage extends StatefulWidget {
  CallPage({Key? key}) : super(key: key);

  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: VideoCall(),
    );
  }
}
