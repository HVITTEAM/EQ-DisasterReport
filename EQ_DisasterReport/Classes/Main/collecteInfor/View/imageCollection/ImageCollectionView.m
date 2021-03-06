//
//  ImageCollectionView.m
//  EQCollect_HD
//
//  Created by 董徐维 on 15/9/17.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

//#define cellHeight 70
//#define cellWidth 70
#define kCellMargin 10;

#import "ImageCollectionView.h"
#import "ImgeCollectinViewFlowLayout.h"
#import "PictureVO.h"
#import "SQCollectionCell.h"
#import "SWYPhotoBrowserViewController.h"


@interface ImageCollectionView ()<SQCollectionCellDelegate>

@end

@implementation ImageCollectionView


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initCollectionView];
    
    self.isShowAddBtn = YES;
     _dataProvider =[[NSMutableArray alloc]init];
}

-(void)setDataProvider:(NSMutableArray *)dataProvider
{
    _dataProvider = dataProvider;
    [self setAddBtn];
    [self.collectionView reloadData];
//    //调整view高度
//    [self changeViewHeight];
}

/**
 *  初始化服务类别列表
 */
-(void)initCollectionView
{
    ImgeCollectinViewFlowLayout *flowlayout = [[ImgeCollectinViewFlowLayout alloc] init];
    //flowlayout.itemSize = CGSizeMake(cellWidth, cellHeight);
    
    self.collectionView.collectionViewLayout = flowlayout;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"SQCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"collectionCellID"];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.scrollEnabled = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}


/**
 *  设置是否要显示添加图片的按钮
 */
-(void)setAddBtn
{
    if (self.dataProvider.count<9) {
        self.isShowAddBtn = YES;
    }else self.isShowAddBtn = NO;
    
    if (!self.canEdit) {
        self.isShowAddBtn = NO;
    }
    //[self.collectionView reloadData];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.isShowAddBtn) {
      return  self.dataProvider.count+1;
    }
    return self.dataProvider.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kcellIdentifier = @"collectionCellID";
    //重用cell
    SQCollectionCell *cell = (SQCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kcellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.indexpath = indexPath;
    //在不显示新增图片按钮时，index 最大是self.dataProvider.count-1，如果等于self.dataProvider.count，说明当前显示的是新增图片按钮
    if (indexPath.row ==self.dataProvider.count) {
        cell.delButton.hidden = YES;
        cell.imgView.image = [UIImage imageNamed:@"icon_addpic"];
    }else{
        cell.delButton.hidden = NO;
        
        PictureVO *vo = self.dataProvider[indexPath.row];
        //创建缩略图来显示
        UIImage *img = [[UIImage alloc] initWithData:vo.imageData];
        CGFloat w = [[UIScreen mainScreen] bounds].size.width - 5 *kCellMargin;
        NSInteger cellWidth =floor(w/5);
        cell.imgView.image = [img scaleImageToSize:CGSizeMake(cellWidth,cellWidth)];

      }
    
    if (!self.canEdit) {
        cell.delButton.hidden = YES;
    }
    
    return cell;
}


#pragma mark --UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //将它所在的父视图控制器的根视图结束编辑，即退出键盘
    [self.parentVC.view endEditing:YES];
    
    NSInteger index = indexPath.row;
    //在不显示新增图片按钮时，index 最大是self.dataProvider.count-1，如果等于self.dataProvider.count，说明当前显示新增图片按钮，且点击了新增图片按钮
    if (index == self.dataProvider.count) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"请选择图片来源" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从手机相册选择", nil];
        [alert show];
    }else{
        NSLog(@"查看大图");
        //进图片浏览器查看大图
        NSMutableArray *images = [[NSMutableArray alloc] init];
        for(PictureVO* vo in self.dataProvider)
        {
            UIImage *img = [[UIImage alloc] initWithData:vo.imageData];
            [images addObject:img];
        }
        SWYPhotoBrowserViewController *browserVC = [[SWYPhotoBrowserViewController alloc] initPhotoBrowserWithImages:images currentIndex:indexPath.row];
        browserVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

        [self.parentVC presentViewController:browserVC animated:YES completion:^{
        }];
     }
}

#pragma mark --UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat w = [[UIScreen mainScreen] bounds].size.width - 5 *kCellMargin;
    NSInteger cellWidth =floor(w/4);
    NSLog(@"--------++++++++++++++++++++%d",(int)cellWidth);
    return CGSizeMake(cellWidth, cellWidth);
    
}

