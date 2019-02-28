//
//  MomentUtil.h
//  MomentKit
//
//  Created by LEA on 2019/2/1.
//  Copyright © 2019 LEA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Comment.h"
#import "Moment.h"
#import "Message.h"
#import "MPicture.h"
#import "MUser.h"

@interface MomentUtil : NSObject

// 初始化
+ (void)initMomentData;

// 获取动态集合
+ (NSArray *)getMomentList:(int)momentId pageNum:(int)pageNum;
// 获取字符数组
+ (NSString *)getLikeString:(Moment *)moment;

@end
