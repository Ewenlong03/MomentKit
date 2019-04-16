//
//  ContactsViewController.m
//  MomentKit
//
//  Created by LEA on 2019/2/2.
//  Copyright © 2019 LEA. All rights reserved.
//

#import "ContactsViewController.h"
#import "SearchResultViewController.h"
#import "MMUserDetailViewController.h"
#import "MMImageListView.h"
#import "NSString+Letter.h"
#import "Utility.h"
#import "MUser.h"

@interface ContactsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) MMTableView * tableView;
@property (nonatomic, strong) UILabel * contactNumLab;
@property (nonatomic, strong) NSMutableArray * indexes;
@property (nonatomic, strong) NSMutableArray * sectionTitles;
@property (nonatomic, strong) NSMutableArray * userList;

@end

@implementation ContactsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = k_background_color;
    [self configData];
    [self.view addSubview:self.tableView];
}

#pragma mark - load data
- (void)configData
{
    // 联系人数据 ↓↓
    NSArray * users = [MUser findAll];
    // 分组和排序 ↓↓
    UILocalizedIndexedCollation * indexedCollation = [UILocalizedIndexedCollation currentCollation];
    self.sectionTitles = [[NSMutableArray alloc] initWithArray:[indexedCollation sectionTitles]];
    NSInteger sectionNum = [self.sectionTitles count];
    NSMutableArray * newSectionsArray = [[NSMutableArray alloc] initWithCapacity:sectionNum];
    // 空数组
    for (int i = 0; i < sectionNum; i ++) {
        NSMutableArray * array = [[NSMutableArray alloc] init];
        [newSectionsArray addObject:array];
    }
    // 插入数据
    for (MUser * user in users)
    {
        if (user.name.length <= 0) {
            NSMutableArray * sectionTitles = newSectionsArray.lastObject;
            [sectionTitles addObject:user];
        } else {
            NSInteger sectionIndex = [indexedCollation sectionForObject:user.name collationStringSelector:@selector(firstLetter)];
            NSMutableArray * sectionTitles = newSectionsArray[sectionIndex];
            [sectionTitles addObject:user];
        }
    }
    // 移除空数组
    for (int i = 0; i < newSectionsArray.count; i ++)
    {
        NSMutableArray * sectionTitles = newSectionsArray[i];
        if (sectionTitles.count == 0) {
            [newSectionsArray removeObjectAtIndex:i];
            if(sectionNum > i) {
                [self.sectionTitles removeObjectAtIndex:i];
            }
            i --;
        }
    }
    // 第一组
    NSArray * titles = [NSArray arrayWithObjects:@"新朋友",@"群聊",@"标签",@"公众号", nil];
    [newSectionsArray insertObject:titles atIndex:0];
    // 二维数组
    self.userList = newSectionsArray;
    self.indexes = [[NSMutableArray alloc] init];
    [self.indexes addObject:UITableViewIndexSearch];
    [self.indexes addObjectsFromArray:self.sectionTitles];
    // 显示联系人数目
    self.contactNumLab.text = [NSString stringWithFormat:@"%ld位联系人",[users count]];
    [self.tableView reloadData];
}

#pragma mark - lazy load
- (MMTableView *)tableView
{
    if (!_tableView) {
        _tableView = [[MMTableView alloc] initWithFrame:CGRectMake(0, 0, k_screen_width, k_screen_height-k_top_height - k_bar_height)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.sectionIndexColor = [UIColor blackColor];
        _tableView.tableFooterView = self.contactNumLab;
        
        SearchResultViewController * controller = [[SearchResultViewController alloc] init];
        UISearchController * searchController = [[UISearchController alloc]initWithSearchResultsController:controller];
        searchController.searchBar.userInteractionEnabled = NO;
        searchController.searchBar.enablesReturnKeyAutomatically = YES;
        searchController.searchBar.searchTextPositionAdjustment = UIOffsetMake(5, 0);
        [searchController.searchBar setPositionAdjustment:UIOffsetMake((k_screen_width-60)/2.0, 0) forSearchBarIcon:UISearchBarIconSearch];
        [searchController.searchBar setBackgroundImage:[Utility imageWithRenderColor:k_background_color renderSize:CGSizeMake(1, 1)] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        [searchController.searchBar sizeToFit];
        // 输入框
        UITextField * searchField = [searchController.searchBar valueForKey:@"_searchField"];
        searchField.borderStyle = UITextBorderStyleNone;
        searchField.textAlignment = NSTextAlignmentCenter;
        searchField.textColor = [UIColor grayColor];
        searchField.font = [UIFont systemFontOfSize:16];
        searchField.placeholder = @"搜索";
        searchField.layer.masksToBounds = YES;
        searchField.layer.cornerRadius = 5;
        searchField.backgroundColor = [UIColor whiteColor];
        _tableView.tableHeaderView = searchController.searchBar;
    }
    return _tableView;
}

- (UILabel *)contactNumLab
{
    if (!_contactNumLab) {
        _contactNumLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, k_screen_width, 50)];
        _contactNumLab.textAlignment = NSTextAlignmentCenter;
        _contactNumLab.font = [UIFont systemFontOfSize:15.0];
        _contactNumLab.textColor = MMRGBColor(170.f, 170.f, 170.f);
        _contactNumLab.backgroundColor = [UIColor clearColor];
    }
    return _contactNumLab;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.userList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.userList objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"ContactsCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor = [UIColor whiteColor];
        cell.separatorInset = UIEdgeInsetsMake(0, 65, 0, 0);
        // 头像
        MMImageView * imageView = [[MMImageView alloc] initWithFrame:CGRectMake(15, 5, 40, 40)];
        imageView.tag = 101;
        imageView.layer.cornerRadius = 4.0;
        imageView.layer.masksToBounds = YES;
        [cell.contentView addSubview:imageView];
        // 昵称
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(65, 0, k_screen_width-100, 50)];
        label.tag = 102;
        label.font = [UIFont systemFontOfSize:17.0];
        [cell.contentView addSubview:label];
    }
    MMImageView * imageView = [cell.contentView viewWithTag:101];
    UILabel * label = [cell.contentView viewWithTag:102];
    // 赋值
    if (indexPath.section == 0) {
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"message_%ld",indexPath.row]];
        label.text = [[self.userList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    } else {
        MUser * user = [[self.userList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        label.text = user.name;
        [imageView sd_setImageWithURL:[NSURL URLWithString:user.portrait] placeholderImage:[UIImage imageNamed:@"mine_head"]];
    }
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.indexes;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSIndexPath * selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:index];
    if(index == 0) { // 搜索框
        [tableView setContentOffset:CGPointMake(0,0) animated:NO];
        return -1;
    } else  {
        [tableView scrollToRowAtIndexPath:selectIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    return index;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section ? 20 : 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, k_screen_width, 20)];
    label.backgroundColor = k_background_color;
    label.text = [NSString stringWithFormat:@"    %@",self.sectionTitles[section-1]];
    label.font = [UIFont systemFontOfSize:14.0];
    label.textColor = [UIColor grayColor];
    return label;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        return;
    }
    MUser * user = [[self.userList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    MMUserDetailViewController * controller = [[MMUserDetailViewController alloc] init];
    controller.user = user;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark -
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end



