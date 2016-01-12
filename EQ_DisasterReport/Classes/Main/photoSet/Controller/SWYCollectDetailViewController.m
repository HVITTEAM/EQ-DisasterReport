//
//  SWYCollectDetailViewController.m
//  EQ_DisasterReport
//
//  Created by shi on 15/11/4.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#define kHeadViewDefaultHeight 230

#import "SWYCollectDetailViewController.h"
#import "UserInfoCell.h"
#import "PhotoInfoCell.h"
#import "DescriptionCell.h"
#import "TableHeadView.h"
#import "SWYPhotoBrowserViewController.h"
#import "UIImageView+WebCache.h"
#import "NSObject+Extension.h"
#import "FetchPointinfoNTHelper.h"
#import "PhotoDetailModel.h"

@interface SWYCollectDetailViewController ()<UITableViewDataSource,UITableViewDelegate,TableHeadViewDelegate,SWYNetworkCallBackDelegate,SWYNetworkParamSourceDelegate,SWYNetworkReformerDelegate>

@property(nonatomic,strong)UITableView *detailTableView;

@property(nonatomic,strong)FetchPointinfoNTHelper *fetchPointinfoHelper;        //获取图片详情信息的接口对象

@property(nonatomic,strong)PhotoDetailModel *photoDetailInfor;                  //图片详情信息对象

@end

@implementation SWYCollectDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initTableView];
    
    [self initNaviBar];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    self.fetchPointinfoHelper.detailUrl = [NSString stringWithFormat:@"%ld",(long)[self.photoInfor.pointid integerValue]];
    [self.fetchPointinfoHelper startSendRequest];
    
}

#pragma mark 初始化方法、setter和getter方法
/**
 *  初始化tableView
 */
-(void)initTableView
{
    self.detailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, MTScreenH) style:UITableViewStyleGrouped];
    self.detailTableView.delegate = self;
    self.detailTableView.dataSource = self;
    self.detailTableView.backgroundColor = HMGlobalBg;
    [self.view addSubview:self.detailTableView];
    
    //设置tableView头部视图
    TableHeadView *headView = [[[NSBundle mainBundle] loadNibNamed:@"TableHeadViw" owner:nil options:nil] lastObject];
    headView.delegate = self;
    self.detailTableView.tableHeaderView = headView;
    
    NSString *encodeUrlStr = [self.photoInfor.photopath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [headView.bigImagV sd_setImageWithURL:[NSURL URLWithString:encodeUrlStr] placeholderImage:[UIImage imageNamed:@"placeholder_image"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //根据图片调整视图高度
        [self setTableHeadViewSizeWithHeadImage:image];
        
    }];
    //下方的渐变图片，防止图片为浅色时，地址显示不清楚
    UIImage *gradientImg = [UIImage imageNamed:@"gradientBK_black"];
    headView.gradientBKView.image = [gradientImg resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
}

/**
 *  初始化自定义导航栏
 */
-(void)initNaviBar
{
    self.navigationItem.title = @"照片详情";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_icon_black"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
}

/**
 *  fetchPointinfoHelper的 getter 方法
 */
-(FetchPointinfoNTHelper *)fetchPointinfoHelper
{
    if (!_fetchPointinfoHelper) {
        _fetchPointinfoHelper = [[FetchPointinfoNTHelper alloc] init];
        _fetchPointinfoHelper.callBackDelegate = self;
        _fetchPointinfoHelper.paramSource = self;
    }
    return _fetchPointinfoHelper;
}

/**
 *  photoDetailInfor的 getter 方法
 */
-(PhotoDetailModel *)photoDetailInfor
{
    if (!_photoDetailInfor) {
        _photoDetailInfor = [[PhotoDetailModel alloc] init];
    }
    return _photoDetailInfor;
}

#pragma mark 协议方法
#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *userInfoCellId = @"userInfoCell";
        UserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:userInfoCellId];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"UserInfoCell" owner:nil options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.userNameLb.text = self.photoDetailInfor.username;
        cell.timeLb.text = [NSString stringWithFormat:@"%@  上传",self.photoDetailInfor.collecttime];
        
        return cell;
        
    }else if(indexPath.row == 1){
        static NSString *photoInfoCellId = @"photoInfoCell";
        PhotoInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:photoInfoCellId];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"PhotoInfoCell" owner:nil options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.latLb.text = self.photoDetailInfor.latitude;
        cell.lonLb.text = self.photoDetailInfor.longitude;
        cell.levelLb.text = self.photoDetailInfor.earthquakeintensity;
        
        return cell;
        
    }else{
        static NSString *descriptionCellId = @"descriptionCell";
        DescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:descriptionCellId];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"DescriptionCell" owner:nil options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.descriptionStr = self.photoDetailInfor.descr?self.photoDetailInfor.descr:@"";
        
        return cell;
    }
}

