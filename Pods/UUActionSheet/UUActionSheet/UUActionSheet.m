//
//  UUActionSheet.m
//  UUActionSheet
//
//  Created by LEA on 2017/3/11.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "UUActionSheet.h"

// 屏幕高度
#define kDeviceHeight                   [UIScreen mainScreen].bounds.size.height
// 屏幕宽度
#define kDeviceWidth                    [UIScreen mainScreen].bounds.size.width
// iPhone X系列
#define k_iPhoneX                       (kDeviceHeight >= 812.0f)
// 边距
#define kMargin                         5
// 行高
#define kRowHeight                      50

@interface UUActionSheet () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIView * tableHeaderView;
@property (nonatomic, strong) NSMutableArray<NSString *> * titles;
@property (nonatomic, copy) NSString * cancelButtonTitle;
@property (nonatomic, copy) NSString  * destructiveButtonTitle;

@end

@implementation UUActionSheet

#pragma mark - 初始化
- (UUActionSheet *)initWithTitle:(NSString *)title delegate:(id<UUActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    self = [super init];
    if (self)
    {
        self.userInteractionEnabled = YES;
        self.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight);
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        
        if (delegate) {
            self.delegate = delegate;
        }
        _title = title;
        _cancelButtonTitle = cancelButtonTitle;
        _destructiveButtonTitle = destructiveButtonTitle;
        
        va_list ap;
        NSString *other = nil;
        if(otherButtonTitles)
        {
            [self.titles addObject:otherButtonTitles];
            va_start(ap, otherButtonTitles);
            while((other = va_arg(ap, NSString*))){
                [self.titles addObject:other];
            }
            va_end(ap);
        }
        if ([destructiveButtonTitle length]) {
            [self.titles insertObject:destructiveButtonTitle atIndex:0];
            self.destructiveButtonIndex = 0;
        }
        if ([cancelButtonTitle length]) {
            [self.titles addObject:cancelButtonTitle];
            self.cancelButtonIndex = [self.titles count]-1;
        }
        [self addSubview:self.tableView];
    }
    return self;
}

#pragma mark - 显示|隐藏
- (void)showInView:(UIView *)view
{
    [view addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        CGRect frame = self.tableView.frame;
        frame.origin.y = kDeviceHeight-self.tableView.frame.size.height;
        self.tableView.frame = frame;
    }];
}

- (void)hide
{
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        CGRect frame = self.tableView.frame;
        frame.origin.y = kDeviceHeight;
        self.tableView.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated
{
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:buttonIndex inSection:0];
    [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark - 点击隐藏
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.superview];
    if (CGRectContainsPoint(self.tableView.frame, currentPoint) == NO) {
        [self hide];
    }
}

#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (!_tableView)
    {
        CGFloat h = [self getHeaderHeight];
        if ([_cancelButtonTitle length]) {
            h += kMargin;
        }
        h += [self.titles count] * kRowHeight;
        if (k_iPhoneX) {
            h += 30;
        }
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kDeviceHeight, kDeviceWidth, h)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.alwaysBounceHorizontal = NO;
        _tableView.alwaysBounceVertical = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.userInteractionEnabled = YES;
        _tableView.scrollEnabled = NO;
        _tableView.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:237.0/255.0 blue:243.0/255.0 alpha:0.9];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = self.tableHeaderView;
    }
    return _tableView;
}

- (UIView *)tableHeaderView
{
    if (!_tableHeaderView)
    {
        CGFloat h = [self getHeaderHeight];
        _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, h)];
        _tableHeaderView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.8];
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, kDeviceWidth-40, h-40)];
        label.font = [UIFont systemFontOfSize:13.0];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.9];
        label.numberOfLines = 0;
        label.text = _title;
        label.backgroundColor = [UIColor clearColor];
        [_tableHeaderView addSubview:label];
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, _tableHeaderView.frame.size.height, kDeviceWidth, 0.5)];
        line.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
        [_tableHeaderView addSubview:line];
    }
    return _tableHeaderView;
}

- (NSMutableArray *)titles
{
    if (!_titles) {
        _titles = [[NSMutableArray alloc] init];
    }
    return _titles;
}

#pragma mark - 获取table头高度
- (CGFloat)getHeaderHeight
{
    CGFloat height = 0;
    if ([_title length])  {
        CGSize textSize = [_title boundingRectWithSize:CGSizeMake(kDeviceWidth - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0]} context:nil].size;
        height = textSize.height + 40;
    }
    return height;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titles count];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_cancelButtonTitle length] && indexPath.row == [self.titles count]-1) {
        return kRowHeight + kMargin;
    }
    return kRowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"Cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kRowHeight)];
        label.tag = 100;
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:18.0];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [self.titles objectAtIndex:indexPath.row];
        label.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.8];
        [cell.contentView addSubview:label];
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, kRowHeight - 0.5, kDeviceWidth, 0.5)];
        line.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
        line.tag = 200;
        [cell.contentView addSubview:line];
    }
    
    UILabel * label = [cell.contentView viewWithTag:100];
    UIView * line = [cell.contentView viewWithTag:200];
    line.hidden = NO;
    if ([_destructiveButtonTitle length] && indexPath.row == 0) {
        label.textColor = [UIColor redColor];
    }
    if ([_cancelButtonTitle length] && indexPath.row == [self.titles count]-2) {
        line.hidden = YES;
    }
    if ([_cancelButtonTitle length] && indexPath.row == [self.titles count]-1) {
        label.frame = CGRectMake(0, kMargin, kDeviceWidth, kRowHeight);
        line.frame = CGRectMake(0, kRowHeight + kMargin - 0.5, kDeviceWidth, 0.5);
    }
    
    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, label.frame.origin.y, kDeviceWidth, kRowHeight - 1)];
    bgView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:0.8];
    cell.selectedBackgroundView = bgView;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)]) {
        [self.delegate actionSheet:self clickedButtonAtIndex:indexPath.row];
    }
    [self hide];
}

@end
