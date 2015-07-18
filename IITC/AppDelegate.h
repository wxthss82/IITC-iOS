//
//  AppDelegate.h
//  IITC
//
//  Created by Hubert on 14-3-19.
//  Copyright (c) 2014年 Geek20. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
+ (instancetype)sharedInstance;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableArray *js;
@end
