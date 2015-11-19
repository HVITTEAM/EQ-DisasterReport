//
//  CollectInfoViewController.m
//  EQ_DisasterReport
//
//  Created by shi on 15/11/6.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "CollectInfoViewController.h"
#import "SpotInforCell.h"
#import "SpotInforModel.h"
#import "SpotTableHelper.h"
#import "SpotInfoViewController.h"

@interface CollectInfoViewController ()

@property(nonatomic,strong)NSMutableArray *dataProvider;   // tableview数据源

@end

@implementation CollectInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNaviBar];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //获取数据
    [self fetchData];
}

#pragma mark 初始化方法、setter和getter方法
/**
 *  初始化导航栏
 */
-(void)initNaviBar
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationController.navigationBar.barTintColor = HMColor(79, 127, 175);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    //左侧按钮
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftItem;
    //右侧按钮
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"新增" style:UIBarButtonItemStylePlain target:self action:@selector(addNewSpotInfo)];
    self.navigationItem.rightBarButtonItem = rightItem;
    //下一级的返回按钮
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;

    self.navigationItem.title = @"采集信息列表";
}

/**
 *  dataProvider的 getter 方法
 */
-(NSMutableArray *)dataProvider
{
    if (!_dataProvider) {
        _dataProvider = [[NSMutableArray alloc] init];
    }
    return _dataProvider;
}

#pragma mark 协议方法
#pragma mark - TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataProvider.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *spotInfoCellID = @"spotInforCell";
    SpotInforCell *cell = [tableView dequeueReusableCellWithIdentifier:spotInfoCellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SpotInforCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    SpotInforModel *cellModel = self.dataProvider[indexPath.row];
    cell.cellModel = cellModel;
    
    return cell;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //进入详情界面
    SpotInfoViewController *spotInfoVC = [[SpotInfoViewController alloc] init];
    spotInfoVC.spotInfoModel = self.dataProvider[indexPath.row];
    spotInfoVC.actionType = kActionTypeShow; //设置页面类型为显示和更新
    [self.navigationController pushViewController:spotInfoVC animated:YES];
}

#pragma mark 事件方法
/**
 *  获取所有采集点的数据
 */
-(void)fetchData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.dataProvider = [[SpotTableHelper sharedInstance] fetchAllData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

/**
 *  新增采集点
 */
-(void)addNewSpotInfo
{
    SpotInfoViewController *spotInfoVC = [[SpotInfoViewController alloc] init];
    spotInfoVC.actionType = kActionTypeAdd;  //设置页面类型为新增
    [self.navigationController pushViewController:spotInfoVC animated:YES];
}

/**
 *  返回上一级页面
 */
-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)dealloc
{
    NSLog(@"CollectInfoViewController 释放");
}
@end
