//
//  MomentCell.m
//  MomentKit
//
//  Created by LEA on 2017/12/14.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "MomentCell.h"

#define MomentCellColor  RGB_Hex(0x999999)

#pragma mark - ------------------ 动态 ------------------

// 最大高度限制
CGFloat maxLimitHeight = 0;
CGFloat lineSpacing = 10;

@implementation MomentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configUI];
        // 观察者
        MM_AddObserver(self, @selector(resetMenuView), @"ResetMenuView");
        MM_AddObserver(self, @selector(resetLinkLabel), UIMenuControllerWillHideMenuNotification);
    }
    return self;
}

- (void)configUI
{
    WS(wSelf);
    // 头像视图
    _avatarImageView = [[MMImageView alloc] initWithFrame:CGRectMake(kRightMargin, kBlank, kAvatarWidth, kAvatarWidth)];
    _avatarImageView.layer.cornerRadius = kAvatarWidth/2;
    
    [_avatarImageView setClickHandler:^(MMImageView *imageView) {
        if ([wSelf.delegate respondsToSelector:@selector(didOperateMoment:operateType:)]) {
            [wSelf.delegate didOperateMoment:wSelf operateType:MMOperateTypeProfile];
        }
        [wSelf resetMenuView];
    }];
    [self.contentView addSubview:_avatarImageView];
    // 名字视图
    _nicknameBtn = [[UIButton alloc] init];
    _nicknameBtn.tag = MMOperateTypeProfile;
    _nicknameBtn.titleLabel.font = [UIFont fontWithName:PingFangFontSemibold size:14.0];
    _nicknameBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_nicknameBtn setTitleColor:RGB_Hex(0x333333) forState:UIControlStateNormal];
    [_nicknameBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_nicknameBtn];
    
    _sexImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_nicknameBtn.left, _nicknameBtn.bottom, 16, 16)];
    _sexImageView.image = [UIImage imageNamed:@"mine_2_0"];
    [self.contentView addSubview: _sexImageView];
    
    _ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(_sexImageView.right + 8, _sexImageView.top, 60, 16)];
    _ageLabel.text = @"26岁";
    _ageLabel.font = [UIFont fontWithName:PingFangFontRegular size:12];
    _ageLabel.textColor = MomentCellColor;
    _ageLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview: _ageLabel];
    
    // 正文视图 ↓↓
    _linkLabel = kYYLabel(YES);
    
    _linkLabel.textTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        NSLog(@"tap  text");
        [wSelf doOperation: MMOperateTypeClickMoment];
    };
    [self.contentView addSubview:_linkLabel];
    // 查看'全文'按钮
    _showAllBtn = [[UIButton alloc] init];
    _showAllBtn.tag = MMOperateTypeFull;
    _showAllBtn.titleLabel.font = kTextFont;
    [_showAllBtn setTitle:@"全文" forState:UIControlStateNormal];
    [_showAllBtn setTitle:@"收起" forState:UIControlStateSelected];
    [_showAllBtn setTitleColor:kHLTextColor forState:UIControlStateNormal];
    [_showAllBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_showAllBtn];
    [_showAllBtn sizeToFit];
    // 图片区
    _imageListView = [[MMImageListView alloc] initWithFrame:CGRectZero];
    [_imageListView setSingleTapHandler:^(MMImageView *imageView) {
        [wSelf resetMenuView];
    }];
    [self.contentView addSubview:_imageListView];
    // 位置视图
    _locationBtn = [[UIButton alloc] init];
    _locationBtn.tag = MMOperateTypeLocation;
    _locationBtn.layer.cornerRadius = kTimeLabelH/2;
    _locationBtn.backgroundColor = RGB_Hex(0xF9F9F9);
    _locationBtn.titleLabel.font = [UIFont fontWithName:PingFangFontRegular size:14.0];
    [_locationBtn setTitleColor:MomentCellColor forState:UIControlStateNormal];
    [_locationBtn setImage:[UIImage imageNamed:@"img_address"] forState:UIControlStateNormal];
    [_locationBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [_locationBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_locationBtn];
    // 时间视图
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = MomentCellColor;
    _timeLabel.font = [UIFont fontWithName:PingFangFontRegular size:14.0];
    [self.contentView addSubview:_timeLabel];
    //分隔视图
    _timeBreakReadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 4)];
    _timeBreakReadView.backgroundColor = RGB_Hex(0xD8D8D8);
    _timeBreakReadView.layer.cornerRadius = 2.f;
    [self.contentView addSubview: _timeBreakReadView];
    //阅读量视图
    _readLabel = [[UILabel alloc] init];
    _readLabel.textColor = MomentCellColor;
    _readLabel.font = [UIFont fontWithName:PingFangFontRegular size:14.0];
    [self.contentView addSubview:_readLabel];
    //点赞
    _likeBtn = [[UIButton alloc] init];
    _likeBtn.tag = MMOperateTypeLike;
    [_likeBtn setImage:[UIImage imageNamed:@"moment_like"] forState:UIControlStateNormal];
    [_likeBtn setImage:[UIImage imageNamed:@"moment_like_hl"] forState:UIControlStateSelected];
    [_likeBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_likeBtn];
    //评论
    _commentBtn = [[UIButton alloc] init];
    _commentBtn.tag = MMOperateTypeComment;
    [_commentBtn setImage:[UIImage imageNamed:@"moment_comment"] forState:UIControlStateNormal];
    [_commentBtn setImage:[UIImage imageNamed:@"moment_comment_hl"] forState:UIControlStateSelected];
    [_commentBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_commentBtn];
    // 评论视图
    _bgImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_bgImageView];
    _commentView = [[UIView alloc] init];
    [self.contentView addSubview:_commentView];
    // 操作视图
    _menuView = [[MMOperateMenuView alloc] initWithFrame:CGRectZero];
    [_menuView setOperateMenu:^(MMOperateType operateType) { // 评论|赞
        if ([wSelf.delegate respondsToSelector:@selector(didOperateMoment:operateType:)]) {
            [wSelf.delegate didOperateMoment:wSelf operateType:operateType];
        }
    }];
    [self.contentView addSubview:_menuView];
    // 最大高度限制
    maxLimitHeight = (_linkLabel.font.lineHeight + lineSpacing) * 6;
}

