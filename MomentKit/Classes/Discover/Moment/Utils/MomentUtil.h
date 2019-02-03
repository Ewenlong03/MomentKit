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
#import "User.h"

@interface MomentUtil : NSObject

// 获取动态集合
+ (NSArray *)getMomentList:(int)momentPk pageNum:(int)pageNum;
// 字符转数组
+ (NSArray *)getPraiseList:(NSString *)praiseString;
// 数组转字符
+ (NSString *)getPraiseString:(NSArray *)praiseList;

@end
