//
//  ViewController.h
//  IITC
//
//  Created by Hubert on 14-3-19.
//  Copyright (c) 2014年 Geek20. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface ViewController : UIViewController <WKUIDelegate>
@property (strong, nonatomic) WKWebView *webView;
@end
