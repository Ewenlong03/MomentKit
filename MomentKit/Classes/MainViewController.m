//
//  MainViewController.m
//  MomentKit
//
//  Created by LEA on 2017/12/12.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "MainViewController.h"
#import "DiscoverViewController.h"
#import "MineViewController.h"
#import "MessageViewController.h"
#import "ContactsViewController.h"
#import "MomentUtil.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tabBar.layer.borderWidth = 0.5;
    self.tabBar.layer.borderColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0].CGColor;
    self.tabBar.tintColor = [UIColor colorWithRed:14.0/255.0 green:178.0/255.0 blue:10.0/255.0 alpha:1.0];
    [self.tabBar setBackgroundImage:[Utility imageWithRenderColor:[UIColor whiteColor] renderSize:CGSizeMake(3, 3)]];

    // 控制器
    MessageViewController * messageVC = [[MessageViewController alloc] init];
    ContactsViewController * contactsVC = [[ContactsViewController alloc] init];
    DiscoverViewController * discoverVC = [[DiscoverViewController alloc] init];
    MineViewController * mineVC = [[MineViewController alloc] init];
    NSArray * controllers = @[messageVC,contactsVC,discoverVC,mineVC];
    // tabbar
    NSArray * titles = @[@"微信",@"通讯录",@"发现",@"我"];
    NSMutableArray * viewControllers = [[NSMutableArray alloc] init];
    for (int i = 0; i < 4; i ++)
    {
        // 图片
        UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"tabbar_%d",i]];
        UIImage * selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"tabbar_hl_%d",i]];
        // 项
        UITabBarItem * item = [[UITabBarItem alloc] initWithTitle:titles[i] image:image selectedImage:selectedImage];
        [item setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:10.0]} forState:UIControlStateNormal];
        // 控制器
        UIViewController * controller = controllers[i];
        controller.title = [titles objectAtIndex:i];
        controller.tabBarItem = item;
        // 导航
        UINavigationController * navigation = [[UINavigationController alloc] initWithRootViewController:controller];
        navigation.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:19.0]};
        [navigation.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigaitonbar"] forBarMetrics:UIBarMetricsDefault];
        navigation.navigationBar.tintColor = [UIColor whiteColor];
        navigation.navigationBar.barStyle = UIBarStyleBlackOpaque;
        navigation.navigationBar.translucent = NO;
        [viewControllers addObject:navigation];
    }
    self.viewControllers = viewControllers;
    // 初始化
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self initDBModel];
    });
}

