//
//  MMLocationViewController.m
//  MomentKit
//
//  Created by LEA on 2019/2/25.
//  Copyright © 2019 LEA. All rights reserved.
//

#import "MMLocationViewController.h"
#import <MAMapKit/MAMapKit.h>

@interface MMLocationViewController ()<MAMapViewDelegate>

@end

@implementation MMLocationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"位置";
    self.view.backgroundColor = [UIColor whiteColor];
    [self configUI];
}

- (void)configUI
{
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(_location.latitude, _location.longitude);
    // 地图
    CGFloat bottomHeight = k_iphone_x ? 100 : 70;
    MAMapView * _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - bottomHeight)];
    _mapView.mapType = MAMapTypeStandard;
    _mapView.zoomLevel = 15;
    _mapView.delegate = self;
    _mapView.showsScale = YES;
    _mapView.showsCompass = NO;
    _mapView.showsUserLocation = NO;
    [_mapView setCenterCoordinate:coordinate];
    [self.view addSubview:_mapView];
    // 添加标注
    MAPointAnnotation * annotation = [[MAPointAnnotation alloc] init];
    annotation.coordinate = coordinate;
    [_mapView addAnnotation:annotation];
    [_mapView setCenterCoordinate:coordinate];
    // 底部视图
    UIView * bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height-k_top_height-bottomHeight, self.view.width, bottomHeight)];
    [self.view addSubview:bottomView];
    // 地标
    UILabel * _locationLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, bottomView.width - 30, 60)];
    _locationLab.backgroundColor = [UIColor clearColor];
    _locationLab.font = [UIFont systemFontOfSize:12.0];
    _locationLab.textColor = [UIColor grayColor];
    _locationLab.numberOfLines = 0;
    [bottomView addSubview:_locationLab];
    // 拼接地址
    NSString * location = [NSString stringWithFormat:@"%@\n%@",_location.landmark,_location.address];
    NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 5;
    NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc] initWithString:location];
    [attributedText addAttribute:NSParagraphStyleAttributeName
                           value:style
                           range:NSMakeRange(0,[location length])];
    [attributedText addAttribute:NSFontAttributeName
                           value:[UIFont systemFontOfSize:18.0]
                           range:NSMakeRange(0,[_location.landmark length])];
    [attributedText addAttribute:NSForegroundColorAttributeName
                           value:[UIColor blackColor]
                           range:NSMakeRange(0,[_location.landmark length])];
    _locationLab.attributedText = attributedText;
}

#pragma mark - MAMapViewDelegate
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        MAAnnotationView * annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
        annotationView.image = [UIImage imageNamed:@"moment_map_point"];
        annotationView.draggable = YES;
        return annotationView;
    }
    return nil;
}

@end
