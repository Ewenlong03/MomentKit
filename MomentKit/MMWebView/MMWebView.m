//
//  MMWebView.m
//  MMWebView
//
//  Created by LEA on 2017/5/22.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "MMWebView.h"

@interface MMWebView ()<MMWebViewJSBridgeBaseDelegate>

@property (nonatomic, strong) UIProgressView * progressBar;
@property (nonatomic, strong) MMWebViewJSBridgeBase * base;

@end

@implementation MMWebView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    // 初始化数据
    _allowBackGesture = NO;
    _displayProgressBar = NO;
    _trackTintColor = [UIColor clearColor];
    _progressTintColor = [UIColor orangeColor];
    // 监听
    [self addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)setupJSBridge
{
    _base = [[MMWebViewJSBridgeBase alloc] init];
    _base.delegate = self;
}

#pragma mark - JS相关
- (void)registerHandler:(NSString *)handlerName handler:(WVJSHandler)handler {
    _base.messageHandlers[handlerName] = [handler copy];
}

- (void)removeHandler:(NSString *)handlerName {
    [_base.messageHandlers removeObjectForKey:handlerName];
}

- (void)callHandler:(NSString *)handlerName {
    [self callHandler:handlerName data:nil responseCallback:nil];
}

- (void)callHandler:(NSString *)handlerName data:(id)data {
    [self callHandler:handlerName data:data responseCallback:nil];
}

- (void)callHandler:(NSString *)handlerName data:(id)data responseCallback:(WVJSResponseCallback)responseCallback {
    [_base sendData:data responseCallback:responseCallback handlerName:handlerName];
}

- (void)send:(id)data {
    [self send:data responseCallback:nil];
}

- (void)send:(id)data responseCallback:(WVJSResponseCallback)responseCallback {
    [_base sendData:data responseCallback:responseCallback handlerName:nil];
}

- (void)reset {
    [_base reset];
}

- (void)WKFlushMessageQueue {
    [self evaluateJavaScript:[_base webViewJavascriptFetchQueyCommand] completionHandler:^(NSString *result, NSError *error) {
        if (error != nil) {
            NSLog(@"JSBridge Error: %@", error);
        }
        [_base flushMessageQueue:result];
    }];
}

#pragma mark - 清缓存
- (void)clearCache
{
    // 所有类型缓存[详见WKWebsiteDataRecord]
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    // 所有时间
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:0];
    // 移除
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes
                                               modifiedSince:date
                                           completionHandler:^{
                                               
                                           }];
}

#pragma mark - 进度<KVO>
// 网页加载进度 || 网页标题
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self && [keyPath isEqualToString:@"estimatedProgress"])
    {
        CGFloat progress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        self.progressBar.progress = progress;
        if (progress == 1.0) {
            self.progressBar.progress = 0;
        }
        if ([self.delegate respondsToSelector:@selector(webView:estimatedProgress:)]) {
            [self.delegate webView:self estimatedProgress:progress];
        }
    }
    if (object == self && [keyPath isEqualToString:@"title"])
    {
        NSString *title = [change objectForKey:NSKeyValueChangeNewKey];
        if ([self.delegate respondsToSelector:@selector(webView:didUpdateTitle:)] && title) {
            [self.delegate webView:self didUpdateTitle:title];
        }
    }
}

#pragma mark - 代理<WKNavigationDelegate>
// 网页开始加载
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSURL * url = navigationAction.request.URL;
    if (_base && [_base isWebViewJavascriptBridgeURL:url]) {
        if ([_base isBridgeLoadedURL:url]) {
            [_base injectJavascriptFile];
        } else if ([_base isQueueMessageURL:url]) {
            [self WKFlushMessageQueue];
        } else {
            [_base logUnkownMessage:url];
        }
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    BOOL isAllow = YES;
    if ([self.delegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        isAllow = [self.delegate webView:self
              shouldStartLoadWithRequest:navigationAction.request
                          navigationType:navigationAction.navigationType];
    }
    if (isAllow) {
        decisionHandler(WKNavigationActionPolicyAllow);
    } else {
        decisionHandler(WKNavigationActionPolicyCancel);
    }
}

// 网页开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    if ([self.delegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [self.delegate webViewDidStartLoad:self];
    }
}

// 网页完成加载
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    if ([self.delegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [self.delegate webViewDidFinishLoad:self];
    }
}

// 网页加载出错
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [self.delegate webView:self didFailLoadWithError:error];
    }
}

#pragma mark - 代理<MMWebViewJSBridgeBaseDelegate>
- (NSString *)_evaluateJavascript:(NSString*)javascriptCommand {
    [self evaluateJavaScript:javascriptCommand completionHandler:nil];
    return NULL;
}

#pragma mark - setter
- (void)setDelegate:(id<MMWebViewDelegate>)delegate {
    _delegate = delegate;
    if (delegate) {
        self.navigationDelegate = self;
    }
}

- (void)setDisplayProgressBar:(BOOL)displayProgressBar {
    _displayProgressBar = displayProgressBar;
    self.progressBar.hidden = !displayProgressBar;
}

- (void)setAllowBackGesture:(BOOL)allowBackGesture {
    _allowBackGesture = allowBackGesture;
    self.allowsBackForwardNavigationGestures = allowBackGesture;
}

- (void)setTrackTintColor:(UIColor *)trackTintColor {
    _trackTintColor = trackTintColor;
    self.progressBar.trackTintColor = trackTintColor;
}

- (void)setProgressTintColor:(UIColor *)progressTintColor {
    _progressTintColor = progressTintColor;
    self.progressBar.progressTintColor = progressTintColor;
}

#pragma mark - getter
- (UIProgressView *)progressBar
{
    if (!_progressBar) {
        _progressBar = [[UIProgressView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.bounds.size.width, 5.0f)];
        _progressBar.backgroundColor = [UIColor clearColor];
        _progressBar.trackTintColor = _trackTintColor;
        _progressBar.progressTintColor = _progressTintColor;
        _progressBar.hidden = !_displayProgressBar;
        [self addSubview:_progressBar];
    }
    return _progressBar;
}

#pragma mark - dealloc
- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"estimatedProgress"];
    [self removeObserver:self forKeyPath:@"title"];
}

@end


