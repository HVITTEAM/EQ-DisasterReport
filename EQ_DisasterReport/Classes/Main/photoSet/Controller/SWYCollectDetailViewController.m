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
#import "SWYNavigationBar.h"

@interface SWYCollectDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,TableHeadViewDelegate,NavigationBarDelegate>
@property(nonatomic,strong)UITableView *detailTableView;
@property(nonatomic,strong)SWYNavigationBar *naviBar;
@end

@implementation SWYCollectDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initTableView];
    [self initNaviBar];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

#pragma mark 初始化方法、setter和getter方法
/**
 *  初始化tableView
 */
-(void)initTableView
{
    self.detailTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.detailTableView.delegate = self;
    self.detailTableView.dataSource = self;
    [self.view addSubview:self.detailTableView];
    
    //设置tableView头部视图
    TableHeadView *headView = [[[NSBundle mainBundle] loadNibNamed:@"TableHeadViw" owner:nil options:nil] lastObject];
    headView.bigimageName = self.headImageName;
    headView.addressLb.text = [NSString stringWithFormat:@"杭州西湖区文三西路%d",arc4random()%1000];
    headView.delegate = self;
    self.detailTableView.tableHeaderView = headView;
}

/**
 *  初始化tableView
 */
-(void)initNaviBar
{
    self.naviBar = [[SWYNavigationBar alloc]initCustomNavigatinBar];
    self.naviBar.delegate = self;
    [self.view addSubview:self.naviBar];
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
    browserVC.imageNames = @[@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg",@"5.jpg",@"6.jpg",@"7.jpg",@"8.jpg",@"9.jpg",@"10.jpg"];

    [self presentViewController:browserVC animated:YES completion:nil];
}

#pragma mark NavigationBarDelegate
/**
 *  自定义导航条的协议方法
 */
-(void)navigationBar:(SWYNavigationBar *)naviBar didClickLeftBtn:(UIButton *)leftBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y<0) {
        CGFloat alph = scrollView.contentOffset.y/20;
        NSLog(@"%f",alph);
        if (alph>=1.0) {
            alph = 1.0;
        }else if (alph<=0){
            alph = 0;
        }
        self.naviBar.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:alph];
    }
}

@end
