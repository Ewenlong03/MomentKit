//
//  Moment.h
//  MomentKit
//
//  Created by LEA on 2017/12/12.
//  Copyright © 2017年 LEA. All rights reserved.
//
//  动态Model
//

#import "JKDBModel.h"
#import "Comment.h"
#import "MPicture.h"
#import "MUser.h"

@interface Moment : JKDBModel

// 正文
@property (nonatomic, copy) NSString * text;
// 发布者名字
@property (nonatomic, copy) NSString * userName;
// 发布者头像路径
@property (nonatomic, copy) NSString * userPortrait;
// 发布位置(地标)
@property (nonatomic, copy) NSString * landmark;
// 发布位置(详细地址)
@property (nonatomic, copy) NSString * address;
// 发布位置(eg 杭州·雷峰塔景区 )
@property (nonatomic, copy) NSString * location;
// 单张图片的宽度
@property (nonatomic, assign) double singleWidth;
// 单张图片的高度
@property (nonatomic, assign) double singleHeight;
// 发布时间戳
@property (nonatomic, assign) long long time;
// 显示'全文'/'收起'
@property (nonatomic, assign) BOOL isFullText;
// 是否已经点赞
@property (nonatomic, assign) BOOL isLike;
// 经度
@property (nonatomic, assign) double longitude;
// 维度
@property (nonatomic, assign) double latitude;
// 评论集合
@property (nonatomic, strong) NSArray<Comment *> *commentList;
// 点赞集合
@property (nonatomic, strong) NSArray<MUser *> *likeList;
// 图片集合
@property (nonatomic, strong) NSArray<MPicture *> *pictureList;

// Moment对应cell高度
@property (nonatomic, assign) double rowHeight;


+ (NSArray *)transients;

@end
