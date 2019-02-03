//
//  MessageViewController.h
//  MomentKit
//
//  Created by LEA on 2019/2/2.
//  Copyright © 2019 LEA. All rights reserved.
//

#import <UIKit/UIKit.h>

//#### 对话controller
@interface MessageViewController : UIViewController

@end

//#### 对话cell
@class Message;
@interface MessageCell : UITableViewCell

@property (nonatomic, strong) Message * message;

@end

//#### 对话Model
@interface Message : JKDBModel

// 名字
@property (nonatomic, copy) NSString * userName;
// 头像路径
@property (nonatomic, copy) NSString * userPortrait;
// 名字
@property (nonatomic, copy) NSString * content;
// 时间戳
@property (nonatomic, assign) long long time;

@end
