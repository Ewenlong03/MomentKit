//
//  MomentUtil.m
//  MomentKit
//
//  Created by LEA on 2019/2/1.
//  Copyright © 2019 LEA. All rights reserved.
//

#import "MomentUtil.h"

@implementation MomentUtil

// 获取动态集合
+ (NSArray *)getMomentList:(int)momentPk pageNum:(int)pageNum
{
    NSString * sql = nil;
    if (momentPk == 0) {
        sql = [NSString stringWithFormat:@"ORDER BY pk DESC limit %d",pageNum];
    } else {
        sql = [NSString stringWithFormat:@"WHERE pk < %d ORDER BY pk DESC limit %d",momentPk,pageNum];
    }
    NSMutableArray * momentList = [[NSMutableArray alloc] init];
    NSArray * tempList = [Moment findByCriteria:sql];
    NSInteger count = [tempList count];
    for (NSInteger i = 0; i < count; i ++) {
        Moment * moment = [tempList objectAtIndex:i];
        // 获取评论
        NSArray * commentList = [Comment findByCriteria:[NSString stringWithFormat:@"WHERE momentPk = %d",moment.pk]];
        moment.commentList = commentList;
        [momentList addObject:moment];
    }
    return momentList;
}

// 字符转数组
+ (NSArray *)getPraiseList:(NSString *)praiseString
{
    return [praiseString componentsSeparatedByString:@"，"];
}

// 数组转字符
+ (NSString *)getPraiseString:(NSArray *)praiseList
{
    NSMutableString * praiseString = [NSMutableString string];
    NSInteger count = [praiseList count];
    for (NSInteger i = 0; i < count; i ++) {
        if (i == 0) {
            [praiseString appendString:[praiseList objectAtIndex:i]];
        } else {
            [praiseString appendString:[NSString stringWithFormat:@"，%@",[praiseList objectAtIndex:i]]];
        }
    }
    return praiseString;
}

@end
