//
//  MessageViewController.m
//  MomentKit
//
//  Created by LEA on 2019/2/2.
//  Copyright © 2019 LEA. All rights reserved.
//

#import "MessageViewController.h"
#import "SearchResultViewController.h"
#import "MMImageListView.h"

@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * messageList;

@end

@implementation MessageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = k_background_color;
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.messageList removeAllObjects];
    [self.messageList addObjectsFromArray:[Message findAll]];
    [self.tableView reloadData];
}

#pragma mark - lazy load
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, k_screen_width, k_screen_height-k_top_height - k_bar_height)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        SearchResultViewController * controller = [[SearchResultViewController alloc] init];
        UISearchController * searchController = [[UISearchController alloc] initWithSearchResultsController:controller];
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
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (NSMutableArray *)messageList
{
    if (!_messageList) {
        _messageList = [[NSMutableArray alloc] init];
    }
    return _messageList;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.messageList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"MessageCell";
    MessageCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    Message * message = [self.messageList objectAtIndex:indexPath.row];
    cell.message = message;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
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

#pragma mark - ------------------ 对话cell ------------------
@interface MessageCell ()

@property (nonatomic, strong) MMImageView * avatarImageV;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * messageLabel;
@property (nonatomic, strong) UILabel * timeLabel;

@end

@implementation MessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 头像
        _avatarImageV = [[MMImageView alloc] initWithFrame:CGRectMake(15, 10, 50, 50)];
        _avatarImageV.layer.cornerRadius = 4.0;
        _avatarImageV.layer.masksToBounds = YES;
        [self.contentView addSubview:_avatarImageV];
        // 昵称
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 13, k_screen_width - 150, 25)];
        _nameLabel.font = [UIFont systemFontOfSize:17.0];
        _nameLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.nameLabel];
        // 消息
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 37, k_screen_width-100, 20)];
        _messageLabel.font = [UIFont systemFontOfSize:14.0];
        _messageLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_messageLabel];
        // 时间
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(k_screen_width-110, 10, 100, 25)];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.font = [UIFont systemFontOfSize:12.0];
        _timeLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_timeLabel];
    }
    return self;
}

#pragma mark - setter
- (void)setMessage:(Message *)message
{
    [self.avatarImageV sd_setImageWithURL:[NSURL URLWithString:message.userPortrait] placeholderImage:nil];
    self.nameLabel.text = message.userName;
    self.messageLabel.text = message.content;
    self.timeLabel.text = [NSString stringWithFormat:@"%@",[Utility getMessageTime:message.time]];
}

@end 
