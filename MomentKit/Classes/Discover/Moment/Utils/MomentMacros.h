//
//  MomentMacros.h
//  MomentKit
//
//  Created by LEA on 2019/3/27.
//  Copyright © 2019 LEA. All rights reserved.
//

// 弱引用
#define WS(wSelf)           __weak typeof(self) wSelf = self
// RGB颜色
#define MMRGBColor(r,g,b)   [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// 头像视图的宽、高
#define kAvatarWidth        40
// 名字视图高度
#define kNameLabelH         20
// 时间视图高度
#define kTimeLabelH         15

// 操作按钮的宽度
#define kOperateBtnWidth    30
// 操作视图的高度
#define kOperateHeight      38
// 操作视图的高度
#define kOperateWidth       200

// 顶部和底部的留白
#define kBlank              15
// 右侧留白
#define kRightMargin        15

// 内容视图宽度
#define kTextWidth          (k_screen_width - 60 - 25)
// 正文字体
#define kTextFont           [UIFont systemFontOfSize:17.0]
// 评论字体
#define kComTextFont        [UIFont systemFontOfSize:16.0]
// 评论高亮字体
#define kComHLTextFont      [UIFont boldSystemFontOfSize:16.0]
// 主色调高亮颜色（暗蓝色）
#define kHLTextColor        [UIColor colorWithRed:0.28 green:0.35 blue:0.54 alpha:1.0]
// 正文高亮颜色（蓝色）
#define kLinkTextColor      [UIColor colorWithRed:0.09 green:0.49 blue:0.99 alpha:1.0]
// 按住背景颜色
#define kHLBgColor          [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0]

// 图片间距
#define kImagePadding       5
// 图片宽度
#define kImageWidth         75
// 全文/收起按钮高度
#define kMoreLabHeight      20
// 视图之间的间距
#define kPaddingValue       8
// 评论赞视图气泡的尖尖高度
#define kArrowHeight        5
