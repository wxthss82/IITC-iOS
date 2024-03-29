//
//  AppDelegate.m
//  IITC
//
//  Created by Hubert on 14-3-19.
//  Copyright (c) 2014年 Geek20. All rights reserved.
//

#import "AppDelegate.h"

static AppDelegate * _sharedInstance;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.js = [[NSMutableArray alloc] init];
    _sharedInstance = self;
    // Override point for customization after application launch.
    NSArray * addresses = @[@"http://iitc.jonatkins.com/release/total-conversion-build.user.js", @"http://iitc.jonatkins.com/release/plugins/player-tracker.user.js", @"http://iitc.jonatkins.com/release/plugins/portal-highlighter-high-level.user.js", @"http://iitc.jonatkins.com/release/plugins/portal-names.user.js", @"http://iitc.jonatkins.com/release/plugins/draw-tools.user.js"];
    for (NSString * address in addresses) {
        NSURL *url = [NSURL URLWithString:address];
        NSError *error;
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        [request setHTTPMethod:@"GET"];
    
        [request setTimeoutInterval:5];
        NSURLResponse *response;
        NSData *data = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:&response error:&error];
        if (error) {
            NSLog([error localizedDescription]);
        } else {
        [self.js addObject: [[NSString alloc] initWithData:data
                              encoding:NSUTF8StringEncoding]];
        }
    }
    
    return YES;
}


+ (instancetype)sharedInstance {
    return _sharedInstance;
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
