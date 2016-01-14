//
//  MapViewController.m
//  EQ_DisasterReport
//
//  Created by shi on 15/11/2.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "SWYMapViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import "SWYButton.h"
#import "SWYMapTypeSelectView.h"
#import "SWYPhotoSetViewController.h"
#import "CollectInfoViewController.h"
#import "PersonCenterViewController.h"
#import "SpotInfoViewController.h"
#import "AppDelegate.h"

typedef NS_ENUM(NSInteger, BottomButtonType) {
    BottomButtonTypeCollectInfo = 0,
    BottomButtonTypePhotoSet,
    BottomButtonTypePersonCenter,
};

typedef NS_ENUM(NSInteger, ControlButtonType) {
    ControlButtonTypeTraffic = 20,
    ControlButtonTypeMapType,
    ControlButtonTypeMylocation,
};

@interface SWYMapViewController ()<MAMapViewDelegate,AMapSearchDelegate,MapTypeSelectViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;                 //地图View
@property (nonatomic, strong) MAUserLocation *currentLocation;    //用户当前位置

@property (nonatomic, strong) SWYButton *trafficSwitchBtn;       //切换交通图
@property (nonatomic, strong) SWYButton *mapTypeSwitchBtn;       //切换地图类型
@property (nonatomic, strong) SWYButton *mylocationBtn;          //切换用户跟随模式

@property (nonatomic, strong) UIButton *photoSetBtn;            //照片墙按钮
@property (nonatomic, strong) UIButton *personCenterBtn;        //个人中心按钮
@property (nonatomic, strong) UIButton *collectInfoBtn;         //采集信息按钮

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
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
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
    self.mapView.zoomLevel = 19.0f;
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(30.27320, 120.15515)];
    self.mapView.compassOrigin = CGPointMake(self.mapView.compassOrigin.x - 8, 30);
    self.mapView.logoCenter = CGPointMake(CGRectGetWidth(self.view.bounds)-55, MTScreenH - 70);
    self.mapView.showsScale = NO;
    self.mapView.rotateCameraEnabled= NO;
    self.mapView.rotateEnabled = NO;

    self.mapView.showsUserLocation = YES;
    [self.mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES]; //地图跟着位置移动
}

/**
 *  初始化地图属性的控制按钮
 */
-(void)initControlButton
{
    //切换交通情况按钮
    self.trafficSwitchBtn = [self createBtnWithNormalImageName:@"trafficSwitch_icon_normal" selectedImageName:@"trafficSwitch_icon_selected"];
    self.trafficSwitchBtn.x = MTScreenW - 50;
    self.trafficSwitchBtn.y = 90;
    self.trafficSwitchBtn.tag = ControlButtonTypeTraffic;
    
    //切换地图类型掉按钮
    self.mapTypeSwitchBtn = [self createBtnWithNormalImageName:@"mapTypeSwitch_icon" selectedImageName:@"mapTypeSwitch_icon"];
    self.mapTypeSwitchBtn.x = MTScreenW - 50;
    self.mapTypeSwitchBtn.y = 140;
    self.mapTypeSwitchBtn.tag = ControlButtonTypeMapType;
    
    //切换跟随模式按钮
    self.mylocationBtn = [self createBtnWithNormalImageName:@"locationIconNone" selectedImageName:@"locationIconNone"];
    self.mylocationBtn.x = 10;
    self.mylocationBtn.y = MTScreenH-120;
    self.mylocationBtn.tag = ControlButtonTypeMylocation;
}

/**
 *  初始化底部工具条
 */
