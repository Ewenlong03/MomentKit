//
//  MessageViewController.h
//  MomentKit
//
//  Created by LEA on 2019/2/2.
//  Copyright © 2019 LEA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"

//#### 对话controller
@interface MessageViewController : UIViewController

@end

//#### 对话cell
@interface MessageCell : UITableViewCell

@property (nonatomic, strong) Message * message;

@end