- (NSMutableAttributedString *)subjectTitle:(NSString *)title {
    
    NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:@""];
    NSMutableAttributedString *format = [[NSMutableAttributedString alloc] initWithString:@"  "];
    NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString: title];
    
    [one appendAttributedString:format];
    [one appendAttributedString: attrTitle];
    [one appendAttributedString: format];
    //设置字号
    one.yy_font = [UIFont boldSystemFontOfSize:14];
    //设置字体颜色红色
    one.yy_color = RGB_Hex(0x3AA8EF);
    
    //字体边框
    YYTextBorder *border = [YYTextBorder new];
//    //边框圆角
    border.cornerRadius = 8;
    border.fillColor = RGB_Hex(0xE6F5FF);
//    //边框边距
    border.insets = UIEdgeInsetsMake(-2, 0, -2, 0);
//    //边框线宽
    border.strokeWidth = 0.5;
//    //边框颜色等于字体颜色
    border.strokeColor = RGB_Hex(0xE6F5FF);
    border.lineStyle = YYTextLineStyleSingle;
    [one setYy_textBackgroundBorder: border];

//    //高亮边框
//     YYTextBorder *highlightBorder = border.copy;
//     highlightBorder.strokeWidth = 0;
//     highlightBorder.strokeColor = one.yy_color;
//
//    //填充颜色红色
//     highlightBorder.fillColor = one.yy_color;
//
//    //设置高亮颜色
//    YYTextHighlight *highlight = [YYTextHighlight new];
//    [highlight setColor:[UIColor whiteColor]];
//
//    //高亮的背景框
//    [highlight setBackgroundBorder: highlightBorder];
//
//    //点击高亮回调
//    highlight.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
//                NSLog(@"高亮1");
//            };
//    [one yy_setTextHighlight: highlight range:[one yy_rangeOfAll]];
    [one appendAttributedString: format];
    return one;
}

