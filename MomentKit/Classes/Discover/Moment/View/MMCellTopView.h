//
//  MMCellTopView.h
//  MomentKit
//
//  Created by Ewenlong03 on 2020/1/3.
//  Copyright © 2020 LEA. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MMCellTopViewDelegate <NSObject>

- (void)didOperatorMMCellTopView:(MMOperateType)operateType;

@end

@interface MMCellTopView : UIView

@property (nonatomic, weak) id<MMCellTopViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
