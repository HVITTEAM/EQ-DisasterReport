//
//  SpotInfoViewController.m
//  EQ_DisasterReport
//
//  Created by shi on 15/11/9.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "SpotInfoViewController.h"
#import "SpotTextCell.h"
#import "SpotLabelCell.h"
#import "FillContentViewController.h"
#import "ImagePickCell.h"
@interface SpotInfoViewController ()<UITableViewDataSource,UITableViewDelegate,FillContentViewControllerDelegate>
@property(nonatomic,strong)UITableView *infoTableView;
@property(nonatomic,strong)NSArray *dataProvider;

@end

@implementation SpotInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTableView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //self.navigationController.navigationBarHidden = YES;
}

-(void)initTableView
{
    self.infoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MTScreenW, MTScreenH-64) style:UITableViewStyleGrouped];
    self.infoTableView.delegate = self;
    self.infoTableView.dataSource = self;
    [self.view addSubview:self.infoTableView];
    self.infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.infoTableView.backgroundColor = HMColor(235, 235, 235);
}

-(NSArray *)dataProvider
{
    
    if (!_dataProvider) {
        SpotInfoModel *model1 = [[SpotInfoModel alloc] init];
        model1.titleStr = @"采集点详情:";
        //model1.contentStr = @"";
        model1.placeHolderStr = @"采集点详情";
        
        SpotInfoModel *model2 = [[SpotInfoModel alloc] init];
        model2.titleStr = @"震中地名:";
        //model2.contentStr = @" 多少分撒点粉";
        model2.placeHolderStr = @"震中地名";
        
        SpotInfoModel *model3 = [[SpotInfoModel alloc] init];
        model3.titleStr = @"发震时刻:";
        model3.contentStr = @"顶一顶";
        model3.placeHolderStr = @"ssdfsdfsdfsdf";
        
        SpotInfoModel *model4 = [[SpotInfoModel alloc] init];
        model4.titleStr = @"震级:";
        model4.contentStr = @"10";
        model4.placeHolderStr = @"ssdfsdfsdfsdf";
        
        SpotInfoModel *model5 = [[SpotInfoModel alloc] init];
        model5.titleStr = @"震深:";
        model5.contentStr = @"80km";
        model5.placeHolderStr = @"ssdfsdfsdfsdf";
        
        SpotInfoModel *model6 = [[SpotInfoModel alloc] init];
        model6.titleStr = @"经度:";
        model6.contentStr = @"120";
        model6.placeHolderStr = @"ssdfsdfsdfsdf";
        
        SpotInfoModel *model7 = [[SpotInfoModel alloc] init];
        model7.titleStr = @"纬度:";
        model7.contentStr = @"30";
        model7.placeHolderStr = @"ssdfsdfsdfsdf";
        
        SpotInfoModel *model8 = [[SpotInfoModel alloc] init];
        model8.titleStr = @"备注:";
        model8.contentStr = @"西大坨村舒服舒服撒发撒发撒发撒单方事故多少分鬼地方广东佛山地方个人太温柔微任务欠人情我认为人尔特光碟伺服咕嘟咕嘟发生过订购方式光碟伺服古典风格西大坨光碟伺服古典风格";

        _dataProvider = @[model1,model2,model3,model4,model5,model6,model7,model8];
    }
    return _dataProvider;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 8;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0 && indexPath.row !=7){
        SpotInfoModel *model = self.dataProvider[indexPath.row];
        SpotTextCell *cell = [SpotTextCell cellWithTableView:tableView model:model];
        [cell setIndexPath:indexPath rowsInSection:(int)self.dataProvider.count];
        return cell;
    }else if(indexPath.section ==0 && indexPath.row ==7){
        SpotInfoModel *model = self.dataProvider[indexPath.row];
        SpotLabelCell *cell = [SpotLabelCell cellWithTableView:tableView model:model];
        [cell setIndexPath:indexPath rowsInSection:(int)self.dataProvider.count];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }else{
        static NSString *cellID = @"imagePickCell";
        ImagePickCell *cell = (ImagePickCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ImagePickCell" owner:nil options:nil] lastObject];
            cell.parentVC = self;
        }
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0 && indexPath.row !=7) {
        return 50;
    }else if(indexPath.section ==0 && indexPath.row ==7){
        static SpotLabelCell *cell = nil;
        SpotInfoModel *model = self.dataProvider[indexPath.row];
        if (!cell) {
            cell = [SpotLabelCell cellWithTableView:tableView model:model];
        }
        CGFloat height = [cell calulateCellHeightWithModel:model];
        return height>50?height:50;
    }else{
        return 90;
    }
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 7) {
        FillContentViewController *fillVC = [[FillContentViewController alloc] init];
        fillVC.delegate = self;
        fillVC.titleStr = @"评价内容";
        fillVC.indexpath = indexPath;
        [self.navigationController pushViewController:fillVC animated:YES];
    }
}

-(void)fillContentViewController:(FillContentViewController *)fillContentVC filledContent:(NSString *)content indexPath:(NSIndexPath *)indexpath
{
    //SpotLabelCell *cell = [self.infoTableView cellForRowAtIndexPath:indexpath];
    SpotInfoModel *model = self.dataProvider[indexpath.row];
    model.contentStr = content;
    //[self.infoTableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationLeft];
    [self.infoTableView reloadData];
    
}

@end