#pragma mark - setter
- (void)setMoment:(Moment *)moment
{
    _moment = moment;
    // 头像
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:moment.user.portrait] placeholderImage:nil];
    // 昵称
    [_nicknameBtn setTitle:moment.user.name forState:UIControlStateNormal];
    [_nicknameBtn sizeToFit];
    if (_nicknameBtn.width > kTextWidth) {
        _nicknameBtn.width = kTextWidth;
    }
    _nicknameBtn.frame = CGRectMake(_avatarImageView.right + 10, _avatarImageView.left + 4, _nicknameBtn.width, 20);
    // 正文
    _sexImageView.frame = CGRectMake(_nicknameBtn.left, _avatarImageView.bottom-20, 16, 16);
    _ageLabel.frame = CGRectMake(_sexImageView.right + 2, _sexImageView.top, 60, 16);
    _showAllBtn.hidden = YES;
    _linkLabel.hidden = YES;
    CGFloat bottom = _avatarImageView.bottom + kPaddingValue;
    CGFloat rowHeight = 0;
    if ([moment.text length])
    {
        _linkLabel.hidden = NO;
        NSMutableAttributedString *subject = [self subjectTitle:@"#最美的微笑"];
        NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc] initWithString: moment.text];
        attributedText.yy_font = kTextFont;
        [subject appendAttributedString: attributedText];
        NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = lineSpacing;
        style.firstLineHeadIndent = 2;
        [subject addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0,[subject length])];

        YYTextLinePositionSimpleModifier *modifier = [YYTextLinePositionSimpleModifier new];
        modifier.fixedLineHeight = 24;
            
        YYTextContainer *container = [YYTextContainer new];
        container.size = CGSizeMake(kTextWidth, CGFLOAT_MAX);
        container.linePositionModifier = modifier;
            
        YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:subject];
        CGSize attrStrSize = layout.textBoundingSize;
        _linkLabel.size = attrStrSize;
        _linkLabel.textLayout = layout;
        
        _linkLabel.attributedText = subject;
        // 判断显示'全文'/'收起'
        
        CGFloat labHeight = attrStrSize.height;
        if (labHeight > maxLimitHeight) {
            if (!_moment.isFullText) {
                labHeight = maxLimitHeight;
            }
            _showAllBtn.hidden = NO;
            _showAllBtn.selected = _moment.isFullText;
        }
        _linkLabel.frame = CGRectMake(kLeftMargin, bottom, attrStrSize.width, labHeight);
        _showAllBtn.frame = CGRectMake(kLeftMargin, _linkLabel.bottom + kArrowHeight, _showAllBtn.width, kMoreLabHeight);
        if (_showAllBtn.hidden) {
            bottom = _linkLabel.bottom + kPaddingValue;
        } else {
            bottom = _showAllBtn.bottom + kPaddingValue;
        }
        // 添加长按手势
        if (!_longPress) {
            _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressHandler:)];
        }
        [_linkLabel addGestureRecognizer:_longPress];
    }
    // 图片
    _imageListView.moment = moment;
    if ([moment.pictureList count] > 0) {
        _imageListView.origin = CGPointMake(kLeftMargin, bottom);
        bottom = _imageListView.bottom + kPaddingValue;
    }
    // 位置
    _timeLabel.text = [Utility getMomentTime:moment.time];
    [_timeLabel sizeToFit];
    _readLabel.text = @"23456阅读";
    [_readLabel sizeToFit];
    if (moment.location) {
        [_locationBtn setTitle: moment.location.position forState:UIControlStateNormal];
        [_locationBtn sizeToFit];
        _locationBtn.hidden = NO;
        _locationBtn.frame = CGRectMake(kLeftMargin, bottom, _locationBtn.width+20, kTimeLabelH);
        bottom = _locationBtn.bottom + kPaddingValue;
    } else {
        _locationBtn.hidden = YES;
    }
    _timeLabel.frame = CGRectMake(kLeftMargin, bottom, _timeLabel.width, kTimeLabelH);
    _timeBreakReadView.centerY = _timeLabel.centerY;
    _timeBreakReadView.left = _timeLabel.right + 6;
    _readLabel.frame = CGRectMake(_timeBreakReadView.right + 6, _timeLabel.top, _readLabel.width, kTimeLabelH);
    bottom = _timeLabel.bottom + kPaddingValue ;
    
    //点赞视图
    _likeBtn.frame = CGRectMake(kLeftMargin, bottom, kOperateBtnWidth, kOperateBtnWidth);
    //评论视图
    _commentBtn.frame = CGRectMake(_likeBtn.right+45, bottom, kOperateBtnWidth, _likeBtn.height);
    bottom = _likeBtn.bottom + kPaddingValue ;
    // 操作视图
    _menuView.frame = CGRectMake(k_screen_width-kOperateWidth-10, _likeBtn.top-(kOperateHeight-kOperateBtnWidth)/2, kOperateWidth, kOperateHeight);
    _menuView.show = NO;
    _menuView.isReport = moment.isLike;
    // 处理评论/赞
    _commentView.frame = CGRectZero;
    _bgImageView.frame = CGRectZero;
    _bgImageView.image = nil;
    [_commentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    // 处理赞
    CGFloat top = 0;
    CGFloat width = k_screen_width - kRightMargin - kLeftMargin;
    
    if (moment.showCommentView) {
        if ([moment.likeList count]) {
            MLLinkLabel * likeLabel = kMLLinkLabel(NO);
            likeLabel.delegate = self;
            likeLabel.attributedText = kMLLinkAttributedText(moment);
            CGSize attrStrSize = [likeLabel preferredSizeWithMaxWidth:kTextWidth];
            likeLabel.frame = CGRectMake(5, 8, attrStrSize.width, attrStrSize.height);
            [_commentView addSubview:likeLabel];
            // 分割线
            UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, likeLabel.bottom + 7, width, 0.5)];
            line.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
            [_commentView addSubview:line];
            // 更新
            top = attrStrSize.height + 15;
        }
        // 处理评论
        NSInteger count = [moment.commentList count];
        for (NSInteger i = 0; i < count; i ++) {
            __block CommentLabel * label = [[CommentLabel alloc] initWithFrame:CGRectMake(0, top, width, 0)];
            label.comment = [moment.commentList objectAtIndex:i];
            // 点击评论
            
            [label setDidClickText:^(CommentLabel *commentLab, Comment *comment) {
                // 当前moment相对tableView的frame
                CGRect rect = [[commentLab superview] convertRect:commentLab.frame toView:self.superview];
                [AppDelegate sharedInstance].convertRect = rect;
                
                if ([self.delegate respondsToSelector:@selector(didOperateMoment:selectComment:)]) {
                    [self.delegate didOperateMoment:self selectComment:comment];
                }
                [self resetMenuView];
            }];
            // 点击高亮
            [label setDidClickLinkText:^(CommentLabel *commentLab, MLLink *link, NSString *linkText) {
                if ([self.delegate respondsToSelector:@selector(didClickLink:linkText:)]) {
                    [self.delegate didClickLink:link linkText:linkText];
                }
                [self resetMenuView];
            }];
            [_commentView addSubview:label];
            // 更新
            top += label.height;
        }
    }
    
    // 更新UI
    if (top > 0) {
        _bgImageView.frame = CGRectMake(kLeftMargin, bottom, width, top + kArrowHeight);
        _bgImageView.image = [[UIImage imageNamed:@"comment_bg"] stretchableImageWithLeftCapWidth:40 topCapHeight:30];
        _commentView.frame = CGRectMake(kLeftMargin, bottom + kArrowHeight, width, top);
        rowHeight = _commentView.bottom + kBlank;
    } else {
        rowHeight = _likeBtn.bottom + kBlank;
    }
    // 这样做就是起到缓存行高的作用，省去重复计算!!!
    _moment.rowHeight = rowHeight;
}

