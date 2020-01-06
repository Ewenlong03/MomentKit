//
//  MMCellTopView.m
//  MomentKit
//
//  Created by Ewenlong03 on 2020/1/3.
//  Copyright © 2020 LEA. All rights reserved.
//

#import "MMCellTopView.h"
#import "MMImageView.h"
 
@interface MMCellTopView ()

@property (nonatomic, strong) MMImageView *avatarImageView;
@property (nonatomic, strong) UIButton * nicknameBtn; // 名称
@end

@implementation MMCellTopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    WS(wSelf);
    //头像
    _avatarImageView = [[MMImageView alloc] initWithFrame:CGRectMake(kRightMargin, kBlank, kAvatarWidth, kAvatarWidth)];
    _avatarImageView.layer.cornerRadius = kAvatarWidth/2;
    
    [_avatarImageView setClickHandler:^(MMImageView *imageView) {
        if ([wSelf.delegate respondsToSelector:@selector(didOperatorMMCellTopView:)]) {
            [wSelf.delegate didOperatorMMCellTopView: MMOperateTypeProfile];
        }
    }];
    [self addSubview:_avatarImageView];
    
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).mas_offset(kRightMargin);
        make.centerY.equalTo(self);
        make.width.height.mas_equalTo(kAvatarWidth);
    }];
    
    //userName
    _nicknameBtn = [[UIButton alloc] init];
    _nicknameBtn.tag = MMOperateTypeProfile;
    _nicknameBtn.titleLabel.font = [UIFont fontWithName:PingFangFontSemibold size:14];
    _nicknameBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_nicknameBtn setTitleColor:RGB_Hex(0x333333) forState:UIControlStateNormal];
    [_nicknameBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_nicknameBtn];
    
    [_nicknameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_avatarImageView.mas_right).mas_offset(8);
        make.top.equalTo(_avatarImageView.mas_top);
        make.width.mas_equalTo(100);
        make.height.mas_offset(kAvatarWidth/2);
    }];
}

- (void)buttonClicked:(UIButton *)sender {
    
}

@end
