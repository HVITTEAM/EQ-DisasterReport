//
//  AccountTableViewController.m
//  EQ_DisasterReport
//
//  Created by shi on 15/11/22.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "AccountTableViewController.h"
#import "SpotCellModel.h"
#import "SpotTextCell.h"
#import "HMControllerTool.h"
#import "LoginUser.h"

@interface AccountTableViewController ()

@property(nonatomic,strong)NSArray *dataProvider;              //数据源

@end

@implementation AccountTableViewController

#pragma mark -- 生命周期方法 --

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_icon_white"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    UIButton *footBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    footBtn.height = 40;
    footBtn.backgroundColor = [UIColor redColor];
    [footBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [footBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    footBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [footBtn addTarget:self action:@selector(loginOut:) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = footBtn;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    
}
#pragma mark -- getter 方法和 setter 方法 --
/**
 *  dataProvider的 getter 方法
 */
-(NSArray *)dataProvider
{
    if (!_dataProvider) {
        
        SpotCellModel *model0 = [[SpotCellModel alloc] init];
        model0.titleStr = @"账号:";
        model0.placeHolderStr = nil;
        model0.contentStr = [LoginUser shareInstance].loginname;
        
        SpotCellModel *model1 = [[SpotCellModel alloc] init];
        model1.titleStr = @"昵称:";
        model1.placeHolderStr = nil;
        model1.contentStr = [LoginUser shareInstance].username;
        
        SpotCellModel *model2 = [[SpotCellModel alloc] init];
        model2.titleStr = @"邮箱:";
        model2.placeHolderStr = nil;
        //model2.contentStr = [LoginUser shareInstance].station;
        
        _dataProvider = @[@[model0,model1,model2]];
    }
    return _dataProvider;
}

#pragma mark -- Table view data source --

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataProvider.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *array = self.dataProvider[section];
    return array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SpotCellModel *model = self.dataProvider[indexPath.section][indexPath.row];
    SpotTextCell *cell = [SpotTextCell cellWithTableView:tableView model:model];
    [cell setIndexPath:indexPath rowsInSection:(int)((NSArray *)self.dataProvider[indexPath.section]).count];
    cell.userInteractionEnabled = NO;
    return cell;
}

#pragma mark -- UITableViewDelegate --
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     return 50;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
     return @"基本信息";
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 60;
}

#pragma mark -- 事件方法 --
/**
 * 退出
 */
-(void)loginOut:(UIButton *)sender
{
    [HMControllerTool setLoginViewController];
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