// 图片渲染
- (void)loadPicture
{
    [_imageListView loadPicture];
}

#pragma mark - 点击事件
// 点击昵称/查看位置/查看全文|收起/删除动态
- (void)buttonClicked:(UIButton *)sender
{
    MMOperateType operateType = sender.tag;
    // 改变背景色
    sender.titleLabel.backgroundColor = kHLBgColor;
    GCD_AFTER(0.3, ^{  // 延迟执行
        sender.titleLabel.backgroundColor = [UIColor whiteColor];
        if (operateType == MMOperateTypeFull) {
            _moment.isFullText = !_moment.isFullText;
            [_moment update];
        }
        if ([self.delegate respondsToSelector:@selector(didOperateMoment:operateType:)]) {
            [self.delegate didOperateMoment:self operateType:operateType];
        }
    });
    [self resetMenuView];
}

- (void)doOperation:(MMOperateType)operateType {
    
    [self resetMenuView];
    
    if ([self.delegate respondsToSelector:@selector(didOperateMoment:operateType:)]) {
        [self.delegate didOperateMoment:self operateType:operateType];
    }
}

#pragma mark - MLLinkLabelDelegate
- (void)didClickLink:(MLLink *)link linkText:(NSString *)linkText linkLabel:(MLLinkLabel *)linkLabel
{
    [self resetMenuView];
    // 点击动态正文或者赞高亮
    if ([self.delegate respondsToSelector:@selector(didClickLink:linkText:)]) {
        [self.delegate didClickLink:link linkText:linkText];
    }
}

