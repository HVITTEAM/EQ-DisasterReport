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
#import "VoiceModel.h"
#import "PhotoModel.h"
#import "SpotTextCell.h"
#import "SpotLabelCell.h"
#import "SpotCellModel.h"
#import "FillContentViewController.h"
#import "ImagePickCell.h"
#import "AudioCell.h"
#import "PictureVO.h"
#import "AudioVO.h"
#import "PictureTableHelper.h"
#import "AppDelegate.h"


@interface SpotInfoViewController ()<UITableViewDataSource,UITableViewDelegate,FillContentViewControllerDelegate,ImagePickCellDelegate,AudioCellDelegate>
@property(nonatomic,strong)UITableView *infoTableView;
@property(nonatomic,strong)NSArray *dataProvider;              //section 0 数据源
@property(nonatomic,strong)NSMutableArray *images;            //图片数组
@property(nonatomic,strong)AudioVO *audioVO;                //声音数据

@end

@implementation SpotInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initTableView];
    [self initNavitionBar];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self showData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
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
    
    //下一级的返回按钮
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;

}

/**
 *  dataProvider的 getter 方法
 */
-(NSArray *)dataProvider
{
    if (!_dataProvider) {
        SpotCellModel *model0 = [[SpotCellModel alloc] init];
        model0.titleStr = @"采集信息ID:";
        model0.placeHolderStr = @"采集点ID将自动生成";
        
        SpotCellModel *model1 = [[SpotCellModel alloc] init];
        model1.titleStr = @"发震时刻:";
        model1.placeHolderStr = @"发震时间";
        
        SpotCellModel *model2 = [[SpotCellModel alloc] init];
        model2.titleStr = @"震级(级):";
        model2.placeHolderStr = @"输入震级";
        
        SpotCellModel *model3 = [[SpotCellModel alloc] init];
        model3.titleStr = @"震深(m):";
        model3.placeHolderStr = @"输入震深";
        
        SpotCellModel *model4 = [[SpotCellModel alloc] init];
        model4.titleStr = @"经度(度):";
        model4.placeHolderStr = @"输入经度";
        
        SpotCellModel *model5 = [[SpotCellModel alloc] init];
        model5.titleStr = @"纬度(度):";
        model5.placeHolderStr = @"输入纬度";
        
        SpotCellModel *model6 = [[SpotCellModel alloc] init];
        model6.titleStr = @"地址:";
        model6.placeHolderStr = @"输入地址";
    
        SpotCellModel *model7 = [[SpotCellModel alloc] init];
        model7.titleStr = @"备注:";
        model7.placeHolderStr = @"输入备注内容";

        _dataProvider = @[model0,model1,model2,model3,model4,model5,model6,model7];
    }
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

-(void)setSpotInfoModel:(SpotInforModel *)spotInfoModel
{
    _spotInfoModel = spotInfoModel;
    ((SpotCellModel *)self.dataProvider[0]).contentStr = self.spotInfoModel.pointid;
    ((SpotCellModel *)self.dataProvider[1]).contentStr = self.spotInfoModel.collecttime;
    ((SpotCellModel *)self.dataProvider[2]).contentStr = self.spotInfoModel.level;
    ((SpotCellModel *)self.dataProvider[3]).contentStr = self.spotInfoModel.depth;
    ((SpotCellModel *)self.dataProvider[4]).contentStr = self.spotInfoModel.lon;
    ((SpotCellModel *)self.dataProvider[5]).contentStr = self.spotInfoModel.lat;
    ((SpotCellModel *)self.dataProvider[6]).contentStr = self.spotInfoModel.address;
    ((SpotCellModel *)self.dataProvider[7]).contentStr = self.spotInfoModel.descr;
}

/**
 *  图片数组的 getter 方法
 */
-(NSMutableArray *)images
{
    if (!_images) {
        _images = [[NSMutableArray alloc] init];
    }
    return _images;
}

/**
 *  声音数据的 getter 方法
 */
-(AudioVO *)audioVO
{
    if (!_audioVO) {
        _audioVO = [[AudioVO alloc] init];
    }
    return _audioVO;
}

-(void)showData
{
    if (self.actionType == kActionTypeShow) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSMutableArray *images = [self getImagesWithReleteId:self.spotInfoModel.pointid releteTable:nil];
            self.images = images;
            self.audioVO = [self getVoiceWithReleteId:self.spotInfoModel.pointid releteTable:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.infoTableView reloadData];
            });
        });
    }else{
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
        NSDate *currentdate = [NSDate date];
        NSString *dateStr = [formatter stringFromDate:currentdate];
        ((SpotCellModel *)self.dataProvider[1]).contentStr = dateStr;
        
        AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        CLLocationCoordinate2D coordinate = appdelegate.currentLocation.coordinate;
        ((SpotCellModel *)self.dataProvider[4]).contentStr = [NSString stringWithFormat:@"%f",coordinate.longitude];
        ((SpotCellModel *)self.dataProvider[5]).contentStr = [NSString stringWithFormat:@"%f",coordinate.latitude];
    }

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
        if (indexPath.row == 0) {
            cell.userInteractionEnabled = NO;
        }
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
        cell.images = self.images;
        return cell;
    }else{
        static NSString *cellID = @"audioCell";
        AudioCell *cell = (AudioCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"AudioCell" owner:nil options:nil] lastObject];
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.indexpath = indexPath;
        cell.audioData = self.audioVO.audioData;
        return cell;
    }
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0 && indexPath.row !=7) {
        return 50;
    }else if(indexPath.section ==0 && indexPath.row ==7){
         static SpotLabelCell *calulateCell = nil;
        SpotCellModel *model = self.dataProvider[indexPath.row];
        if (!calulateCell) {
            calulateCell = [SpotLabelCell cellWithTableView:tableView model:model];
        }
        CGFloat height = [calulateCell calulateCellHeightWithModel:model];
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
   ((SpotCellModel *)self.dataProvider[7]).contentStr = content;
    [self.infoTableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - ImagePickCellDelegate
-(void)imagePickCell:(ImagePickCell *)cell pickedImages:(NSMutableArray *)images imagePickViewheight:(CGFloat)height
{
    self.images = images;

    [self.infoTableView reloadData];

}

#pragma mark - AudioCellDelegate
-(void)audioCell:(AudioCell *)audioCell finishRecod:(NSData *)voiceData
{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    //用[NSDate date]可以获取系统当前时间
    NSString *voiceName = [dateFormatter stringFromDate:[NSDate date]];
    self.audioVO.name = voiceName;
    self.audioVO.audioData = voiceData;
}

-(void)audiocell:(AudioCell *)audiocell resetAudioBtnClickedWithIndexpath:(NSIndexPath *)indexpath
{
    if (self.actionType == kActionTypeShow) {
        [[VoiceTableHelper sharedInstance] deleteVoiceByAttribute:@"releteid" value:self.spotInfoModel.pointid];
        self.audioVO = nil;
    }
}

#pragma mark 事件方法
/**
 *  保存采集点的数据
 */
-(void)saveData
{
    NSMutableArray *tempArr = [NSMutableArray array];
    for (int i= 0; i<self.dataProvider.count;i++) {
        NSString *string = ((SpotCellModel *)self.dataProvider[i]).contentStr;
        if (i>0&&i<=6) {
            if (string == nil || string.length<=0) {
                [[[UIAlertView alloc] initWithTitle:@"提示" message:@"内容不能为空" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil] show];
                return;
            }
        }else {
            if (string == nil || string.length <= 0) {
                string = @"";
            }
        }
        [tempArr addObject:string];
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    [dict setObject:tempArr[0] forKey:@"pointid"];
    [dict setObject:tempArr[1] forKey:@"collecttime"];
    [dict setObject:tempArr[2] forKey:@"level"];
    [dict setObject:tempArr[3] forKey:@"depth"];
    [dict setObject:tempArr[4] forKey:@"lon"];
    [dict setObject:tempArr[5] forKey:@"lat"];
    [dict setObject:tempArr[6] forKey:@"address"];
    [dict setObject:tempArr[7] forKey:@"descr"];
    [dict setObject:@"keykeykeykey" forKey:@"keys"];
    
    if (self.actionType == kActionTypeAdd) {
        [[SpotTableHelper sharedInstance] insertDataWithDictionary:dict];
        NSString *releteid = [NSString stringWithFormat:@"%ld",(long)[[SpotTableHelper sharedInstance] getMaxIdOfRecords]];
        [self saveVoice:self.audioVO releteId:releteid releteTable:nil];
        [self saveImages:self.images releteId:releteid releteTable:nil];
        
    }else{
        [[SpotTableHelper sharedInstance] updateDataWithDictionary:dict];
        
        [[VoiceTableHelper sharedInstance] deleteDataByReleteTable:nil Releteid:tempArr[0]];
        [self saveVoice:self.audioVO releteId:tempArr[0] releteTable:nil];
        
        [[PictureTableHelper sharedInstance] deleteDataByReleteTable:nil Releteid:tempArr[0]];
        [self saveImages:self.images releteId:tempArr[0] releteTable:nil];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * 保存图片
 **/
-(void)saveImages:(NSArray *)images releteId:(NSString *)releteID releteTable:(NSString *)releteTable
{
    //保存图片
    for (int i = 0; i < images.count ; i++)
    {
        if ([images[i] isKindOfClass:[PictureVO class]])
        {
            PictureVO *v = (PictureVO*)images[i];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", v.name]];
            BOOL result = [v.imageData writeToFile: filePath atomically:YES]; // 写入本地沙盒
            //实例化一个NSDateFormatter对象
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            //设定时间格式,这里可以设置成自己需要的格式
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH-mm-ss"];
            //用[NSDate date]可以获取系统当前时间
            NSString *currentDate = [dateFormatter stringFromDate:[NSDate date]];
            if (result)
            {
                NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      v.name,@"photoName",
                                      currentDate,@"phototime",
                                      filePath,@"photoPath",
                                      releteID,@"releteid",
                                      nil];
                //保存数据库
                [[PictureTableHelper sharedInstance] insertDataWithDictionary:dict];
            }
        }
    }
}

/**
 * 获取图片
 **/
-(NSMutableArray *)getImagesWithReleteId:(NSString *)releteID releteTable:(NSString *)releteTable
{
    NSMutableArray *images = [[NSMutableArray alloc] init];
    NSMutableArray * pictureModes= [[PictureTableHelper sharedInstance] selectDataByReleteTable:releteTable Releteid:releteID];
    //循环添加图片
    for(PhotoModel* pic in pictureModes)
    {
        PictureVO *vo = [[PictureVO alloc] init];
        vo.name = pic.photoName;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", pic.photoName]];
        vo.imageData = [NSData dataWithContentsOfFile:filePath];
        [images addObject:vo];
    }
    return images;
}

/**
 *  保存声音
 **/
-(void)saveVoice:(AudioVO *)audioVO releteId:(NSString *)releteID releteTable:(NSString *)releteTable
{
    if (!audioVO.audioData||audioVO.audioData.length<=0) {
        NSLog(@"1223");
        return;
    }
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH-mm-ss"];
    //用[NSDate date]可以获取系统当前时间
    NSString *voiceTime = [dateFormatter stringFromDate:[NSDate date]];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3", audioVO.name]];
    
    BOOL result = [audioVO.audioData writeToFile: filePath atomically:YES]; // 写入本地沙盒
    if (result) {
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                              audioVO.name,@"voiceName",
                              voiceTime,@"voicetime",
                              filePath,@"voicePath",
                              @"voiceinfo",@"voiceinfo",
                              releteID,@"releteid",
                              nil];
        //保存数据库
        [[VoiceTableHelper sharedInstance] insertDataWithDictionary:dict];

    }
}

/**
 *  获取声音
 **/
-(AudioVO *)getVoiceWithReleteId:(NSString *)releteID releteTable:(NSString *)releteTable
{
    NSMutableArray * voiceModes= [[VoiceTableHelper sharedInstance] selectDataByReleteTable:releteTable Releteid:releteID];
    if (voiceModes.count>0) {
        VoiceModel *voiceModel = (VoiceModel *)voiceModes[0];
        NSData *voicedata = [NSData dataWithContentsOfFile:voiceModel.voicePath];
        self.audioVO.audioData = voicedata;
        self.audioVO.name = voiceModel.voiceName;
    }
    return self.audioVO;
 }


-(void)dealloc
{
    NSLog(@"SpotInfoViewController 释放");
}

@end
