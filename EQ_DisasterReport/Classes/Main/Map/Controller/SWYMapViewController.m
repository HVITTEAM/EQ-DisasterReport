//
//  MapViewController.m
//  EQ_DisasterReport
//
//  Created by shi on 15/11/2.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "SWYMapViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "SWYButton.h"
#import "SWYMapTypeSelectView.h"
#import "SWYPhotoSetViewController.h"
#import "CollectInfoViewController.h"

@interface SWYMapViewController ()<MAMapViewDelegate,AMapSearchDelegate,MapTypeSelectViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;                 //地图View
@property (nonatomic, strong) MAUserLocation *currentLocation;    //用户当前位置

@property (nonatomic, strong) SWYButton *trafficSwitchBtn;       //切换交通图
@property (nonatomic, strong) SWYButton *mapTypeSwitchBtn;       //切换地图类型
@property (nonatomic, strong) SWYButton *mylocationBtn;          //切换用户跟随模式

@property (nonatomic, strong) UIButton *photoSetBtn;
@property (nonatomic, strong) UIButton *personCenterBtn;
@property (nonatomic, strong) UIButton *collectInfoBtn;

@end

@implementation SWYMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initMapView];
    [self initControlButton];
    [self initBottomBar];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}


#pragma mark 初始化方法、setter和getter方法
/**
 *  初始化地图
 */
-(void)initMapView{
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
    self.mapView.mapType = MAMapTypeStandard;
    self.mapView.zoomLevel = 14;
    self.mapView.compassOrigin = CGPointMake(self.mapView.compassOrigin.x, 30);
    self.mapView.showsScale = NO;

    self.mapView.showsUserLocation = YES;
    [self.mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES]; //地图跟着位置移动
}

/**
 *  初始化地图属性的控制按钮
 */
-(void)initControlButton
{
    //切换交通情况按钮
    self.trafficSwitchBtn = [self createBtnWithNormalImageName:@"locationIcon" selectedImageName:@"locationIcon"];
    self.trafficSwitchBtn.x = MTScreenW - 50;
    self.trafficSwitchBtn.y = 90;
    self.trafficSwitchBtn.tag = 20;
    
    //切换地图类型掉按钮
    self.mapTypeSwitchBtn = [self createBtnWithNormalImageName:@"locationIcon" selectedImageName:@"locationIcon"];
    self.mapTypeSwitchBtn.x = MTScreenW - 50;
    self.mapTypeSwitchBtn.y = 140;
    self.mapTypeSwitchBtn.tag = 21;
    
    //切换跟随模式按钮
    self.mylocationBtn = [self createBtnWithNormalImageName:@"locationIcon" selectedImageName:@"locationIcon"];
    self.mylocationBtn.x = 30;
    self.mylocationBtn.y = MTScreenH-140;
    self.mylocationBtn.tag = 22;
}

-(void)initBottomBar
{
    UIView *bottomBar = [[UIView alloc] initWithFrame:CGRectMake(30, MTScreenH-80, MTScreenW-60, 40)];
    bottomBar.layer.cornerRadius = 7;
    bottomBar.layer.masksToBounds = YES;
    [self.view addSubview:bottomBar];

    CGFloat btnWidth = bottomBar.width/3;
    CGFloat btnHeight = 40;
    
    self.photoSetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.photoSetBtn.frame = CGRectMake(0, 0, btnWidth, btnHeight);
    self.photoSetBtn.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    [self.photoSetBtn setTitle:@"照片墙" forState: UIControlStateNormal];
    [self.photoSetBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.photoSetBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.photoSetBtn addTarget:self action:@selector(bottomBarBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:self.photoSetBtn];
    
    self.collectInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.collectInfoBtn.frame = CGRectMake(btnWidth, 0, btnWidth, btnHeight);
    self.collectInfoBtn.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    [self.collectInfoBtn setTitle:@"数据采集" forState: UIControlStateNormal];
    [self.collectInfoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.collectInfoBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.collectInfoBtn addTarget:self action:@selector(bottomBarBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:self.collectInfoBtn];
    
    self.personCenterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.personCenterBtn.frame = CGRectMake(2*btnWidth, 0,btnWidth, btnHeight);
    self.personCenterBtn.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    [self.personCenterBtn setTitle:@"个人中心" forState: UIControlStateNormal];
    [self.personCenterBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.personCenterBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.personCenterBtn addTarget:self action:@selector(bottomBarBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:self.personCenterBtn];

    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(btnWidth, (btnHeight-10)/2, 1, btnHeight-30)];
    line1.backgroundColor = [UIColor lightGrayColor];
    [bottomBar addSubview:line1];

    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(2*btnWidth, (btnHeight-10)/2, 1, btnHeight-30)];
    line2.backgroundColor = [UIColor lightGrayColor];
    [bottomBar addSubview:line2];
}

#pragma mark 协议方法
#pragma mark MAMapViewDelegate方法
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        //取出当前位置的坐标
        //NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        self.currentLocation = userLocation;
    }
}

