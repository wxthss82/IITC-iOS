//
//  ViewController.m
//  IITC
//
//  Created by Hubert on 14-3-19.
//  Copyright (c) 2014年 Geek20. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
@interface ViewController ()
@property UIProgressView *progressView;
//- (IBAction)refresh:(id)sender;
//@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *Indicator;

@end

@implementation ViewController
@synthesize webView;
@synthesize progressView;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    for (NSString *js in [AppDelegate sharedInstance].js) {
        [configuration.userContentController addUserScript:[[WKUserScript alloc] initWithSource:js injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES]];
    }
    
    webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
    webView.UIDelegate = self;
    progressView = [[UIProgressView alloc] initWithFrame:CGRectZero];
    webView.translatesAutoresizingMaskIntoConstraints = NO;
    progressView.translatesAutoresizingMaskIntoConstraints = NO;
    NSMutableArray *constraits = [[NSMutableArray alloc] init];
    [self.view addSubview:webView];
    [self.view addSubview:progressView];
    [constraits addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[webView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(webView)]];
    [constraits addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[webView]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(webView)]];
    [constraits addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[progressView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(progressView)]];
    [constraits addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[progressView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(progressView)]];
    [self.view addConstraints:constraits];
    [progressView setProgress:0.8];
    webView.backgroundColor = [UIColor blackColor];

    [webView addObserver:self forKeyPath:@"loading" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.ingress.com/intel"]]];
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary *)change context:(nullable void *)context {
    if ([keyPath isEqualToString: @"loading"]) {
//        if (!webView.loading) {
//            [self loadIntelFinished];
//        }
    }
    else {
//        NSLog(@"%f", webView.estimatedProgress);
        [self.progressView setProgress:webView.estimatedProgress animated:YES];
//        [webView evaluateJavaScript:@"document.readyState" completionHandler:^(NSString * __nullable result, NSError * __nullable error) {
//            if (result) {
//                NSLog(result);
//                if ([result isEqual:@"loaded"]||[result isEqual:@"interactive"]) {
//                    
//                    [self loadIntelFinished];
//                }
//            }
//        }];
        //    NSLog(result);
        
    }
}

//- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
//{
//    //WebView.frame=[[UIScreen mainScreen] bounds];
//}


- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action) {
                                                          completionHandler();
                                                      }]];
    [self presentViewController:alertController animated:YES completion:^{}];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString *))completionHandler {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:webView.URL.host preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.text = defaultText;
    }];
    
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *input = ((UITextField *)alertController.textFields.firstObject).text;
        completionHandler(input);
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        completionHandler(nil);
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)loadIntelFinished {
    [webView evaluateJavaScript:@"script=document.createElement('script');script.src='http://iitc.jonatkins.com/release/total-conversion-build.user.js';document.body.appendChild(script);script1=document.createElement('script');script1.src='http://iitc.jonatkins.com/release/plugins/player-tracker.user.js';document.body.appendChild(script1);script2=document.createElement('script');script2.src='http://iitc.jonatkins.com/release/plugins/portal-highlighter-high-level.user.js';document.body.appendChild(script2);script3=document.createElement('script');script3.src='http://iitc.jonatkins.com/release/plugins/draw-tools.user.js';document.body.appendChild(script3);" completionHandler: ^(id a, NSError * error){
        if (error) {
            NSLog([error description]);
        }
    }];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return YES;
//}
//- (void) webViewDidFinishLoad:(UIWebView *)webView
//{
//    [self.Indicator stopAnimating];
//}
//- (void) webViewDidStartLoad:(UIWebView *)webView
//{
//    [self.Indicator startAnimating];
//}

//- (void) handleTimer: (NSTimer *) timer
//{
//    NSString* result = [WebView stringByEvaluatingJavaScriptFromString:@"document.readyState"];
//    NSLog(result);
//    if ([result isEqual:@"loaded"]||[result isEqual:@"interactive"]) {
//        [WebView stringByEvaluatingJavaScriptFromString:
//         @"javascript:script=document.createElement('script');script.src='http://iitc.jonatkins.com/release/total-conversion-build.user.js';document.body.appendChild(script);script1=document.createElement('script');script1.src='http://iitc.jonatkins.com/release/plugins/player-tracker.user.js';document.body.appendChild(script1);script2=document.createElement('script');script2.src='http://iitc.jonatkins.com/release/plugins/portal-highlighter-high-level.user.js';document.body.appendChild(script2);script3=document.createElement('script');script3.src='http://iitc.jonatkins.com/release/plugins/draw-tools.user.js';document.body.appendChild(script3);"];
//    }
//    else self.timer = [NSTimer scheduledTimerWithTimeInterval: 0.5
//                                                      target: self
//                                                    selector: @selector(handleTimer:)
//                                                    userInfo: nil
//                                                     repeats: NO];
//}
//
//- (IBAction)refresh:(id)sender {
//    [WebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.ingress.com/intel"]]];
//    self.timer = [NSTimer scheduledTimerWithTimeInterval: 0.5
//                                             target: self
//                                           selector: @selector(handleTimer:)
//                                           userInfo: nil
//                                            repeats: NO];
//}
//- (IBAction)loadWeeding:(id)sender {
//    [WebView stringByEvaluatingJavaScriptFromString:
//     @"javascript:var test = '[{\"type\":\"polyline\",\"latLngs\":[{\"lat\":39.906585,\"lng\":116.102251},{\"lat\":40.11445379761235,\"lng\":116.08195066452026}],\"color\":\"#a24ac3\"},{\"type\":\"polyline\",\"latLngs\":[{\"lat\":39.906584732102026,\"lng\":116.10225163400172},{\"lat\":40.096710281316724,\"lng\":116.58213503658772}],\"color\":\"#a24ac3\"},{\"type\":\"polyline\",\"latLngs\":[{\"lat\":40.096709,\"lng\":116.582135},{\"lat\":40.11446200258458,\"lng\":116.08195066452026}],\"color\":\"#a24ac3\"},{\"type\":\"polyline\",\"latLngs\":[{\"lat\":40.096709,\"lng\":116.582135},{\"lat\":39.80425276591587,\"lng\":116.48326210677624}],\"color\":\"#a24ac3\"},{\"type\":\"polyline\",\"latLngs\":[{\"lat\":39.80425276591587,\"lng\":116.48326210677624},{\"lat\":39.906585760851776,\"lng\":116.10225096344948}],\"color\":\"#a24ac3\"},{\"type\":\"polygon\",\"latLngs\":[{\"lat\":39.906585760851776,\"lng\":116.10225230455399},{\"lat\":40.096710281316724,\"lng\":116.58213436603545},{\"lat\":39.794721456089924,\"lng\":116.48664236068726}],\"color\":\"#a24ac3\"},{\"type\":\"polygon\",\"latLngs\":[{\"lat\":39.90658627522665,\"lng\":116.10224962234498},{\"lat\":40.09670822953843,\"lng\":116.58213436603545},{\"lat\":39.795593,\"lng\":116.486781}],\"color\":\"#a24ac3\"},{\"type\":\"polygon\",\"latLngs\":[{\"lat\":40.096708742482996,\"lng\":116.58213503658772},{\"lat\":39.906585,\"lng\":116.102251},{\"lat\":39.79786212764511,\"lng\":116.4864706993103}],\"color\":\"#a24ac3\"},{\"type\":\"polygon\",\"latLngs\":[{\"lat\":39.9065873039764,\"lng\":116.1022489517927},{\"lat\":40.096708742482996,\"lng\":116.58213704824446},{\"lat\":39.79866169828622,\"lng\":116.48642778396606}],\"color\":\"#a24ac3\"},{\"type\":\"polygon\",\"latLngs\":[{\"lat\":39.90658421772712,\"lng\":116.102254986763},{\"lat\":40.096709,\"lng\":116.582135},{\"lat\":39.80118399423497,\"lng\":116.48575186729431}],\"color\":\"#a24ac3\"},{\"type\":\"polygon\",\"latLngs\":[{\"lat\":39.90658627522665,\"lng\":116.10225163400172},{\"lat\":40.096709,\"lng\":116.582135},{\"lat\":39.80220607474971,\"lng\":116.4858055114746}],\"color\":\"#a24ac3\"},{\"type\":\"polygon\",\"latLngs\":[{\"lat\":39.90658833272612,\"lng\":116.10225230455399},{\"lat\":40.096708742482996,\"lng\":116.58213503658772},{\"lat\":39.804027648324,\"lng\":116.4837321639061}],\"color\":\"#a24ac3\"},{\"type\":\"polygon\",\"latLngs\":[{\"lat\":39.90658781835128,\"lng\":116.10224828124046},{\"lat\":40.096708742482996,\"lng\":116.58213168382643},{\"lat\":39.80333529120255,\"lng\":116.48436784744264}],\"color\":\"#a24ac3\"},{\"type\":\"polygon\",\"latLngs\":[{\"lat\":39.906585760851776,\"lng\":116.10225364565848},{\"lat\":40.09670822953843,\"lng\":116.58213503658772},{\"lat\":39.802403895030125,\"lng\":116.48565530776979}],\"color\":\"#a24ac3\"},{\"type\":\"marker\",\"latLng\":{\"lat\":39.804253,\"lng\":116.483263},\"color\":\"#a24ac3\"},{\"type\":\"marker\",\"latLng\":{\"lat\":39.804002921403985,\"lng\":116.48374557495117},\"color\":\"#a24ac3\"},{\"type\":\"marker\",\"latLng\":{\"lat\":39.803325,\"lng\":116.484359},\"color\":\"#a24ac3\"},{\"type\":\"marker\",\"latLng\":{\"lat\":39.802423,\"lng\":116.485639},\"color\":\"#a24ac3\"},{\"type\":\"marker\",\"latLng\":{\"lat\":39.802226,\"lng\":116.485804},\"color\":\"#a24ac3\"},{\"type\":\"marker\",\"latLng\":{\"lat\":39.801193,\"lng\":116.485741},\"color\":\"#a24ac3\"},{\"type\":\"marker\",\"latLng\":{\"lat\":39.79866,\"lng\":116.486467},\"color\":\"#a24ac3\"},{\"type\":\"marker\",\"latLng\":{\"lat\":39.797859,\"lng\":116.486471},\"color\":\"#a24ac3\"},{\"type\":\"marker\",\"latLng\":{\"lat\":39.795593,\"lng\":116.486781},\"color\":\"#a24ac3\"},{\"type\":\"marker\",\"latLng\":{\"lat\":39.794737,\"lng\":116.486633},\"color\":\"#a24ac3\"},{\"type\":\"marker\",\"latLng\":{\"lat\":39.906585,\"lng\":116.102251},\"color\":\"#a24ac3\"},{\"type\":\"marker\",\"latLng\":{\"lat\":40.09670976837216,\"lng\":116.58213637769221},\"color\":\"#a24ac3\"},{\"type\":\"polygon\",\"latLngs\":[{\"lat\":40.09670822953843,\"lng\":116.58213369548321},{\"lat\":39.90658421772712,\"lng\":116.10225297510624},{\"lat\":40.10133483238621,\"lng\":116.08551800251006}],\"color\":\"#a24ac3\"},{\"type\":\"polygon\",\"latLngs\":[{\"lat\":39.906584732102026,\"lng\":116.10225297510624},{\"lat\":40.096709,\"lng\":116.582135},{\"lat\":40.10111120338659,\"lng\":116.08592033386229}],\"color\":\"#a24ac3\"},{\"type\":\"polygon\",\"latLngs\":[{\"lat\":39.906586789601526,\"lng\":116.10225029289722},{\"lat\":40.096709,\"lng\":116.582135},{\"lat\":40.10191852112867,\"lng\":116.08448937535285}],\"color\":\"#a24ac3\"},{\"type\":\"polygon\",\"latLngs\":[{\"lat\":39.9065873039764,\"lng\":116.1022489517927},{\"lat\":40.096709,\"lng\":116.582135},{\"lat\":40.10220061846236,\"lng\":116.08417421579361}],\"color\":\"#a24ac3\"},{\"type\":\"polygon\",\"latLngs\":[{\"lat\":39.9065873039764,\"lng\":116.10225096344948},{\"lat\":40.096709,\"lng\":116.582135},{\"lat\":40.101567692994536,\"lng\":116.08487293124199}],\"color\":\"#a24ac3\"},{\"type\":\"polygon\",\"latLngs\":[{\"lat\":39.9065852464769,\"lng\":116.10225096344948},{\"lat\":40.096709,\"lng\":116.582135},{\"lat\":40.101677455207565,\"lng\":116.08464092016219}],\"color\":\"#a24ac3\"},{\"type\":\"polygon\",\"latLngs\":[{\"lat\":39.90658833272612,\"lng\":116.10225163400172},{\"lat\":40.096708742482996,\"lng\":116.58213302493095},{\"lat\":40.10250835967424,\"lng\":116.08401998877527}],\"color\":\"#a24ac3\"},{\"type\":\"polygon\",\"latLngs\":[{\"lat\":40.103321,\"lng\":116.083576},{\"lat\":40.09670822953843,\"lng\":116.58213704824446},{\"lat\":39.906584732102026,\"lng\":116.10225096344948}],\"color\":\"#a24ac3\"},{\"type\":\"marker\",\"latLng\":{\"lat\":40.101101,\"lng\":116.085929},\"color\":\"#a24ac3\"},{\"type\":\"marker\",\"latLng\":{\"lat\":40.10133,\"lng\":116.085523},\"color\":\"#a24ac3\"},{\"type\":\"marker\",\"latLng\":{\"lat\":40.101567692994536,\"lng\":116.08487293124199},\"color\":\"#a24ac3\"},{\"type\":\"marker\",\"latLng\":{\"lat\":40.101677455207565,\"lng\":116.08464092016219},\"color\":\"#a24ac3\"},{\"type\":\"marker\",\"latLng\":{\"lat\":40.10191852112867,\"lng\":116.08448535203934},\"color\":\"#a24ac3\"},{\"type\":\"marker\",\"latLng\":{\"lat\":40.102202,\"lng\":116.084177},\"color\":\"#a24ac3\"},{\"type\":\"marker\",\"latLng\":{\"lat\":40.102509,\"lng\":116.084021},\"color\":\"#a24ac3\"},{\"type\":\"marker\",\"latLng\":{\"lat\":40.103321,\"lng\":116.083576},\"color\":\"#a24ac3\"},{\"type\":\"marker\",\"latLng\":{\"lat\":40.114495,\"lng\":116.081966},\"color\":\"#a24ac3\"}]';try {var data = JSON.parse(test);window.plugin.drawTools.drawnItems.clearLayers();window.plugin.drawTools.import(data);console.log('DRAWTOOLS: reset and imported drawn tiems');window.plugin.drawTools.optAlert('Import Successful.');window.plugin.drawTools.save();} catch (e) {console.warn('DRAWTOOLS: failed to import data: ' + e);window.plugin.drawTools.optAlert('<span style=\"color: #f88\">Import failed</span>');}"];
//}
@end
