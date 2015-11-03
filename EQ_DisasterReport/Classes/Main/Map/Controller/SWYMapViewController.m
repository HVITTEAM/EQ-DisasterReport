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

@interface SWYMapViewController ()<MAMapViewDelegate,AMapSearchDelegate,MapTypeSelectViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong) MAUserLocation *currentLocation;

@property (nonatomic, strong) SWYButton *trafficSwitchBtn;
@property (nonatomic, strong) SWYButton *mapTypeSwitchBtn;
@property (nonatomic, strong) SWYButton *mylocationBtn;

@end

@implementation SWYMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initMapView];
    [self initControlButton];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}


-(void)initMapView{
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
    self.mapView.mapType = MAMapTypeStandard;
    
    self.mapView.compassOrigin = CGPointMake(self.mapView.compassOrigin.x, 30);
    self.mapView.scaleOrigin = CGPointMake(self.mapView.scaleOrigin.x, 30);

    self.mapView.showsUserLocation = YES;
    [self.mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES]; //地图跟着位置移动
}


-(void)initControlButton
{
    self.trafficSwitchBtn = [self createBtnWithNormalImageName:@"locationIcon" selectedImageName:@"locationIcon"];
    self.trafficSwitchBtn.x = MTScreenW - 40;
    self.trafficSwitchBtn.y = 90;
    self.trafficSwitchBtn.tag = 20;
    
    
    self.mapTypeSwitchBtn = [self createBtnWithNormalImageName:@"locationIcon" selectedImageName:@"locationIcon"];
    self.mapTypeSwitchBtn.x = MTScreenW - 40;
    self.mapTypeSwitchBtn.y = 140;
    self.mapTypeSwitchBtn.tag = 21;
    
    self.mylocationBtn = [self createBtnWithNormalImageName:@"locationIcon" selectedImageName:@"locationIcon"];
    self.mylocationBtn.x = 20;
    self.mylocationBtn.y = MTScreenH-100;
    self.mylocationBtn.tag = 22;
    
}

-(SWYButton *)createBtnWithNormalImageName:(NSString *)norImageName selectedImageName:(NSString *)seltImageName
{
    SWYButton *btn = [[SWYButton alloc] init];
    btn.bounds = CGRectMake(0, 0, 30, 30);
    
    UIImage *norImage = [UIImage imageNamed:norImageName];
    UIImage *seltImage = [UIImage imageNamed:seltImageName];
    [btn setImage:norImage forState:UIControlStateNormal];
    [btn setImage:seltImage forState:UIControlStateSelected];
    
    [self.view addSubview:btn];
    
    [btn addTarget:self action:@selector(mapControlBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor whiteColor];
    return btn;
}


-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        //取出当前位置的坐标
        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        self.currentLocation = userLocation;
    }
}

-(void)mapTypeSelectView:(SWYMapTypeSelectView *)mapTypeView selectedType:(CGFloat)type
{
    self.mapView.mapType = type;
}

-(void)mapControlBtnClicked:(SWYButton *)sender
{
    if (sender.tag == 20) {
        sender.selected = !sender.isSelected;
        self.mapView.showTraffic = !sender.isSelected;
    }else if (sender.tag == 22){
        switch (self.mapView.userTrackingMode) {
            case MAUserTrackingModeNone:
                [self.mapView setCenterCoordinate:self.currentLocation.coordinate animated:YES];
                [self.mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES];
                break;
            case MAUserTrackingModeFollow:
                [self.mapView setUserTrackingMode: MAUserTrackingModeFollowWithHeading animated:YES];
                break;
            case MAUserTrackingModeFollowWithHeading:
                [self.mapView setUserTrackingMode: MAUserTrackingModeNone animated:YES];
                break;
        }
        //NSLog(@"%d",self.mapView.userTrackingMode);
    }else{
        sender.selected = !sender.isSelected;
        if (sender.selected) {
            SWYMapTypeSelectView *xx =  [[SWYMapTypeSelectView alloc] init];
            xx.delegate = self;
            [xx showMapTypeViewToView:self.view position:CGPointMake(sender.x, CGRectGetMaxY(sender.frame))];
        }
    }
}

@end