#pragma mark MapTypeSelectViewDelegate方法
-(void)mapTypeSelectView:(SWYMapTypeSelectView *)mapTypeView selectedType:(mapType)type
{
    switch (type) {
        case mapTypeStandard:
            self.mapView.mapType = MAMapTypeStandard;
            break;
        case mapTypeSatellite:
            self.mapView.mapType = MAMapTypeSatellite;
            break;
        case mapType3D:
            
            break;
    }
}

#pragma mark 事件方法
/**
 *  点击地图上的属性控制按钮后调用
 */
-(void)mapControlBtnClicked:(SWYButton *)sender
{
    if (sender.tag == 20) {
        //切换交通图
        sender.selected = !sender.isSelected;
        self.mapView.showTraffic = sender.isSelected;
    }else if (sender.tag == 22){
        //切换用户跟随模式
        switch (self.mapView.userTrackingMode) {
            case MAUserTrackingModeNone:
                [self.mapView setCenterCoordinate:self.currentLocation.coordinate animated:YES];
                [self.mapView setZoomLevel:13 animated:YES];
                [self.mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES];
                break;
            case MAUserTrackingModeFollow:
                [self.mapView setUserTrackingMode: MAUserTrackingModeFollowWithHeading animated:YES];
                break;
            case MAUserTrackingModeFollowWithHeading:
                [self.mapView setUserTrackingMode: MAUserTrackingModeNone animated:YES];
                break;
        }
    }else{
        //切换地图类型
        sender.selected = !sender.isSelected;
        if (sender.selected) {
            SWYMapTypeSelectView *selectView =  [[SWYMapTypeSelectView alloc] init];
            selectView.delegate = self;
            [selectView showMapTypeViewToView:self.view position:CGPointMake(sender.x, CGRectGetMaxY(sender.frame))];
        }
    }
}

-(void)bottomBarBtnClicked:(UIButton *)sender
{
    NSString *title = sender.titleLabel.text;
    if ([title isEqualToString:@"照片墙"]) {
      SWYPhotoSetViewController *photoSetVC = [[SWYPhotoSetViewController alloc] init];
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:photoSetVC];
        [self presentViewController:navVC animated:YES completion:nil];
    }else if ([title isEqualToString:@"数据采集"]){
        CollectInfoViewController *collectionInfo = [[CollectInfoViewController alloc] init];
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:collectionInfo];
        [self presentViewController:navVC animated:YES completion:nil];

    } else{
    
    }
}


#pragma mark 私有方法
/**
 *  创建地图属性控制按钮
 */
-(SWYButton *)createBtnWithNormalImageName:(NSString *)norImageName selectedImageName:(NSString *)seltImageName
{
    SWYButton *btn = [[SWYButton alloc] init];
    btn.bounds = CGRectMake(0, 0, 40, 40);
    
    UIImage *norImage = [UIImage imageNamed:norImageName];
    UIImage *seltImage = [UIImage imageNamed:seltImageName];
    [btn setImage:norImage forState:UIControlStateNormal];
    [btn setImage:seltImage forState:UIControlStateSelected];
    
    [self.view addSubview:btn];
    
    [btn addTarget:self action:@selector(mapControlBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor whiteColor];
    return btn;
}





@end