-(void)SQCollectionCell:(SQCollectionCell *)cell deletePhotoWithIndexpath:(NSIndexPath *)indexpath
{
    //如果不是新增按钮，点击就直接从数组中删除
    PictureVO *picvo = self.dataProvider[indexpath.row];
    [[PictureTableHelper sharedInstance] deleteImageByAttribute:@"photoName" value:picvo.name];
    [self.dataProvider removeObjectAtIndex:indexpath.row];
    [self setAddBtn];
    [self.collectionView reloadData];
    [self changeViewHeight];
}

#pragma mark -- 拍照选择模块
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
        [self shootPicturePrVideo];
    else if(buttonIndex==2)
        [self selectExistingPictureOrVideo];
}

/**从相机*/
-(void)shootPicturePrVideo
{
    [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];
}

/**从相册*/
-(void)selectExistingPictureOrVideo
{
    NSUInteger num = self.dataProvider.count;
    UzysAssetsPickerController *picker = [[UzysAssetsPickerController alloc] init];
    picker.delegate = self;
    picker.maximumNumberOfSelectionVideo = 0;
    picker.maximumNumberOfSelectionPhoto = num==0?9:9-num;
    [self.parentVC presentViewController:picker animated:YES completion:^{
    }];
}

-(void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType
{
    NSArray *mediatypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
    if([UIImagePickerController isSourceTypeAvailable:sourceType] &&[mediatypes count]>0)
    {
        NSArray *mediatypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.mediaTypes = mediatypes;
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = sourceType;
        NSString *requiredmediatype = (NSString *)kUTTypeImage;
        NSArray *arrmediatypes = [NSArray arrayWithObject:requiredmediatype];
        [picker setMediaTypes:arrmediatypes];
        [self.parentVC presentViewController:picker animated:YES completion:nil];
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误信息!" message:@"当前设备不支持拍摄功能" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
    }
}

#pragma 拍照模块
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData *data;
        data = UIImageJPEGRepresentation(image, 0.000005);//压缩图片
        //关闭相册界面
        [picker dismissViewControllerAnimated:NO completion:nil];
        PictureVO *imgVo = [[PictureVO alloc] init];
        imgVo.name = currentDateStr;
        imgVo.imageData = data;
        
        if (self.dataProvider.count < 10) {
            [self.dataProvider addObject:imgVo];
        }else{
            [[[UIAlertView alloc] initWithTitle:nil message:@"已达到最大可选张数" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil]  show];
        }
        [self setAddBtn];
        [self.collectionView reloadData];
        //调整view高度
        [self changeViewHeight];
    }
}

#pragma mark - UzysAssetsPickerControllerDelegate
- (void)UzysAssetsPickerController:(UzysAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if([[assets[0] valueForProperty:@"ALAssetPropertyType"] isEqualToString:@"ALAssetTypePhoto"]) //Photo
        {
            [assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                ALAsset *representation = obj;
                
                if (self.isExitThread) {
                    return ;
                }
                
                UIImage *img = [UIImage imageWithCGImage:representation.defaultRepresentation.fullResolutionImage
                                                   scale:representation.defaultRepresentation.scale
                                             orientation:(UIImageOrientation)representation.defaultRepresentation.orientation];
                //实例化一个NSDateFormatter对象
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                //设定时间格式,这里可以设置成自己需要的格式
                [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
                //用[NSDate date]可以获取系统当前时间
                NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
                
                NSData *data;
                data = UIImageJPEGRepresentation(img, 0.000005);//压缩图片
                PictureVO *imgVo = [[PictureVO alloc] init];
                imgVo.name = [currentDateStr stringByAppendingFormat:@"_%lu",(unsigned long)idx];
                imgVo.imageData = data;
                
                if (self.dataProvider.count < 9) {
                    [self.dataProvider addObject:imgVo];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self setAddBtn];
                    [self.collectionView reloadData];
                    //调整view高度
                    [self changeViewHeight];
                });
                
            }];
        }
    });
}


/**
 *  根据当前图片数调整view高度
 */
-(void)changeViewHeight
{
    //一行3张，高度为80,两行时高度为160,三行为240(把间隔已包含在内)
    CGFloat h = 90;
    
    if (self.changeHeightBlock) {
//        NSInteger cellNum = self.isShowAddBtn?self.dataProvider.count+1:self.dataProvider.count;
        NSInteger cellNum = self.dataProvider.count+1;
        if (cellNum<=3) {
            h = 90;
        }else if (cellNum<=6){
            h = 170;
        }else{
            h = 250;
        }
        self.changeHeightBlock(h,self.dataProvider);
    }
}

-(void)dealloc{
    NSLog(@"imageCollectionView dealloc");
}
@end
