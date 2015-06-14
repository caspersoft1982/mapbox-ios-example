//
//  AppDelegate.m
//  Mapbox Example
//
//  Copyright (c) 2014 Mapbox, Inc. All rights reserved.
//

#import "AppDelegate.h"

#import "OnlineLayerViewController.h"
#import "OfflineLayerViewController.h"
#import "InteractiveLayerViewController.h"

#import "Mapbox.h"

@implementation AppDelegate

@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    [[RMConfiguration sharedInstance] setAccessToken:@"pk.eyJ1IjoianVzdGluIiwiYSI6IlpDbUJLSUEifQ.4mG8vhelFMju6HpIY-Hi5A"];

    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    
    NSMutableArray *viewControllers = [NSMutableArray array];
    
    for (NSString *typeString in [NSArray arrayWithObjects:@"online", @"offline", @"interactive", nil])
    {
        Class ViewControllerClass = NSClassFromString([NSString stringWithFormat:@"%@LayerViewController", [typeString capitalizedString]]);
        
        UIViewController *viewController = [[ViewControllerClass alloc] initWithNibName:nil bundle:nil];
        
        viewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:[NSString stringWithFormat:@"%@ Layer", [typeString capitalizedString]]
                                                                  image:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", typeString]] 
                                                                    tag:0];
        
        [viewControllers addObject:viewController];
    }
    
    tabBarController.viewControllers = viewControllers;
    
    self.window.rootViewController = tabBarController;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end