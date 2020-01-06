//
//  MMImageView.h
//  MomentKit
//
//  Created by Ewenlong03 on 2020/1/3.
//  Copyright © 2020 LEA. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMImageView : UIImageView
// 点击小图
@property (nonatomic, copy) void (^clickHandler)(MMImageView *imageView);

@end

NS_ASSUME_NONNULL_END
