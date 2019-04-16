//
//  MMUserDetailViewController.m
//  MomentKit
//
//  Created by LEA on 2019/4/15.
//  Copyright © 2019 LEA. All rights reserved.
//

#import "MMUserDetailViewController.h"
#import "MMImageListView.h"

@interface MMUserDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) MMTableView * tableView;
@property (nonatomic, strong) UIView * imageListView;

@end

@implementation MMUserDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"详细资料";
    self.view.backgroundColor = k_background_color;
    [self configUI];
}

- (void)configUI
{
    _tableView = [[MMTableView alloc] initWithFrame:CGRectMake(0, 0, k_screen_width, k_screen_height - k_top_height) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, k_screen_width, 200)];
    footerView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = footerView;
    
    UIButton * chatBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, k_screen_width - 40, 44)];
    chatBtn.layer.cornerRadius = 4.0;
    chatBtn.layer.masksToBounds = YES;
    chatBtn.userInteractionEnabled = NO;
    chatBtn.backgroundColor = MMRGBColor(14.0, 178.0, 10.0);
    [chatBtn setTitle:@"发消息" forState:UIControlStateNormal];
    [footerView addSubview:chatBtn];
    
    UIButton * videoBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, chatBtn.bottom + 15, k_screen_width - 40, 44)];
    videoBtn.layer.cornerRadius = 4.0;
    videoBtn.layer.masksToBounds = YES;
    videoBtn.layer.borderColor = MMRGBColor(215.0, 215.0, 215.0).CGColor;
    videoBtn.layer.borderWidth = 0.5;
    videoBtn.userInteractionEnabled = NO;
    videoBtn.backgroundColor = [UIColor whiteColor];
    [videoBtn setTitle:@"视频聊天" forState:UIControlStateNormal];
    [videoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [footerView addSubview:videoBtn];
    
    NSArray * images = @[@"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=239815455,722413567&fm=26&gp=0.jpg",
                         @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3541265676,1400518403&fm=26&gp=0.jpg",
                         @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=4048148084,3143739835&fm=26&gp=0.jpg"];
    
    _imageListView = [[UIView alloc] initWithFrame:CGRectMake(k_screen_width - 110, 0, 80, 80)];
    CGFloat width = _imageListView.width;
    NSInteger count = arc4random() % 3 + 1; // 1-3个
    for (NSInteger i = 1; i <= count; i ++) {
        MMImageView * imageView = [[MMImageView alloc] initWithFrame:CGRectMake(width - 60 * i, 15, 50, 50)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[images objectAtIndex:i - 1]] placeholderImage:nil];
        [_imageListView addSubview:imageView];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) {
        return 2;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        MMUserDetailCell * cell = [[MMUserDetailCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        cell.user = self.user;
        return cell;
    } else {
        UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor whiteColor];
        if (indexPath.section == 1) {
            cell.textLabel.text = @"设置备注和标签";
        } else if (indexPath.section == 2) {
            if (indexPath.row == 0) {
                cell.textLabel.text = @"朋友圈";
                [cell.contentView addSubview:_imageListView];
            } else {
                cell.textLabel.text = @"更多信息";
            }
        } else {
        }
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 80;
    } else if (indexPath.section == 1) {
        return 44;
    } else {
        return indexPath.row == 0 ? 80 : 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end


@interface MMUserDetailCell ()

@property (nonatomic, strong) MMImageView * avatarImageView; // 头像
@property (nonatomic, strong) UILabel * nameLabel; // 名称
@property (nonatomic, strong) UILabel * accountLabel; // 微信号
@property (nonatomic, strong) UILabel * regionLabel; // 地区

@end

@implementation MMUserDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        // 头像
        _avatarImageView = [[MMImageView alloc] initWithFrame:CGRectMake(15, 10, 60, 60)];
        _avatarImageView.layer.cornerRadius = 4.0;
        _avatarImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_avatarImageView];
        // 名字
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_avatarImageView.right + 10, _avatarImageView.top, k_screen_width - (_avatarImageView.right + 20), 23)];
        _nameLabel.font = [UIFont boldSystemFontOfSize:17.0];
        _nameLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_nameLabel];
        // 账号
        _accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.left, _nameLabel.bottom, _nameLabel.width, 20)];
        _accountLabel.font = [UIFont systemFontOfSize:12.0];
        _accountLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:_accountLabel];
        // 账号
        _regionLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.left, _accountLabel.bottom, _nameLabel.width, 18)];
        _regionLabel.font = [UIFont systemFontOfSize:12.0];
        _regionLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:_regionLabel];
    }
    return self;
}

- (void)setUser:(MUser *)user
{
    _nameLabel.text = user.name;
    _accountLabel.text = [NSString stringWithFormat:@"微信号：%@",user.account];
    _regionLabel.text = [NSString stringWithFormat:@"地区：%@",user.region];
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:user.portrait] placeholderImage:[UIImage imageNamed:@"moment_head"]];
}

@end
