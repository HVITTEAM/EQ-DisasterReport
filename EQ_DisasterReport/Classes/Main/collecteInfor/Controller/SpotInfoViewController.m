//
//  SpotInfoViewController.m
//  EQ_DisasterReport
//
//  Created by shi on 15/11/9.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "SpotInfoViewController.h"
#import "SpotTableHelper.h"
#import "SpotInforModel.h"
#import "SpotTextCell.h"
#import "SpotLabelCell.h"
#import "SpotCellModel.h"
#import "FillContentViewController.h"
#import "ImagePickCell.h"
#import "AudioCell.h"


@interface SpotInfoViewController ()<UITableViewDataSource,UITableViewDelegate,FillContentViewControllerDelegate,ImagePickCellDelegate,AudioCellDelegate>
@property(nonatomic,strong)UITableView *infoTableView;
@property(nonatomic,strong)NSArray *dataProvider;              //section 0 数据源
@property(nonatomic,strong)NSArray *images;                    //图片数组
//@property (nonatomic,strong) NSMutableArray *audioNames;       

@end

@implementation SpotInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initTableView];
    [self initNavitionBar];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark 初始化方法、setter和getter方法
/**
 *  初始化tableView
 */
-(void)initTableView
{
    self.infoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MTScreenW, MTScreenH-64) style:UITableViewStyleGrouped];
    self.infoTableView.delegate = self;
    self.infoTableView.dataSource = self;
    self.infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.infoTableView.backgroundColor = HMColor(235, 235, 235);
    [self.view addSubview:self.infoTableView];
}

/**
 *  初始化导航栏
 */
