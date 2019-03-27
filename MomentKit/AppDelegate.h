//
//  AppDelegate.h
//  MomentKit
//
//  Created by LEA on 2017/12/12.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

// 用于记录当前点击的评论frame
@property (nonatomic, assign) CGRect convertRect;

+ (AppDelegate *)sharedInstance;

@end

