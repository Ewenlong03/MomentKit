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
    self.tabBar.layer.borderColor = MMRGBColor(215.0, 215.0, 215.0).CGColor;
    self.tabBar.tintColor = MMRGBColor(14.0, 178.0, 10.0);
    [self.tabBar setBackgroundImage:[Utility imageWithRenderColor:[UIColor whiteColor] renderSize:CGSizeMake(3, 3)]];

    // 初始化
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [MomentUtil initMomentData];
    });
    
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
}

#pragma mark -
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
