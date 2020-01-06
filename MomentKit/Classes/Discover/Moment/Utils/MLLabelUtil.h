//
//  MLLabelUtil.h
//  MomentKit
//
//  Created by LEA on 2017/12/13.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MLLabel/MLLinkLabel.h>
#import "Moment.h"
#import "Comment.h"
#import <YYText/YYLabel.h>

@interface MLLabelUtil : NSObject

// 获取ML_linkLabel
MLLinkLabel *kMLLinkLabel(BOOL isMoment);
// 获取yy_linkLabel
YYLabel *kYYLabel(BOOL isMoment);
// 获取富文本
NSMutableAttributedString *kMLLinkAttributedText(id object);

@end
