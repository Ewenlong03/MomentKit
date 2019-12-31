//
//  MMWebViewJSBridgeBase.m
//  MMWebView
//
//  Created by LEA on 2017/5/22.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "MMWebViewJSBridgeBase.h"

@interface MMWebViewJSBridgeBase () {
    long _uniqueId;
}
@end

@implementation MMWebViewJSBridgeBase

- (id)init
{
    if (self = [super init]) {
        _uniqueId = 0;
        self.messageHandlers = [NSMutableDictionary dictionary];
        self.startupMessageQueue = [NSMutableArray array];
        self.responseCallbacks = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc
{
    self.startupMessageQueue = nil;
    self.responseCallbacks = nil;
    self.messageHandlers = nil;
}

- (void)reset
{
    self.startupMessageQueue = [NSMutableArray array];
    self.responseCallbacks = [NSMutableDictionary dictionary];
    _uniqueId = 0;
}

- (void)sendData:(id)data responseCallback:(WVJSResponseCallback)responseCallback handlerName:(NSString *)handlerName
{
    NSMutableDictionary * message = [NSMutableDictionary dictionary];
    if (data) {
        message[@"data"] = data;
    }
    if (responseCallback) {
        NSString * callbackId = [NSString stringWithFormat:@"objc_cb_%ld", ++_uniqueId];
        self.responseCallbacks[callbackId] = [responseCallback copy];
        message[@"callbackId"] = callbackId;
    }
    if (handlerName) {
        message[@"handlerName"] = handlerName;
    }
    [self _queueMessage:message];
}

- (void)flushMessageQueue:(NSString *)messageQueueString
{
    if (messageQueueString == nil || messageQueueString.length == 0) {
        NSLog(@"JSBridge WARNING : ObjC got nil while fetching the message queue JSON from webview. This can happen if the WebViewJavascriptBridge JS is not currently present in the webview, e.g if the webview just loaded a new page.");
        return;
    }
    id messages = [self _deserializeMessageJSON:messageQueueString];
    for (WVJSMessage * message in messages) {
        if (![message isKindOfClass:[WVJSMessage class]]) {
            NSLog(@"JSBridge WARNING: Invalid %@ received: %@", [message class], message);
            continue;
        }        
        NSString * responseId = message[@"responseId"];
        if (responseId) {
            WVJSResponseCallback responseCallback = _responseCallbacks[responseId];
            responseCallback(message[@"responseData"]);
            [self.responseCallbacks removeObjectForKey:responseId];
        } else {
            WVJSResponseCallback responseCallback = NULL;
            NSString * callbackId = message[@"callbackId"];
            if (callbackId) {
                responseCallback = ^(id responseData) {
                    if (responseData == nil) {
                        responseData = [NSNull null];
                    }
                    WVJSMessage * msg = @{ @"responseId":callbackId, @"responseData":responseData };
                    [self _queueMessage:msg];
                };
            } else {
                responseCallback = ^(id ignoreResponseData) {
                    // Do nothing
                };
            }
            WVJSHandler handler = self.messageHandlers[message[@"handlerName"]];
            if (!handler) {
                NSLog(@"JSNoHandlerException, No handler for message from JS: %@", message);
                continue;
            }
            handler(message[@"data"], responseCallback);
        }
    }
}

- (void)injectJavascriptFile
{
    NSString * js = WebViewJavascriptBridge_js();
    [self _evaluateJavascript:js];
    if (self.startupMessageQueue) {
        NSArray * queue = self.startupMessageQueue;
        self.startupMessageQueue = nil;
        for (id queuedMessage in queue) {
            [self _dispatchMessage:queuedMessage];
        }
    }
}

- (BOOL)isWebViewJavascriptBridgeURL:(NSURL *)url {
    if (![self isSchemeMatch:url]) {
        return NO;
    }
    return [self isBridgeLoadedURL:url] || [self isQueueMessageURL:url];
}

- (BOOL)isSchemeMatch:(NSURL*)url {
    NSString* scheme = url.scheme.lowercaseString;
    return [scheme isEqualToString:kNewProtocolScheme] || [scheme isEqualToString:kOldProtocolScheme];
}

- (BOOL)isQueueMessageURL:(NSURL*)url {
    NSString * host = url.host.lowercaseString;
    return [self isSchemeMatch:url] && [host isEqualToString:kQueueHasMessage];
}

- (BOOL)isBridgeLoadedURL:(NSURL*)url {
    NSString * host = url.host.lowercaseString;
    return [self isSchemeMatch:url] && [host isEqualToString:kBridgeLoaded];
}

- (void)logUnkownMessage:(NSURL*)url {
    NSLog(@"JSBridge WARNING : Received unknown WebViewJavascriptBridge command %@", [url absoluteString]);
}

- (NSString *)webViewJavascriptCheckCommand {
    return @"typeof WebViewJavascriptBridge == \'object\';";
}

- (NSString *)webViewJavascriptFetchQueyCommand {
    return @"WebViewJavascriptBridge._fetchQueue();";
}

// Private
// -------------------------------------------

- (void) _evaluateJavascript:(NSString *)javascriptCommand {
    [self.delegate _evaluateJavascript:javascriptCommand];
}

- (void)_queueMessage:(WVJSMessage *)message {
    if (self.startupMessageQueue) {
        [self.startupMessageQueue addObject:message];
    } else {
        [self _dispatchMessage:message];
    }
}

- (void)_dispatchMessage:(WVJSMessage *)message
{
    NSString * messageJSON = [self _serializeMessage:message pretty:NO];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\'" withString:@"\\\'"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\f" withString:@"\\f"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\u2028" withString:@"\\u2028"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\u2029" withString:@"\\u2029"];
    
    NSString * javascriptCommand = [NSString stringWithFormat:@"WebViewJavascriptBridge._handleMessageFromObjC('%@');", messageJSON];
    if ([[NSThread currentThread] isMainThread]) {
        [self _evaluateJavascript:javascriptCommand];
        
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self _evaluateJavascript:javascriptCommand];
        });
    }
}

- (NSString *)_serializeMessage:(id)message pretty:(BOOL)pretty
{
    return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:message options:(NSJSONWritingOptions)(pretty ? NSJSONWritingPrettyPrinted : 0) error:nil] encoding:NSUTF8StringEncoding];
}

- (NSArray*)_deserializeMessageJSON:(NSString *)messageJSON
{
    return [NSJSONSerialization JSONObjectWithData:[messageJSON dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
}

@end
