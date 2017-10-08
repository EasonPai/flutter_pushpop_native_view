// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PlatformChannel extends StatefulWidget {
  @override
  _PlatformChannelState createState() => new _PlatformChannelState();
}

class _PlatformChannelState extends State<PlatformChannel> {
  static const MethodChannel nativeCallChannel =
      const MethodChannel('samples.flutter.io/nativecall');

  int pushCount = 0;
  String _sayHelloInfo = '';
  String _pushAndPopNativeViewInfo = 'Push and Pop for 0 Times';


  Future<Null> _pushAndPopNativeView(String viewId) async {
    String info;
    try {
      info = await nativeCallChannel.invokeMethod("push_pop_view", viewId);

      pushCount++;

    } on PlatformException {
      info = "Failed to push native view.";
    }

    print("pushInfo = ${info}");

    setState(() {
      _pushAndPopNativeViewInfo = 'Push and Pop for ${pushCount} Times';
    });
  }

  Future<Null> _sayHello() async {
    String info;
    try {
      info = await nativeCallChannel.invokeMethod("sayHello");
    } on PlatformException {
      info = "Failed to call sayHello";
    }

    setState(() {
      _sayHelloInfo = '${info}';
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
        new Column(
          children: <Widget>[
            new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(_sayHelloInfo),
                new Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: new RaisedButton(
                    child: const Text('Say Hello'),
                    onPressed: (){
                      _sayHello();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        new Column(
          children: <Widget>[
            new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(_pushAndPopNativeViewInfo),
                new Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: new RaisedButton(
                    child: const Text('Push Native View'),
                    onPressed: (){
                      _pushAndPopNativeView('view');
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ],)
    );
  }
}

void main() {
  runApp(new PlatformChannel());
}
