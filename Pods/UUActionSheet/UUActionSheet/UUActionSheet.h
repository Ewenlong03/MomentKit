//
//  UUActionSheet.h
//  UUActionSheet
//
//  Created by LEA on 2017/3/11.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UUActionSheetDelegate;
@interface UUActionSheet : UIView

- (UUActionSheet *)initWithTitle:(NSString *)title delegate:(id<UUActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;

@property (nonatomic, weak) id<UUActionSheetDelegate> delegate;
@property (nonatomic, copy) NSString * title;
@property (nonatomic) NSInteger cancelButtonIndex;
@property (nonatomic) NSInteger destructiveButtonIndex;
@property (nonatomic, readonly) NSInteger numberOfButtons;

- (void)showInView:(UIView *)view;
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;

@end


@protocol UUActionSheetDelegate <NSObject>
@optional

- (void)actionSheet:(UUActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
