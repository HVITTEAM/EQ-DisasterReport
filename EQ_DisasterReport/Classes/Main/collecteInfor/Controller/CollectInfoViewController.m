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
#import "PictureTableHelper.h"
#import "VoiceTableHelper.h"
#import "MenuView.h"

@interface CollectInfoViewController ()<MenuViewDelegate,SpotInfoUploadDelegate,UIAlertViewDelegate>

@property(strong,nonatomic)NSMutableArray *dataProvider;   // tableview数据源

//@property(strong,nonatomic)NSMutableArray *selectedDatas;   //  选中的所有cell的数据

@property(strong,nonatomic)UIBarButtonItem *leftItem;

@property(strong,nonatomic)UIBarButtonItem *cancelItem;

@property(strong,nonatomic)UIBarButtonItem *rightItem;

@property(strong,nonatomic)MenuView *menuView;                //弹出菜单(新增，删除)

@property(assign,nonatomic)BOOL isAllSelected;

@end

@implementation CollectInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNaviBar];
    
    [self initToolBar];

    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //获取数据
    [self fetchData];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //隐藏弹出菜单
    [self.menuView hideMenuView];
}

#pragma mark 初始化方法、setter和getter方法
/**
 *  初始化导航栏
 */
-(void)initNaviBar
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationController.navigationBar.barTintColor = HMColor(99, 148, 225);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    //左侧按钮
    self.cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAllSelect)];
    self.leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_icon_white"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = self.leftItem;
    //右侧按钮
     self.rightItem= [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(showMenu)];
    self.navigationItem.rightBarButtonItem = self.rightItem;
    //下一级的返回按钮
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;

    self.navigationItem.title = @"采集信息列表";
}

/**
 *  底部工具栏
 */
-(void)initToolBar
{
    UIBarButtonItem *leftToolbarItem = [[UIBarButtonItem alloc] initWithTitle:@"全选" style: UIBarButtonItemStylePlain target:self action:@selector(selectAllItem)];
    UIBarButtonItem *rightToolbarItem = [[UIBarButtonItem alloc] initWithTitle:@"删除" style: UIBarButtonItemStylePlain target:self action:@selector(deleteSelectedItem)];
    UIBarButtonItem *flexibleSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [self setToolbarItems:@[leftToolbarItem,flexibleSpaceItem,rightToolbarItem] animated:YES];
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
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    SpotInforModel *cellModel = self.dataProvider[indexPath.row];
    cell.cellModel = cellModel;
    
    return cell;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRowAtIndexPath调用了吗");
    if (self.tableView.isEditing) {
        return;
    }
    //进入详情界面
    SpotInfoViewController *spotInfoVC = [[SpotInfoViewController alloc] init];
    spotInfoVC.spotInfoModel = self.dataProvider[indexPath.row];
    spotInfoVC.currentIdx = indexPath;
    spotInfoVC.delegate = self;
    spotInfoVC.actionType = kActionTypeShow; //设置页面类型为显示和更新
    [self.navigationController pushViewController:spotInfoVC animated:YES];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didDeselectRowAtIndexPath调用了吗");
    self.isAllSelected = NO;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        SpotInforModel *model = self.dataProvider[indexPath.row];
        BOOL result = [self deleteItemByModel:model];
        if (result) {
            [self.dataProvider removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }else{
            [[[UIAlertView alloc] initWithTitle:nil message:@"删除失败！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
        }
    }
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }
    
    NSLog(@"delete");
    NSArray *arr = [self.tableView indexPathsForSelectedRows];
    NSLog(@"dataProvider个数%d",(int)self.dataProvider.count);
    NSLog(@"选中个数%d",(int)arr.count);
    NSLog(@"可见个数%d",(int) [self.tableView visibleCells].count);
    
    NSArray *selectedIndexPaths = [self.tableView indexPathsForSelectedRows];
    if (selectedIndexPaths.count == 0 || selectedIndexPaths==nil) {
        return;
    }
    NSLog(@"delete");
    NSMutableArray *deleteDatas = [[NSMutableArray alloc] init];
    for (NSIndexPath *indexpath in selectedIndexPaths) {
        [deleteDatas addObject:self.dataProvider[indexpath.row]];
    }
    
    for (SpotInforModel *model in deleteDatas) {
        [self deleteItemByModel:model];
        [self.dataProvider removeObject:model];
    }
    [self.tableView reloadData];
    [self cancelAllSelect];
    
}

-(void)menuView:(MenuView *)menuView indexForItem:(NSInteger)idx
{
    if (idx == 0) {  //新增采集点
        SpotInfoViewController *spotInfoVC = [[SpotInfoViewController alloc] init];
        spotInfoVC.actionType = kActionTypeAdd;  //设置页面类型为新增
        [self.navigationController pushViewController:spotInfoVC animated:YES];
    }else if (idx == 1){
        
        if (self.dataProvider.count == 0) {
            return;
        }
        
        [self.tableView setEditing:YES animated:YES];
        [self.navigationController setToolbarHidden:NO animated:YES];
        [self.navigationItem setRightBarButtonItem:nil animated:YES];
        [self.navigationItem setLeftBarButtonItem:self.cancelItem animated:YES];
    }
}

-(void)spotInfoViewController:(SpotInfoViewController *)spotInfoVC uploadSuccessIndexPath:(NSIndexPath *)idx
{
    SpotInforModel *model = self.dataProvider[idx.row];
    [[SpotTableHelper sharedInstance] updateUploadFlag:kdidUpload ID:model.pointid];
    [self.navigationController popToViewController:self animated:YES];
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
 *  显示菜单按钮
 */
-(void)showMenu
{
    self.menuView = [[MenuView alloc] initWithTitles:@[@"新增",@"删除"] titleIcons:@[@"edit_icon",@"delete_icon"]];
    self.menuView.delegate = self;
    UIWindow *window = [[UIApplication sharedApplication]keyWindow];
    [self.menuView showMenuViewInView:window frame:CGRectMake(0, 55, window.width, window.height - 55)];
}

/**
 *  全选
 */
-(void)selectAllItem
{
    if (self.isAllSelected) {
        return;
    }
    for (int i = 0; i<self.dataProvider.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        
        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    self.isAllSelected = !self.isAllSelected;
    NSLog(@"全选");
}

/**
 *  删除选中的
 */
-(void)deleteSelectedItem
{
    [[[UIAlertView alloc] initWithTitle:nil message:@"确认删除吗？删除后将不可恢复！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
}

/**
 * 取消
 */
-(void)cancelAllSelect
{
    [self.tableView setEditing:NO animated:YES];
    [self.navigationController setToolbarHidden:YES animated:YES];
    [self.navigationItem setRightBarButtonItem:self.rightItem animated:YES];
    [self.navigationItem setLeftBarButtonItem:self.leftItem animated:YES];
}

/**
 *  返回上一级页面
 */
-(void)back
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  删除数据
 */
-(BOOL)deleteItemByModel:(SpotInforModel *)model
{
    BOOL result = NO;
    result = [[PictureTableHelper sharedInstance] deleteImageByAttribute:@"releteid" value:model.pointid];
    if (result) {
        result = [[VoiceTableHelper sharedInstance] deleteVoiceByAttribute:@"releteid" value:model.pointid];
        if (result) {
            result = [[SpotTableHelper sharedInstance] deleteDataByAttribute:@"pointid" value:model.pointid];
        }
    }
    return result;
}

-(void)dealloc
{
    NSLog(@"CollectInfoViewController 释放");
}
@end