#pragma mark UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 70;
    }else if (indexPath.row == 2){
        static NSString *descriptionCellId = @"descriptionCell";
        static DescriptionCell *cell = nil;
        cell = [self.detailTableView dequeueReusableCellWithIdentifier:descriptionCellId];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"DescriptionCell" owner:nil options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.descriptionStr = self.photoDetailInfor.descr?self.photoDetailInfor.descr:@"";
        
        CGFloat h = [cell calculateCellHeight];
        return h;
    }
    
    return 64;
}


#pragma mark SWYNetworkParamSourceDelegate
- (SWYRequestParams *)paramsForRequest:(SWYBaseNetworkHelper *)networkHelper
{
    return nil;
}

#pragma mark SWYNetworkCallBackDelegate
- (void)requestDidSuccess:(SWYBaseNetworkHelper *)networkHelper
{
   self.photoDetailInfor = [networkHelper fetchDataWithReformer:self];
    ((TableHeadView *)self.detailTableView.tableHeaderView).addressLb.text = self.photoDetailInfor.address;
   [self.detailTableView reloadData];
    NSLog(@"成功");
}

- (void)requestDidFailed:(SWYBaseNetworkHelper *)networkHelper
{
    NSLog(@"失败");
}

#pragma mark SWYNetworkReformerDelegate
//对下载的原始数据进行重组，生成可直接使用的数据
- (id)networkHelper:(SWYBaseNetworkHelper *)networkHelper reformData:(id)data
{
    NSLog(@"SWYCollectDetailViewController---------%@",data);
    
    PhotoDetailModel *model = [[PhotoDetailModel alloc] init];
    
    model.address = [data[@"address"] validateDataIsNull];
    
    
    
//    NSString *timeStr = [data[@"collecttime"] validateDataIsNull];
//    NSLog(@"%@",timeStr);
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    
//    NSLocale * locale = [NSLocale currentLocale];
//    
//    [formatter setLocale:[NSLocale currentLocale]];
//    [formatter setDateFormat:@"yyyy-MM-dd hh:mm"];
//    NSDate *date = [formatter dateFromString:timeStr];
//    NSString *collectionTime = [formatter stringFromDate:date];
    
    model.collecttime = [data[@"collecttime"] validateDataIsNull];
    model.descr = [data[@"description"] validateDataIsNull];
    model.earthquakeintensity = [NSString stringWithFormat:@"%@",[data[@"earthquakeintensity"] validateDataIsNull]];
    model.keys = [data[@"keys"] validateDataIsNull];
    model.latitude = [NSString stringWithFormat:@"%@",[data[@"latitude"] validateDataIsNull]];
    model.longitude = [NSString stringWithFormat:@"%@",[data[@"longitude"] validateDataIsNull]];
    model.pointid = [NSString stringWithFormat:@"%@",[data[@"pointid"] validateDataIsNull]];
    model.username = [data[@"username"] validateDataIsNull];
    model.loginname = [data[@"loginname"] validateDataIsNull];
    
    return model;
}

#pragma mark TableHeadViewDelegate
/**
 *  TableHeadView（头部大图）的协议方法
 */
-(void)tableheadView:(TableHeadView *)headVeiw didClickImageName:(NSString *)imageName
{
    //进图片浏览器查看大图
    SWYPhotoBrowserViewController *browserVC = [[SWYPhotoBrowserViewController alloc] initPhotoBrowserWithImages:@[headVeiw.bigImagV.image] currentIndex:0];
    browserVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:browserVC animated:YES completion:nil];
}


#pragma mark 内部方法
/**
 *  设置TableHeadView（头部大图）的尺寸
 */
-(void)setTableHeadViewSizeWithHeadImage:(UIImage *)headImage
{
    //图片的宽高
    CGFloat imageWidth = headImage.size.width;
    CGFloat imageHeight = headImage.size.height;
    
    //视图的宽高，默认视图的宽为屏幕的宽
    CGFloat headViewWidth = MTScreenW;
    CGFloat headViewHeight = imageHeight * headViewWidth / imageWidth;
    
    if (headViewHeight > MTScreenH * 0.75) {    //如果高大于屏幕高的3/4
        headViewHeight = MTScreenH * 0.75;
    }else if (headViewHeight < kHeadViewDefaultHeight){    //如果高小于默认高度
        headViewHeight = kHeadViewDefaultHeight;
    }
    UIView *headerView = self.detailTableView.tableHeaderView;
    headerView.frame = CGRectMake(0, 0, headViewWidth, headViewHeight);
    self.detailTableView.tableHeaderView = headerView;
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc
{
    NSLog(@"SWYCollectDetailViewController 释放");
}

@end
