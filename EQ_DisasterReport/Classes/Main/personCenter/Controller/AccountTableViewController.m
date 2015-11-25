//
//  AccountTableViewController.m
//  EQ_DisasterReport
//
//  Created by shi on 15/11/22.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "AccountTableViewController.h"
#import "SpotCellModel.h"
#import "SpotLabelCell.h"
#import "SpotTextCell.h"
#import "FillContentViewController.h"
#import "HMControllerTool.h"

@interface AccountTableViewController ()<FillContentViewControllerDelegate>
@property(nonatomic,strong)NSArray *dataProvider;              //数据源
@end

@implementation AccountTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    UIButton *footBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    footBtn.height = 40;
    footBtn.backgroundColor = [UIColor redColor];
    [footBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [footBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    footBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [footBtn addTarget:self action:@selector(loginOut:) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = footBtn;
}

/**
 *  dataProvider的 getter 方法
 */
-(NSArray *)dataProvider
{
    if (!_dataProvider) {
        SpotCellModel *model0 = [[SpotCellModel alloc] init];
        model0.titleStr = @"帐号:";
        model0.placeHolderStr = @"帐号";
        model0.contentStr = @"1234567890";
        
        SpotCellModel *model1 = [[SpotCellModel alloc] init];
        model1.titleStr = @"姓名:";
        model1.placeHolderStr = @"输入姓名";
        
        SpotCellModel *model2 = [[SpotCellModel alloc] init];
        model2.titleStr = @"年龄:";
        model2.placeHolderStr = @"输入年龄";
        
        SpotCellModel *model3 = [[SpotCellModel alloc] init];
        model3.titleStr = @"性别:";
        model3.placeHolderStr = @"输入性别";
        
        SpotCellModel *model4 = [[SpotCellModel alloc] init];
        model4.titleStr = @"联系电话:";
        model4.placeHolderStr = @"输入联系电话";
        
        SpotCellModel *model5 = [[SpotCellModel alloc] init];
        model5.titleStr = @"地址:";
        model5.placeHolderStr = @"输入地址";
        
        SpotCellModel *model6 = [[SpotCellModel alloc] init];
        model6.titleStr = @"个人爱好:";
        model6.placeHolderStr = @"输入个人爱好";
        
        _dataProvider = @[@[model0,model1,model2,model3,model4],@[model5,model6]];
    }
    return _dataProvider;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataProvider.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *array = self.dataProvider[section];
    return array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0){
        SpotCellModel *model = self.dataProvider[indexPath.section][indexPath.row];
        SpotTextCell *cell = [SpotTextCell cellWithTableView:tableView model:model];
        [cell setIndexPath:indexPath rowsInSection:(int)((NSArray *)self.dataProvider[indexPath.section]).count];
        if (indexPath.row == 0) {
            cell.userInteractionEnabled = NO;
        }
        return cell;
    }else {
        SpotCellModel *model = self.dataProvider[indexPath.section][indexPath.row];
        SpotLabelCell *cell = [SpotLabelCell cellWithTableView:tableView model:model];
        [cell setIndexPath:indexPath rowsInSection:(int)((NSArray *)self.dataProvider[indexPath.section]).count];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 50;
    }else{
        static SpotLabelCell *calulateCell = nil;
        SpotCellModel *model = self.dataProvider[indexPath.section][indexPath.row];
        if (!calulateCell) {
            calulateCell = [SpotLabelCell cellWithTableView:tableView model:model];
        }
        CGFloat height = [calulateCell calulateCellHeightWithModel:model];
        return height>50?height:50;
    }
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"基本信息";
    }else{
        return @"详细信息";
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 30;
    }
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        FillContentViewController *fillVC = [[FillContentViewController alloc] init];
        fillVC.delegate = self;
        NSString *titlestr = ((SpotCellModel *)self.dataProvider[indexPath.section][indexPath.row]).titleStr;
        fillVC.titleStr = [titlestr substringToIndex:titlestr.length-1];
        fillVC.indexpath = indexPath;
        
        SpotLabelCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        fillVC.contentStr = [cell getContent];
        [self.navigationController pushViewController:fillVC animated:YES];
    }
}

#pragma mark - FillContentViewControllerDelegate
-(void)fillContentViewController:(FillContentViewController *)fillContentVC filledContent:(NSString *)content indexPath:(NSIndexPath *)indexpath
{
    ((SpotCellModel *)self.dataProvider[indexpath.section][indexpath.row]).contentStr = content;
    [self.tableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
}


-(void)loginOut:(UIButton *)sender
{
    NSLog(@"退出");
    [HMControllerTool setLoginViewController];
}

@end