-(void)initNavitionBar
{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style: UIBarButtonItemStylePlain target:self action:@selector(saveData)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

/**
 *  dataProvider的 getter 方法
 */
-(NSArray *)dataProvider
{
    
    if (!_dataProvider) {
        SpotCellModel *model0 = [[SpotCellModel alloc] init];
        model0.titleStr = @"采集点ID:";
        //model0.contentStr = self.spotInfoModel.pointid;
        model0.placeHolderStr = @"采集点ID将自动生成";
        
        SpotCellModel *model1 = [[SpotCellModel alloc] init];
        model1.titleStr = @"发震时刻:";
        //model1.contentStr = self.spotInfoModel.collecttime;
        model1.placeHolderStr = @"发震时间";
        
        SpotCellModel *model2 = [[SpotCellModel alloc] init];
        model2.titleStr = @"震级(级):";
        //model2.contentStr = self.spotInfoModel.level;
        model2.placeHolderStr = @"输入震级";
        
        SpotCellModel *model3 = [[SpotCellModel alloc] init];
        model3.titleStr = @"震深(m):";
        //model3.contentStr = self.spotInfoModel.depth;
        model3.placeHolderStr = @"输入震深";
        
        SpotCellModel *model4 = [[SpotCellModel alloc] init];
        model4.titleStr = @"经度(度):";
        //model4.contentStr = self.spotInfoModel.lon;
        model4.placeHolderStr = @"输入经度";
        
        SpotCellModel *model5 = [[SpotCellModel alloc] init];
        model5.titleStr = @"纬度(度):";
        //model5.contentStr = self.spotInfoModel.lat;
        model5.placeHolderStr = @"输入纬度";
        
        SpotCellModel *model6 = [[SpotCellModel alloc] init];
        model6.titleStr = @"地址:";
        //model6.contentStr = self.spotInfoModel.address;
        model6.placeHolderStr = @"输入地址";
    
        SpotCellModel *model7 = [[SpotCellModel alloc] init];
        model7.titleStr = @"备注:";
        //model7.contentStr = self.spotInfoModel.descr;

        _dataProvider = @[model0,model1,model2,model3,model4,model5,model6,model7];
    }
    ((SpotCellModel *)_dataProvider[0]).contentStr = self.spotInfoModel.pointid;
    ((SpotCellModel *)_dataProvider[1]).contentStr = self.spotInfoModel.collecttime;
    ((SpotCellModel *)_dataProvider[2]).contentStr = self.spotInfoModel.level;
    ((SpotCellModel *)_dataProvider[3]).contentStr = self.spotInfoModel.depth;
    ((SpotCellModel *)_dataProvider[4]).contentStr = self.spotInfoModel.lon;
    ((SpotCellModel *)_dataProvider[5]).contentStr = self.spotInfoModel.lat;
    ((SpotCellModel *)_dataProvider[6]).contentStr = self.spotInfoModel.address;
    ((SpotCellModel *)_dataProvider[7]).contentStr = self.spotInfoModel.descr;
    return _dataProvider;
}

/**
 *  spotInfoModel的 getter 方法
 */
-(SpotInforModel *)spotInfoModel
{
    if (!_spotInfoModel) {
        _spotInfoModel = [[SpotInforModel alloc] init];
    }
    return _spotInfoModel;
}

/**
 *  图片数组的 getter 方法
 */
-(NSArray *)images
{
    if (!_images) {
        _images = [[NSArray alloc] init];
    }
    return _images;
}

#pragma mark 协议方法
#pragma mark - TableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
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
        SpotCellModel *model = self.dataProvider[indexPath.row];
        SpotTextCell *cell = [SpotTextCell cellWithTableView:tableView model:model];
        [cell setIndexPath:indexPath rowsInSection:(int)self.dataProvider.count];
        return cell;
    }else if(indexPath.section ==0 && indexPath.row ==7){
        SpotCellModel *model = self.dataProvider[indexPath.row];
        SpotLabelCell *cell = [SpotLabelCell cellWithTableView:tableView model:model];
        [cell setIndexPath:indexPath rowsInSection:(int)self.dataProvider.count];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }else if(indexPath.section == 1){
        static NSString *cellID = @"imagePickCell";
        ImagePickCell *cell = (ImagePickCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ImagePickCell" owner:nil options:nil] lastObject];
            cell.parentVC = self;
            cell.delegate = self;
        }
        return cell;
    }else{
        static NSString *cellID = @"audioCell";
        AudioCell *cell = (AudioCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"AudioCell" owner:nil options:nil] lastObject];
            cell.delegate = self;
        }
        return cell;
    }
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0 && indexPath.row !=7) {
        return 50;
    }else if(indexPath.section ==0 && indexPath.row ==7){
        static SpotLabelCell *cell = nil;
        SpotCellModel *model = self.dataProvider[indexPath.row];
        if (!cell) {
            cell = [SpotLabelCell cellWithTableView:tableView model:model];
        }
        CGFloat height = [cell calulateCellHeightWithModel:model];
        return height>50?height:50;
    }else if(indexPath.section == 1){
        NSUInteger cellNum = self.images.count+1;
        CGFloat h = 90;
        if (cellNum<=3) {
            h = 90;
        }else if (cellNum<=6){
            h = 170;
        }else{
            h = 250;
        }
        return h;
    }else{
        return 60;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 7) {
        FillContentViewController *fillVC = [[FillContentViewController alloc] init];
        fillVC.delegate = self;
        fillVC.titleStr = @"评价内容";
        fillVC.indexpath = indexPath;
        
        SpotLabelCell *cell = [self.infoTableView cellForRowAtIndexPath:indexPath];
        fillVC.contentStr = [cell getContent];
        [self.navigationController pushViewController:fillVC animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

#pragma mark - FillContentViewControllerDelegate
-(void)fillContentViewController:(FillContentViewController *)fillContentVC filledContent:(NSString *)content indexPath:(NSIndexPath *)indexpath
{
    SpotCellModel *model = self.dataProvider[indexpath.row];
    model.contentStr = content;
    [self.infoTableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - ImagePickCellDelegate
-(void)imagePickCell:(ImagePickCell *)cell pickedImages:(NSArray *)images imagePickViewheight:(CGFloat)height
{
    self.images = images;
    
    NSMutableArray *indexPathArr = [[NSMutableArray alloc] init];
    NSMutableArray *cellArr = [[NSMutableArray alloc] init];
    for (int i= 0; i<8; i++) {
        NSIndexPath *indexP = [NSIndexPath indexPathForItem:i inSection:0];
        SpotLabelCell *cell = [self.infoTableView cellForRowAtIndexPath:indexP];
        [indexPathArr addObject:indexP];
        [cellArr addObject:cell];
    }
    
    self.spotInfoModel.pointid = [cellArr[0] getContent];
    self.spotInfoModel.collecttime = [cellArr[1] getContent];
    self.spotInfoModel.level = [cellArr[2] getContent];
    self.spotInfoModel.depth = [cellArr[3] getContent];
    self.spotInfoModel.lon = [cellArr[4] getContent];
    self.spotInfoModel.lat = [cellArr[5] getContent];
    self.spotInfoModel.address = [cellArr[6] getContent];
    self.spotInfoModel.descr = [cellArr[7] getContent];
    
    [self.infoTableView reloadData];
}

#pragma mark - AudioCellDelegate
-(void)audioCell:(AudioCell *)audioCell finishRecod:(NSData *)voiceData
{
    NSLog(@"voicedata");
}

#pragma mark 事件方法
/**
 *  保存采集点的数据
 */
-(void)saveData
{
    NSMutableArray *indexPathArr = [[NSMutableArray alloc] init];
    NSMutableArray *cellArr = [[NSMutableArray alloc] init];
    
    for (int i= 0; i<8; i++) {
       NSIndexPath *indexP = [NSIndexPath indexPathForItem:i inSection:0];
       SpotLabelCell *cell = [self.infoTableView cellForRowAtIndexPath:indexP];
        [indexPathArr addObject:indexP];
        [cellArr addObject:cell];
    }
    
    for (int i= 1; i<7;i++) {
        NSString *string = [cellArr[i] getContent];
        if (string == nil || string.length<=0) {
            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"内容不能为空" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil] show];
            return;
        }
    }
    
    NSString *string1 = [cellArr[1] getContent];
    NSString *string2 = [cellArr[2] getContent];
    NSString *string3 = [cellArr[3] getContent];
    NSString *string4 = [cellArr[4] getContent];
    NSString *string5 = [cellArr[5] getContent];
    NSString *string6 = [cellArr[6] getContent];
    NSString *string7 = [cellArr[7] getContent];
    if (string7 == nil || string7.length <= 0) {
        string7 = @"";
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    [dict setObject:string1 forKey:@"collecttime"];
    [dict setObject:string2 forKey:@"level"];
    [dict setObject:string3 forKey:@"depth"];
    [dict setObject:string4 forKey:@"lon"];
    [dict setObject:string5 forKey:@"lat"];
    [dict setObject:string6 forKey:@"address"];
    [dict setObject:string7 forKey:@"descr"];
    [dict setObject:@"keykeykeykey" forKey:@"keys"];
    
    //NSLog(@"%@",dict);
    
    if (self.actionType == kActionTypeAdd) {
        [[SpotTableHelper sharedInstance] insertDataWithDictionary:dict];
    }else{
        
        [dict setObject:[cellArr[0] getContent] forKey:@"pointid"];
        [[SpotTableHelper sharedInstance] updateDataWithDictionary:dict];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
