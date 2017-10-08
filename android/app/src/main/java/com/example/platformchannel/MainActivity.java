// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package com.example.platformchannel;

import android.content.Intent;
import android.os.Bundle;

import com.yourcompany.NativeViewActivity;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  private static final String NativeCall_Channel = "samples.flutter.io/nativecall";

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);


    new MethodChannel(getFlutterView(), NativeCall_Channel).setMethodCallHandler(
            new MethodCallHandler() {
              @Override
              public void onMethodCall(MethodCall call, Result result) {

                if (call.method.equals("sayHello")) {
                  result.success("Hello Eason!");
                }

                else if (call.method.equals("push_pop_view")) {

                  Intent intent = new Intent(getApplicationContext(), NativeViewActivity.class);
                  startActivity(intent);

//                  result.success("true");
                }


                else {
                  result.notImplemented();
                }
              }
            }
    );

  }

}
