//
//  WKWebViewController.m
//  MomentKit
//
//  Created by LEA on 2019/2/2.
//  Copyright © 2019 LEA. All rights reserved.
//

#import "WKWebViewController.h"
#import <MMWebView.h>

@interface WKWebViewController ()<MMWebViewDelegate>

@end

@implementation WKWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MMWebView * webView = [[MMWebView alloc] initWithFrame:CGRectMake(0, 0, k_screen_width, k_screen_height-k_top_height)];
    webView.backgroundColor = [UIColor whiteColor];
    webView.opaque = NO;
    webView.delegate = self;
    webView.displayProgressBar = YES;
    webView.allowsBackForwardNavigationGestures = YES;
    webView.progressTintColor = MMRGBColor(30.f, 191.f, 97.f); 
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    [self.view addSubview:webView];
}

#pragma mark - MMWebViewDelegate
- (void)webView:(MMWebView *)webView didUpdateTitle:(NSString *)title
{
    self.title = title;
}

@end
