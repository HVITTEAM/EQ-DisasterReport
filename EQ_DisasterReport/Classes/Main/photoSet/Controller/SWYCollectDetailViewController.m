//
//  SWYCollectDetailViewController.m
//  EQ_DisasterReport
//
//  Created by shi on 15/11/4.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "SWYCollectDetailViewController.h"
#import "UserInfoCell.h"
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
    self.detailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, MTScreenH) style:UITableViewStylePlain];
    self.detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *userInfoCellId = @"userInfoCell";
    UserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:userInfoCellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"UserInfoCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

#pragma mark UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

#pragma mark TableHeadViewDelegate
/**
 *  TableHeadView（头部大图）的协议方法
 */
-(void)tableheadView:(TableHeadView *)headVeiw didClickImageName:(NSString *)imageName
{
    //进图片浏览器查看大图
    SWYPhotoBrowserViewController *browserVC = [[SWYPhotoBrowserViewController alloc] init];
    browserVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    browserVC.imageNames = @[imageName];

    [self presentViewController:browserVC animated:YES completion:nil];
}

-(void)dealloc
{
    NSLog(@"SWYCollectDetailViewController 释放");
}

@end