-(void)initBottomBar
{
    UIView *bottomBar = [[UIView alloc] initWithFrame:CGRectMake(10, MTScreenH-50, MTScreenW-20, 40)];
    bottomBar.layer.cornerRadius = 10;
    bottomBar.backgroundColor = [UIColor whiteColor];
    bottomBar.layer.shadowRadius = 4;
    bottomBar.layer.shadowOpacity = 0.4;
    bottomBar.layer.shadowOffset = CGSizeMake(0, 2);
    bottomBar.layer.shadowColor = [UIColor blackColor].CGColor;
    [self.view addSubview:bottomBar];

    CGFloat btnWidth = bottomBar.width/3;
    CGFloat btnHeight = 40;
    
    self.collectInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.collectInfoBtn.frame = CGRectMake(0, 0, btnWidth, btnHeight);
    [self.collectInfoBtn setTitle:@"灾情采集" forState: UIControlStateNormal];
    [self.collectInfoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.collectInfoBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    self.collectInfoBtn.tag = BottomButtonTypeCollectInfo;
    [self.collectInfoBtn addTarget:self action:@selector(bottomBarBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:self.collectInfoBtn];
    
    self.photoSetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.photoSetBtn.frame = CGRectMake(1*btnWidth, 0, btnWidth, btnHeight);
    [self.photoSetBtn setTitle:@"照片墙" forState: UIControlStateNormal];
    [self.photoSetBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.photoSetBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    self.photoSetBtn.tag = BottomButtonTypePhotoSet;
    [self.photoSetBtn addTarget:self action:@selector(bottomBarBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:self.photoSetBtn];
    
    
    self.personCenterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.personCenterBtn.frame = CGRectMake(2*btnWidth, 0,btnWidth, btnHeight);
    [self.personCenterBtn setTitle:@"个人中心" forState: UIControlStateNormal];
    [self.personCenterBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.personCenterBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    self.personCenterBtn.tag = BottomButtonTypePersonCenter;
    [self.personCenterBtn addTarget:self action:@selector(bottomBarBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:self.personCenterBtn];

    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(btnWidth, (btnHeight-10)/2, 1, btnHeight-30)];
    line1.backgroundColor = [UIColor lightGrayColor];
    [bottomBar addSubview:line1];

    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(2*btnWidth, (btnHeight-10)/2, 1, btnHeight-30)];
    line2.backgroundColor = [UIColor lightGrayColor];
    [bottomBar addSubview:line2];
    
    //设置图标
     self.collectInfoBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
    [self.collectInfoBtn setImage:[UIImage imageNamed:@"collection_icon"] forState:UIControlStateNormal];
     self.photoSetBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    [self.photoSetBtn setImage:[UIImage imageNamed:@"photoSet_icon"] forState:UIControlStateNormal];
    [self.personCenterBtn setImage:[UIImage imageNamed:@"personCenter_icon"] forState:UIControlStateNormal];
}

#pragma mark 协议方法
#pragma mark MAMapViewDelegate方法
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        self.currentLocation = userLocation;
    }
}

#pragma mark MapTypeSelectViewDelegate方法
-(void)mapTypeSelectView:(SWYMapTypeSelectView *)mapTypeView selectedType:(mapType)type
{
    switch (type) {
        case mapTypeStandard:
            [self.mapView setCameraDegree:0 animated:YES duration:0.5];
            self.mapView.mapType = MAMapTypeStandard;
            break;
        case mapTypeSatellite:
            [self.mapView setCameraDegree:0 animated:YES duration:0.5];
            self.mapView.mapType = MAMapTypeSatellite;
            break;
        case mapType3D:
            [self.mapView setCameraDegree:70.0f animated:YES duration:0.5];
            break;
    }
}

#pragma mark 事件方法
/**
 *  点击地图上的属性控制按钮后调用
 */
-(void)mapControlBtnClicked:(SWYButton *)sender
{
    if (sender.tag == ControlButtonTypeTraffic) {
        //切换交通图
        sender.selected = !sender.isSelected;
        self.mapView.showTraffic = sender.isSelected;
    }else if (sender.tag == ControlButtonTypeMylocation){
        UIImage *image;
        //切换用户跟随模式
        switch (self.mapView.userTrackingMode) {
            case MAUserTrackingModeNone:
                //切换成Follow模式
                [self.mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES];
                image = [UIImage imageNamed:@"locationIconFollow"];
                NSLog(@"Follow");
                break;
            case MAUserTrackingModeFollow:
                //切换成Heading模式
                [self.mapView setUserTrackingMode: MAUserTrackingModeFollowWithHeading animated:YES];
                image = [UIImage imageNamed:@"locationIconHeading"];
                 NSLog(@"Heading");
                break;
            case MAUserTrackingModeFollowWithHeading:
                //切换成None模式
                [self.mapView setUserTrackingMode: MAUserTrackingModeNone animated:YES];
                [self.mapView setCenterCoordinate:self.currentLocation.coordinate animated:YES];
                [self.mapView setZoomLevel:19.0f animated:YES];
                image = [UIImage imageNamed:@"locationIconNone"];
                NSLog(@"None");
                break;
        }
        [sender setImage:image forState:UIControlStateNormal];
        NSLog(@"%f",self.mapView.zoomLevel);
    }else{
        SWYMapTypeSelectView *selectView =  [[SWYMapTypeSelectView alloc] init];
        selectView.delegate = self;
        [selectView showMapTypeViewToView:self.view position:CGPointMake(sender.x, CGRectGetMaxY(sender.frame))];
    }
}

/**
 *  底部工具条被点击时调用
 */
-(void)bottomBarBtnClicked:(UIButton *)sender
{
    if (sender.tag == BottomButtonTypeCollectInfo) {
        CollectInfoViewController *collectionInfo = [[CollectInfoViewController alloc] init];
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:collectionInfo];
        [self presentViewController:navVC animated:YES completion:nil];
        
    }else if (sender.tag == BottomButtonTypePhotoSet){
        SWYPhotoSetViewController *photoSetVC = [[SWYPhotoSetViewController alloc] init];
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:photoSetVC];
        [self presentViewController:navVC animated:YES completion:nil];
        
    }else if (sender.tag == BottomButtonTypePersonCenter){
        PersonCenterViewController *personCenter = [[PersonCenterViewController alloc] init];
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:personCenter];
        [self presentViewController:navVC animated:YES completion:nil];
        
     }else{

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
    return btn;
}

@end
