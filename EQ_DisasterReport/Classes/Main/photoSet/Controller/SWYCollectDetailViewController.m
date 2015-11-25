//
//  SWYCollectDetailViewController.m
//  EQ_DisasterReport
//
//  Created by shi on 15/11/4.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "SWYCollectDetailViewController.h"
#import "UserInfoCell.h"
#import "PhotoInfoCell.h"
#import "DescriptionCell.h"
#import "TableHeadView.h"
#import "SWYPhotoBrowserViewController.h"

@interface SWYCollectDetailViewController ()<UITableViewDataSource,UITableViewDelegate,TableHeadViewDelegate>
@property(nonatomic,strong)UITableView *detailTableView;
@end

@implementation SWYCollectDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initTableView];
    [self initNaviBar];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
}

#pragma mark 初始化方法、setter和getter方法
/**
 *  初始化tableView
 */
-(void)initTableView
{
    self.detailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, MTScreenH) style:UITableViewStyleGrouped];
    //self.detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.detailTableView.delegate = self;
    self.detailTableView.dataSource = self;
    self.detailTableView.backgroundColor = HMGlobalBg;
    [self.view addSubview:self.detailTableView];
    self.detailTableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table_bk_image"]];
    
    //设置tableView头部视图
    TableHeadView *headView = [[[NSBundle mainBundle] loadNibNamed:@"TableHeadViw" owner:nil options:nil] lastObject];
    headView.bigimageName = self.headImageName;
    headView.addressLb.text = [NSString stringWithFormat:@"杭州西湖区文三西路%d",arc4random()%1000];
    headView.delegate = self;
    self.detailTableView.tableHeaderView = headView;
}

/**
 *  初始化自定义导航栏
 */
-(void)initNaviBar
{
    self.navigationItem.title = @"照片详情";
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
        return cell;
    }else if(indexPath.row == 1){
        static NSString *photoInfoCellId = @"photoInfoCell";
        PhotoInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:photoInfoCellId];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"PhotoInfoCell" owner:nil options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }else{
        static NSString *descriptionCellId = @"descriptionCell";
        DescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:descriptionCellId];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"DescriptionCell" owner:nil options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.descriptionStr = @"据统计，地球上每年约发生500多万次地震，即每天要发生上万次的震。其中绝大多数太小或太远，以至于人们感觉不到；真正能对人类造成严重危害的地震大约有十几二十次；能造成特别严重灾害的地震大约有一两次。人们感觉不到的地震，必须用地震仪才能记录下来；不同类型的地震仪能记录不同强度、不同远近的地震。世界上运转着数以千计的各种地震仪器日夜监测着地震的动向。";
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
        cell.descriptionStr = @"据统计，地球上每年约发生500多万次地震，即每天要发生上万次的震。其中绝大多数太小或太远，以至于人们感觉不到；真正能对人类造成严重危害的地震大约有十几二十次；能造成特别严重灾害的地震大约有一两次。人们感觉不到的地震，必须用地震仪才能记录下来；不同类型的地震仪能记录不同强度、不同远近的地震。世界上运转着数以千计的各种地震仪器日夜监测着地震的动向。";
        CGFloat h = [cell calculateCellHeight];
        return h;

    }
    return 64;
}

#pragma mark TableHeadViewDelegate
/**
 *  TableHeadView（头部大图）的协议方法
 */
-(void)tableheadView:(TableHeadView *)headVeiw didClickImageName:(NSString *)imageName
{
    //进图片浏览器查看大图
    SWYPhotoBrowserViewController *browserVC = [[SWYPhotoBrowserViewController alloc] initPhotoBrowserWithImageNames:@[imageName] currentIndex:0];
    browserVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:browserVC animated:YES completion:nil];
}

-(void)dealloc
{
    NSLog(@"SWYCollectDetailViewController 释放");
}

@end
