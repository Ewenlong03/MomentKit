//
//  MineViewController.m
//  MomentKit
//
//  Created by LEA on 2019/2/2.
//  Copyright © 2019 LEA. All rights reserved.
//

#import "MineViewController.h"

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * titles;

@end

@implementation MineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = k_background_color;
    self.titles = [NSArray arrayWithObjects:@[@" "],@[@"钱包"],@[@"收藏",@"相册",@"卡包",@"表情"],@[@"设置"], nil];
    [self.view addSubview:self.tableView];
}

#pragma mark - lazy load
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 0.0;
        _tableView.estimatedSectionHeaderHeight = 0.0;
        _tableView.estimatedSectionFooterHeight = 0.0;
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.titles count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.titles objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"MineCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor whiteColor];
    }
    if (indexPath.section == 0) {
        cell.imageView.image = [UIImage imageNamed:@"mine_head"];
        cell.textLabel.text = @"LEA";
        cell.textLabel.font = [UIFont boldSystemFontOfSize:20.0];
        cell.detailTextLabel.text = @"wxid189349546";
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0];
        cell.detailTextLabel.textColor = [UIColor grayColor];
    } else {
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"mine_%ld_%ld",indexPath.section,indexPath.row]];
        cell.textLabel.text = [[self.titles objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:17.0];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 100;
    }
    return 44;
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

#pragma mark -
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