#pragma mark - UIResponder
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    MM_PostNotification(@"ResetMenuView", nil);
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(copyHandler)) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

#pragma mark - 长按拷贝
- (void)longPressHandler:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        [self becomeFirstResponder];
        
        _linkLabel.backgroundColor = kHLBgColor;
        CGRect frame = [[_linkLabel superview] convertRect:_linkLabel.frame toView:self];
        CGRect menuFrame = CGRectMake(frame.origin.x + frame.size.width/2.0, frame.origin.y, 0, 0);
        if (!_menuController) {
            UIMenuItem * copyItem = [[UIMenuItem alloc] initWithTitle:@"拷贝" action:@selector(copyHandler)];
            _menuController = [UIMenuController sharedMenuController];
            [_menuController setMenuItems:@[copyItem]];
        }
        [_menuController setTargetRect:menuFrame inView:self];
        [_menuController setMenuVisible:YES animated:YES];
    }
}

- (void)copyHandler
{
    UIPasteboard * pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString: _moment.text];
    [_menuController setMenuVisible:NO animated:YES];
}

- (void)resetLinkLabel
{
    _linkLabel.backgroundColor = [UIColor whiteColor];
}

- (void)resetMenuView
{
    _menuView.show = NO;
    [_menuController setMenuVisible:NO animated:YES];
}

#pragma mark -
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

#pragma mark - ------------------ 评论 ------------------
@implementation CommentLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _linkLabel = kMLLinkLabel(NO);
        _linkLabel.delegate = self;
        [self addSubview:_linkLabel];
    }
    return self;
}

#pragma mark - Setter
- (void)setComment:(Comment *)comment
{
    _comment = comment;
    _linkLabel.attributedText = kMLLinkAttributedText(comment);
    CGSize attrStrSize = [_linkLabel preferredSizeWithMaxWidth:kTextWidth];
    _linkLabel.frame = CGRectMake(5, 3, attrStrSize.width, attrStrSize.height);
    self.height = attrStrSize.height + 5;
}

#pragma mark - MLLinkLabelDelegate
- (void)didClickLink:(MLLink *)link linkText:(NSString *)linkText linkLabel:(MLLinkLabel *)linkLabel
{
    if (self.didClickLinkText) {
        self.didClickLinkText(self, link,linkText);
    }
}

#pragma mark - 点击
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.backgroundColor = kHLBgColor;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    GCD_AFTER(0.3, ^{  // 延迟执行
        self.backgroundColor = [UIColor clearColor];
        if (self.didClickText) {
            self.didClickText(self, _comment);
        }
    });
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.backgroundColor = [UIColor clearColor];
}
@end
