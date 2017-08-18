// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "AppDelegate.h"
#import <Flutter/Flutter.h>
#import "GeneratedPluginRegistrant.h"
#import "Runner-Swift.h"

/// NavigationController solution -------------
@interface AppDelegate()
@property (nonatomic, strong) UINavigationController *navigationController;
@end

@implementation AppDelegate {
  FlutterEventSink _eventSink;
}

- (BOOL)application:(UIApplication*)application
    didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
    
    
  [GeneratedPluginRegistrant registerWithRegistry:self];
  
    
    /// --------------------------------------------
    /// Navigation
    /// --------------------------------------------
    
    // embed FlutterViewController in container UINavigationController programmatically
  
    // init views
    
    FlutterViewController *controller = (FlutterViewController*)self.window.rootViewController;
    NativeViewController *nativeView = [[NativeViewController alloc] init];
    
    // setup navigator
    
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:controller];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.navigationController;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.window makeKeyAndVisible];
    
    
    /// --------------------------------------------
    /// Communication Interface
    /// --------------------------------------------
    
    FlutterMethodChannel* nativeCallChannel = [FlutterMethodChannel
                                            methodChannelWithName:@"samples.flutter.io/nativecall"
                                            binaryMessenger:controller];
    [nativeCallChannel setMethodCallHandler:^(FlutterMethodCall* call,
                                           FlutterResult result) {
        
        
        if ([@"sayHello" isEqualToString:call.method]) {
            
            NSString *helloResult = [nativeView sayHello :@"Eason"];
            result(helloResult);
        }
        else if ([@"push_pop_view" isEqualToString:call.method]) {
            
            result(@("push_pop_view"));
            
            NSString * storyboardName = @"Main";
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
            UIViewController * view_from_board = [storyboard instantiateViewControllerWithIdentifier:@"NativeViewController"];
            [self.navigationController pushViewController:view_from_board animated:true];
//            [self.navigationController presentModalViewController:vc animated:true];
            
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
