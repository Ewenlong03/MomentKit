//
//  MomentViewController.m
//  MomentKit
//
//  Created by LEA on 2017/12/12.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "MomentViewController.h"
#import "MomentCell.h"
#import "Moment.h"
#import "Comment.h"

@interface MomentViewController ()<UITableViewDelegate,UITableViewDataSource,MomentCellDelegate>

@property (nonatomic, strong) NSMutableArray *momentList;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIImageView *headImageView;

@end

@implementation MomentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"好友动态";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"moment_camera"] style:UIBarButtonItemStylePlain target:self action:@selector(addMoment)];
    
    [self initTestInfo];
    [self setUpUI];
}

#pragma mark - 测试数据
- (void)initTestInfo
{
    self.momentList = [[NSMutableArray alloc] init];
    NSMutableArray *commentList = nil;
    for (int i = 0;  i < 10; i ++)  {
        // 评论
        commentList = [[NSMutableArray alloc] init];
        int num = arc4random()%5 + 1;
        for (int j = 0; j < num; j ++) {
            Comment *comment = [[Comment alloc] init];
            comment.userName = @"胡一菲";
            comment.text = @"天界大乱，九州屠戮，当初被推下地狱的她已经浴火归来.";
            comment.time = 1487649503;
            comment.pk = j;
            [commentList addObject:comment];
        }
        
        Moment *moment = [[Moment alloc] init];
        moment.commentList = commentList;
        moment.praiseNameList = @"胡一菲，唐悠悠，陈美嘉，吕小布，曾小贤，张伟，关谷神奇";
        moment.userName = @"Jeanne";
        moment.time = 1487649403;
        moment.singleWidth = 500;
        moment.singleHeight = 315;
        moment.location = @"北京 · 西单";
        moment.isPraise = NO;
        if (i == 5) {
            moment.commentList = nil;
            moment.praiseNameList = nil;
            moment.text = @"蜀绣又名“川绣”，是在丝绸或其他织物上采用蚕丝线绣出花纹图案的中国传统工艺，18107891687主要指以四川成都为中心的川西平原一带的刺绣。😁蜀绣最早见于西汉的记载，当时的工艺已相当成熟，同时传承了图案配色鲜艳、常用红绿颜色的特点。😁蜀绣又名“川绣”，是在丝绸或其他织物上采用蚕丝线绣出花纹图案的中国传统工艺，https://www.baidu.com，主要指以四川成都为中心的川西平原一带的刺绣。蜀绣最早见于西汉的记载，当时的工艺已相当成熟，同时传承了图案配色鲜艳、常用红绿颜色的特点。";
            moment.fileCount = 1;
        } else if (i == 1) {
            moment.text = @"天界大乱，九州屠戮，当初被推下地狱的她已经浴火归来 😭😭剑指仙界'你们杀了他，我便覆了你的天，毁了你的界，永世不得超生又如何！'👍👍 ";
            moment.fileCount = arc4random()%10;
            moment.praiseNameList = nil;
        } else if (i == 2) {
            moment.fileCount = 9;
        } else {
            moment.text = @"天界大乱，九州屠戮，当初被推下地狱cheerylau@126.com的她已经浴火归来，😭😭剑指仙界'你们杀了他，我便覆了你的天，毁了你的界，永世不得超生又如何！'👍👍";
            moment.fileCount = arc4random()%10;
        }
        [self.momentList addObject:moment];
    }
}

#pragma mark - UI
- (void)setUpUI
{
    // 封面
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -k_top_height, k_screen_width, 270)];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.contentScaleFactor = [[UIScreen mainScreen] scale];
    imageView.clipsToBounds = YES;
    imageView.userInteractionEnabled = YES;
    imageView.image = [UIImage imageNamed:@"moment_cover"];
    self.coverImageView = imageView;
    // 用户头像
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(k_screen_width-85, self.coverImageView.bottom-40, 75, 75)];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    imageView.layer.borderWidth = 2;
    imageView.userInteractionEnabled = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.image = [UIImage imageNamed:@"moment_head"];
    self.headImageView = imageView;
    // 表头
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, k_screen_width, 270)];
    view.backgroundColor = [UIColor clearColor];
    view.userInteractionEnabled = YES;
    [view addSubview:self.coverImageView];
    [view addSubview:self.headImageView];
    self.tableHeaderView = view;
    // 表格
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, k_screen_width, k_screen_height-k_top_height)];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.separatorColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    tableView.separatorInset = UIEdgeInsetsZero;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.estimatedRowHeight = 0;
    tableView.tableFooterView = [UIView new];
    tableView.tableHeaderView = self.tableHeaderView;
    self.tableView = tableView;
    [self.view addSubview:self.tableView];
}

#pragma mark - 发布动态
- (void)addMoment
{
    NSLog(@"新增");
}

#pragma mark - MomentCellDelegate
// 点击用户头像
- (void)didClickProfile:(MomentCell *)cell
{
    NSLog(@"击用户头像");
}

// 点赞
- (void)didLikeMoment:(MomentCell *)cell
{
    NSLog(@"点赞");
    Moment *moment = cell.moment;
    NSMutableArray *tempArray = [NSMutableArray array];
    if (moment.praiseNameList.length) {
        tempArray = [NSMutableArray arrayWithArray:[moment.praiseNameList componentsSeparatedByString:@"，"]];
    }
    if (moment.isPraise) {
        moment.isPraise = 0;
        [tempArray removeObject:@"金大侠"];
    } else {
        moment.isPraise = 1;
        [tempArray addObject:@"金大侠"];
    }
    NSMutableString *tempString = [NSMutableString string];
    NSInteger count = [tempArray count];
    for (NSInteger i = 0; i < count; i ++) {
        if (i == 0) {
            [tempString appendString:[tempArray objectAtIndex:i]];
        } else {
            [tempString appendString:[NSString stringWithFormat:@"，%@",[tempArray objectAtIndex:i]]];
        }
    }
    moment.praiseNameList = tempString;
    [self.momentList replaceObjectAtIndex:cell.tag withObject:moment];
    [self.tableView reloadData];
}

// 评论
- (void)didAddComment:(MomentCell *)cell
{
    NSLog(@"评论");
}

// 查看全文/收起
- (void)didSelectFullText:(MomentCell *)cell
{
    NSLog(@"全文/收起");
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

// 删除
- (void)didDeleteMoment:(MomentCell *)cell
{
    NSLog(@"删除");
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定删除吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 取消
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        // 删除
        [self.momentList removeObject:cell.moment];
        [self.tableView reloadData];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

// 选择评论
- (void)didSelectComment:(Comment *)comment
{
    NSLog(@"点击评论");
}

// 点击高亮文字
- (void)didClickLink:(MLLink *)link linkText:(NSString *)linkText
{
    NSLog(@"点击高亮文字：%@",linkText);
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.momentList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MomentCell";
    MomentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MomentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    cell.moment = [self.momentList objectAtIndex:indexPath.row];
    cell.delegate = self;
    cell.tag = indexPath.row;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 使用缓存行高，避免计算多次
    Moment *moment = [self.momentList objectAtIndex:indexPath.row];
    return moment.rowHeight;
}

#pragma mark - UITableViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSIndexPath *indexPath =  [self.tableView indexPathForRowAtPoint:CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y)];
    MomentCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.menuView.show = NO;
}

#pragma mark -
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
