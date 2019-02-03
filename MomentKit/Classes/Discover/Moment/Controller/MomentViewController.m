//
//  MomentViewController.m
//  MomentKit
//
//  Created by LEA on 2017/12/12.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "MomentViewController.h"
#import "WKWebViewController.h"
#import "MomentCell.h"
#import "MomentUtil.h"

@interface MomentViewController ()<UITableViewDelegate,UITableViewDataSource,UUActionSheetDelegate,MomentCellDelegate>

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
    
    [self setUpData];
    [self setUpUI];
}

#pragma mark - 测试数据
- (void)setUpData
{
    self.momentList = [[NSMutableArray alloc] init];
    [self.momentList addObjectsFromArray:[MomentUtil getMomentList:0 pageNum:10]];
}

#pragma mark - UI
- (void)setUpUI
{
    // 封面
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -k_top_height, k_screen_width, 270)];
    imageView.backgroundColor = [UIColor lightGrayColor];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.contentScaleFactor = [[UIScreen mainScreen] scale];
    imageView.clipsToBounds = YES;
    imageView.userInteractionEnabled = YES;
    imageView.image = [UIImage imageNamed:@"moment_cover"];
    self.coverImageView = imageView;
    // 用户头像
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(k_screen_width-85, self.coverImageView.bottom-40, 75, 75)];
    imageView.backgroundColor = [UIColor lightGrayColor];
    imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    imageView.layer.borderWidth = 2;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.contentScaleFactor = [[UIScreen mainScreen] scale];
    imageView.clipsToBounds = YES;
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
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, k_screen_width, k_screen_height-k_top_height)];
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
    // 刷新
    MJRefreshBackNormalFooter * footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        Moment * moment = [self.momentList lastObject];
        NSArray * tempList = [MomentUtil getMomentList:moment.pk pageNum:10];
        if ([tempList count]) {
            [self.momentList addObjectsFromArray:tempList];
            [self.tableView reloadData];
            [tableView.mj_footer endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
    [footer.arrowView setImage:[UIImage imageNamed:@"refresh_pull"]];
    [footer setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
    [footer setTitle:@"松手加载更多" forState:MJRefreshStatePulling];
    [footer setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"已加载全部" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.font = [UIFont systemFontOfSize:14];
    self.tableView.mj_footer = footer;
}

#pragma mark - 发布动态
- (void)addMoment
{
    NSLog(@"新增");
}

#pragma mark - MomentCellDelegate
- (void)didOperateMoment:(MomentCell *)cell operateType:(MMOperateType)operateType;
{
    switch (operateType)
    {
        case MMOperateTypeProfile: // 点击用户头像
        {
            NSLog(@"击用户头像");
             break;
        }
        case MMOperateTypeDelete: // 删除
        {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"确定删除吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                // 取消
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                // db移除
                [cell.moment deleteObject];
                // 移除UI
                [self.momentList removeObject:cell.moment];
                [self.tableView reloadData];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
            break;
        }
        case MMOperateTypeLike: // 点赞
        {
            // data
            Moment * moment = cell.moment;
            NSMutableArray * praiseList = [NSMutableArray arrayWithArray:[MomentUtil getPraiseList:moment.praiseNameList]];
            if (moment.isPraise) {
                moment.isPraise = 0;
                [praiseList removeObject:@"LEA"];
            } else {
                moment.isPraise = 1;
                [praiseList addObject:@"LEA"];
            }
            moment.praiseNameList = [MomentUtil getPraiseString:praiseList];
            [moment update];
            // UI
            [self.momentList replaceObjectAtIndex:cell.tag withObject:moment];
            [self.tableView reloadData];
            break;
        }
        case MMOperateTypeComment: // 评论
        {
            NSLog(@"评论");
            break;
        }
        case MMOperateTypeFull: // 全文/收起
        {
            NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
        }
        default:
            break;
    }
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
    switch (link.linkType)
    {
        case MLLinkTypeURL: // 链接
        {
            WKWebViewController * controller = [[WKWebViewController alloc] init];
            controller.url = linkText;
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        case MLLinkTypePhoneNumber: // 电话
        {
            UUActionSheet * sheet = [[UUActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"%@可能是一个电话号码，你可以",link.linkValue]
                                                                delegate:self
                                                       cancelButtonTitle:@"取消"
                                                  destructiveButtonTitle:@"呼叫"
                                                       otherButtonTitles:@"复制号码",nil];
            [sheet showInView:self.view.window];
            break;
        }
        case MLLinkTypeEmail: // 邮箱
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto://%@",linkText]]];
            break;
        }
        case MLLinkTypeUserHandle: // @
        {
            break;
        }
        default:
            break;
    }
}

#pragma mark - UUActionSheetDelegate
- (void)actionSheet:(UUActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString * title = actionSheet.title;
    NSString * subString = [title substringWithRange:NSMakeRange(0, [title length] - 13)];
    if (buttonIndex == 0) { // 拨打电话
        UIWebView * webView = [[UIWebView alloc] init];
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",subString]];
        [webView loadRequest:[NSURLRequest requestWithURL:url]];
        [self.view addSubview:webView];
    } else if (buttonIndex == 1) { // 复制
        [[UIPasteboard generalPasteboard] setPersistent:YES];
        [[UIPasteboard generalPasteboard] setValue:subString forPasteboardType:[UIPasteboardTypeListString objectAtIndex:0]];
    } else { // 取消
        
    }
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
    static NSString * identifier = @"MomentCell";
    MomentCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
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
    Moment * moment = [self.momentList objectAtIndex:indexPath.row];
    return moment.rowHeight;
}

#pragma mark - UITableViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSIndexPath * indexPath =  [self.tableView indexPathForRowAtPoint:CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y)];
    MomentCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.menuView.show = NO;
}

#pragma mark -
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
