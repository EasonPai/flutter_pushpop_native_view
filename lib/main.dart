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
  static const MethodChannel methodChannel =
      const MethodChannel('samples.flutter.io/battery');
  static const EventChannel eventChannel =
      const EventChannel('samples.flutter.io/charging');

  static const MethodChannel pushAndPopViewChannel =
      const MethodChannel('samples.flutter.io/pushAndPopView');


  int pushCount = 0;
  String _nativeInfo = 'Push and Pop for 0 Times';

  String _batteryLevel = 'Battery level: unknown.';
  String _chargingStatus = 'Battery status: unknown.';

  Future<Null> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await methodChannel.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level: $result%.';
    } on PlatformException {
      batteryLevel = "Failed to get battery level.";
    }
    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  Future<Null> _pushAndPopNativeView(String viewId) async {
    String nativeInfo;
    try {
      nativeInfo = await pushAndPopViewChannel.invokeMethod(viewId);

      pushCount++;

    } on PlatformException {
      nativeInfo = "Failed to push native view.";
    }

    print("pushInfo = ${nativeInfo}");

    setState(() {
      _nativeInfo = 'Push and Pop for ${pushCount} Times';
    });
  }

  @override
  void initState() {
    super.initState();
    eventChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);
  }

  void _onEvent(String event) {
    setState(() {
      _chargingStatus =
          "Battery status: ${event == 'charging' ? '' : 'dis'}charging.";
    });
  }

  void _onError(PlatformException error) {
    setState(() {
      _chargingStatus = "Battery status: unknown.";
    });
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
                new Text(_batteryLevel, key: const Key('Battery level label')),
                new Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: new RaisedButton(
                    child: const Text('Refresh'),
                    onPressed: _getBatteryLevel,
                  ),
                ),
              ],
            ),
            new Text(_chargingStatus),
          ],
        ),
        new Column(
          children: <Widget>[
            new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(_nativeInfo),
                new Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: new RaisedButton(
                    child: const Text('Open Native View'),
                    onPressed: (){
                      _pushAndPopNativeView('view_a');
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
