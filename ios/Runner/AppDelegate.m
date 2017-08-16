// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "AppDelegate.h"
#import <Flutter/Flutter.h>
#import "GeneratedPluginRegistrant.h"
#import "Runner-Swift.h"

//@interface AppDelegate()
//@property (nonatomic, strong) UINavigationController *navigationController;
//@end

@implementation AppDelegate {
  FlutterEventSink _eventSink;
}

- (BOOL)application:(UIApplication*)application
    didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  FlutterViewController* controller =
      (FlutterViewController*)self.window.rootViewController;

    /// embed FlutterViewController in container UINavigationController programmatically
    
//    self.navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.window.rootViewController = self.navigationController;
//    [self.window makeKeyAndVisible];
    
    /// push and pop view controll
    
    FlutterMethodChannel* pushAndPopViewChannel = [FlutterMethodChannel
                                            methodChannelWithName:@"samples.flutter.io/pushAndPopView"
                                            binaryMessenger:controller];
    [pushAndPopViewChannel setMethodCallHandler:^(FlutterMethodCall* call,
                                           FlutterResult result) {
        
        NativeViewController *nativeView = [[NativeViewController alloc] init];
        
        if ([@"sayHello" isEqualToString:call.method]) {
            
            NSString *helloResult = [nativeView sayHello :@"Eason"];
            result(helloResult);
        }
        else if ([@"view_a" isEqualToString:call.method]) {
            
            result(@("view_a"));
            
            NSString * storyboardName = @"Main";
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
            UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"NativeViewController"];
            [controller presentViewController:vc animated:YES completion:nil];

            
        } else {
            result(FlutterMethodNotImplemented);
        }
    }];
    
  FlutterMethodChannel* batteryChannel = [FlutterMethodChannel
      methodChannelWithName:@"samples.flutter.io/battery"
            binaryMessenger:controller];
  [batteryChannel setMethodCallHandler:^(FlutterMethodCall* call,
                                         FlutterResult result) {
    if ([@"getBatteryLevel" isEqualToString:call.method]) {
      int batteryLevel = [self getBatteryLevel];
      if (batteryLevel == -1) {
        result([FlutterError errorWithCode:@"UNAVAILABLE"
                                   message:@"Battery info unavailable"
                                   details:nil]);
      } else {
        result(@(batteryLevel));
      }
    } else {
      result(FlutterMethodNotImplemented);
    }
  }];
    
  FlutterEventChannel* chargingChannel = [FlutterEventChannel
      eventChannelWithName:@"samples.flutter.io/charging"
           binaryMessenger:controller];
  [chargingChannel setStreamHandler:self];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (int)getBatteryLevel {
  UIDevice* device = UIDevice.currentDevice;
  device.batteryMonitoringEnabled = YES;
  if (device.batteryState == UIDeviceBatteryStateUnknown) {
    return -1;
  } else {
    return ((int)(device.batteryLevel * 100));
  }
}

- (FlutterError*)onListenWithArguments:(id)arguments
                             eventSink:(FlutterEventSink)eventSink {
  _eventSink = eventSink;
  [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
  [self sendBatteryStateEvent];
  [[NSNotificationCenter defaultCenter]
   addObserver:self
      selector:@selector(onBatteryStateDidChange:)
          name:UIDeviceBatteryStateDidChangeNotification
        object:nil];
  return nil;
}

- (void)onBatteryStateDidChange:(NSNotification*)notification {
  [self sendBatteryStateEvent];
}

- (void)sendBatteryStateEvent {
  if (!_eventSink) return;
  UIDeviceBatteryState state = [[UIDevice currentDevice] batteryState];
  switch (state) {
    case UIDeviceBatteryStateFull:
    case UIDeviceBatteryStateCharging:
      _eventSink(@"charging");
      break;
    case UIDeviceBatteryStateUnplugged:
      _eventSink(@"discharging");
      break;
    default:
      _eventSink([FlutterError errorWithCode:@"UNAVAILABLE"
                                     message:@"Charging status unavailable"
                                     details:nil]);
      break;
  }
}

- (FlutterError*)onCancelWithArguments:(id)arguments {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  _eventSink = nil;
  return nil;
}

@end
