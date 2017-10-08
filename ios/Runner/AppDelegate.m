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


@end
