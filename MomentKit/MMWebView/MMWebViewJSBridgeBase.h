//
//  MMWebViewJSBridgeBase.h
//  MMWebView
//
//  Created by LEA on 2017/5/22.
//  Copyright © 2017年 LEA. All rights reserved.
//
//  本类所有方法及实现均来自 https://github.com/marcuswestin/WebViewJavascriptBridge
//

#import <Foundation/Foundation.h>
#import "MMWebViewJS.h"

#define kOldProtocolScheme  @"wvjbscheme"
#define kNewProtocolScheme  @"https"
#define kQueueHasMessage    @"__wvjb_queue_message__"
#define kBridgeLoaded       @"__bridge_loaded__"

typedef void (^WVJSResponseCallback)(id responseData);
typedef void (^WVJSHandler)(id data, WVJSResponseCallback responseCallback);
typedef NSDictionary WVJSMessage;


@protocol MMWebViewJSBridgeBaseDelegate;
@interface MMWebViewJSBridgeBase : NSObject

@property (weak, nonatomic) id <MMWebViewJSBridgeBaseDelegate> delegate;
@property (strong, nonatomic) NSMutableArray * startupMessageQueue;
@property (strong, nonatomic) NSMutableDictionary * responseCallbacks;
@property (strong, nonatomic) NSMutableDictionary * messageHandlers;


- (void)sendData:(id)data responseCallback:(WVJSResponseCallback)responseCallback handlerName:(NSString*)handlerName;
- (void)flushMessageQueue:(NSString *)messageQueueString;
- (void)logUnkownMessage:(NSURL*)url;
- (void)injectJavascriptFile;
- (void)reset;

- (BOOL)isWebViewJavascriptBridgeURL:(NSURL*)url;
- (BOOL)isQueueMessageURL:(NSURL*)urll;
- (BOOL)isBridgeLoadedURL:(NSURL*)urll;

- (NSString *)webViewJavascriptCheckCommand;
- (NSString *)webViewJavascriptFetchQueyCommand;


@end

@protocol MMWebViewJSBridgeBaseDelegate <NSObject>

- (NSString *)_evaluateJavascript:(NSString *)javascriptCommand;

@end