// 初始化db
- (void)initDBModel
{
    NSInteger count = [[User findAll] count];
    if (count > 0) {
        return;
    }
    // 名字
    NSArray * names = @[@"刘瑾",@"陈哲轩",@"安鑫",@"欧阳沁",@"韩艺",@"宋铭",@"童璐",@"祝子琪",@"林霜",@"赵星桐"];
    // 头像网络图片
    
    NSArray * images = @[@"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=2633478757,1609564776&fm=26&gp=0.jpg",
                         @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=61465521,1969244909&fm=26&gp=0.jpg",
                         @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=4000299605,1917436436&fm=27&gp=0.jpg",
                         @"http://img1.imgtn.bdimg.com/it/u=3409408983,232289470&fm=26&gp=0.jpg",
                         @"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=703227009,4280079683&fm=26&gp=0.jpg",
                         @"http://img4.imgtn.bdimg.com/it/u=1954008455,2270367419&fm=26&gp=0.jpg",
                         @"http://img3.imgtn.bdimg.com/it/u=2258371767,2618967988&fm=26&gp=0.jpg",
                         @"http://img0.imgtn.bdimg.com/it/u=1408188170,2359624570&fm=26&gp=0.jpg",
                         @"http://b-ssl.duitang.com/uploads/item/201711/06/20171106232540_4YdTr.jpeg",
                         @"http://img4.imgtn.bdimg.com/it/u=1841528288,1473396218&fm=26&gp=0.jpg"];
    // 内容
    NSArray * contents = @[@"鹟是一种身体小，嘴稍扁平，基部有许多刚毛，脚短小的益鸟。",
                           @"画家把她描绘成一个临江而立的忧伤女子。🔥🔥",
                           @"不要以为这是👉白浅上神👈，这只是一只可爱的文须雀。",
                           @"这种鸟上体棕黄色，翅黑色具白色翅斑，外侧尾羽白色。",
                           @"这是一只胖胖的剪嘴鸥，作者以黑白红三种分明的颜色描绘她，其实很符合剪嘴鸥的形象。",
                           @"这是网上很火的一个孤影夕阳红的故事，一只白鹭立与夕阳下的湖泊，红色的夕阳把一切都染上了一层绯红。",
                           @"“不要脸”画家呼葱觅蒜再出新作，以飞鸟为材画出仙侠新境界。",
                           @"蜀绣又名“川绣”，是在丝绸或其他织物上采用蚕丝线绣出花纹图案的中国传统工艺",
                           @"昨夜雨疏风骤，浓睡不消残酒。试问卷帘人，却道海棠依旧。知否，知否？应是绿肥红瘦。",
                           @"安利我喜欢的插画师：晓艺大佬。"];
    
    // 用户 ↓↓
    for (int i = 0; i < [names count]; i ++) {
        User * user = [[User alloc] init];
        user.name = [names objectAtIndex:i];
        user.portrait = [images objectAtIndex:i];
        [user save];
        
        Message * message = [[Message alloc] init];
        message.time = 1549162615;
        message.userName = [names objectAtIndex:i];
        message.userPortrait = [images objectAtIndex:i];
        message.content = [contents objectAtIndex:i];
        [message save];
    }
    
    // 动态  ↓↓
    for (int i = 0; i < 35; i ++)
    {
        NSInteger index = arc4random() % 9;
        // 动态
        Moment * moment = [[Moment alloc] init];
        moment.praiseNameList = [MomentUtil getPraiseString:[names subarrayWithRange:NSMakeRange(0, index + 1)]];
        moment.userName = [names objectAtIndex:index];
        moment.userPortrait = [images objectAtIndex:index];
        moment.time = 1549162615;
        moment.singleWidth = 640;
        moment.singleHeight = 506;
        moment.location = @"杭州 · 雷峰塔景区";
        moment.landmark = @"雷峰塔景区";
        moment.address = @"杭州市西湖区南山路15号";
        moment.latitude = 30.231250;
        moment.longitude = 120.148550;
        moment.isPraise = NO;
        if (i == 0) {
            moment.fileCount = 4;
            moment.text = @"“不要脸”画家呼葱觅蒜再出新作，以飞鸟为材画出仙侠新境界。详见链接：https://baijiahao.baidu.com/s?id=1611814670460612719&wfr=spider&for=pc";
        } else if (i % 3 == 0) {
            moment.fileCount = arc4random() % 10;
            moment.text = @"蜀绣又名“川绣”，是在丝绸或其他织物上采用蚕丝线绣出花纹图案的中国传统工艺，主要指以四川成都为中心的川西平原一带的刺绣。蜀绣最早见于西汉的记载，当时的工艺已相当成熟，同时传承了图案配色鲜艳、常用红绿颜色的特点。蜀绣又名“川绣”，是在丝绸或其他织物上采用蚕丝线绣出花纹图案的中国传统工艺，主要指以四川成都为中心的川西平原一带的刺绣。蜀绣最早见于西汉的记载，当时的工艺已相当成熟，同时传承了图案配色鲜艳、常用红绿颜色的特点。";
        } else if (i % 5 == 0) {
            moment.fileCount = 0;
            moment.text = @"昨夜雨疏风骤，浓睡不消残酒。试问卷帘人，却道海棠依旧。知否，知否？应是绿肥红瘦。";
        }else if (i % 7 == 0) {
            moment.fileCount = 1;
            moment.text = @"安利我喜欢的插画师：晓艺大佬。详见链接：http://www.360doc.com/content/17/0702/09/41961047_668129920.shtml";
        } else if (i % 8 == 0) {
            moment.fileCount = 6;
            moment.text = @"这是手机号☎️：18367980021  表情🐷：💪👍👊👎🍟🍎🍸🍞🍣👉👈🍟🍞🍊☎️📱👍👍😝😭🍓💊🍉🔥🐎👠🐷  邮箱📱：chellyLau@126.com";
        } else {
            moment.fileCount = arc4random() % 10;
            moment.text = @"美冠鹦鹉又被称为粉红凤头鹦鹉，因为它的头冠特别美丽又有粉红色的羽毛，被誉为爱情鸟的鹦鹉，赋予粉红色的生命，也是暖暖的少女色，恋爱感爆棚。";
        }
        [moment save];
        
        // 评论
        int num = arc4random() % 5 + 1;
        for (int j = 0; j < num; j ++)
        {
            Comment * comment = [[Comment alloc] init];
            comment.userName = @"童璐";
            comment.text = [contents objectAtIndex:j];
            comment.isReply = (j % 2 == 0) ? NO : YES;
            comment.time = 1487649503;
            comment.momentPk = moment.pk;
            [comment save];
        }
    }
}

#pragma mark -
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
