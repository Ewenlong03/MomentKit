//
//  Comment.h
//  MomentKit
//
//  Created by LEA on 2017/12/12.
//  Copyright © 2017年 LEA. All rights reserved.
//
//  评论Model
//

#import "JKDBModel.h"

@interface Comment : JKDBModel

// 正文
@property (nonatomic, copy) NSString * text;
// 发布者名字
@property (nonatomic, copy) NSString * userName;
// 发布时间戳
@property (nonatomic, assign) long long time;
// 关联动态的PK
@property (nonatomic, assign) int momentPk;
// 回复
@property (nonatomic, assign) BOOL isReply;

@end
