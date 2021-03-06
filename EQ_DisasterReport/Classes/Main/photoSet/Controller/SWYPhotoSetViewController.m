//
//  SWYPhotoSetViewController.m
//  EQ_DisasterReport
//
//  Created by shi on 15/11/4.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#define kHeadViewHeight 193
#define kNavBarHeight 64

#import "SWYPhotoSetViewController.h"
#import "PhotoSetCell.h"
#import "SWYCollectDetailViewController.h"
#import "PhotoSetHeadReusableView.h"
#import "PhotoinfoNTHelper.h"
#import "SWYRequestParams.h"
#import "PhotoSetModel.h"
#import "UIImageView+WebCache.h"
#import "NSObject+Extension.h"

@interface SWYPhotoSetViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITextFieldDelegate,SWYNetworkCallBackDelegate,SWYNetworkParamSourceDelegate,SWYNetworkReformerDelegate>

@property(nonatomic,strong)UICollectionView *photoCollectionView;

@property(nonatomic,strong)NSMutableArray *dataProvider;              //数据源

@property(nonatomic,strong)PhotoinfoNTHelper *photoinfoHelper;        //照片墙数据下载的接口对象

@property(nonatomic,strong)UIBarButtonItem *leftItem;

@property(nonatomic,strong)UIBarButtonItem *rightItem;

@property(nonatomic,strong)UITextField *searchTextField;              //搜索框

@property(nonatomic,strong)UIView *noImageView;                       //没有数据时显示

@end

@implementation SWYPhotoSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initPhotoCollectionView];
    
    [self initNaviBar];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

#pragma mark -- 初始化方法 --
/**
 *  初始化集合视图
 */
-(void)initPhotoCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 1;
    flowLayout.minimumInteritemSpacing = 1;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;

    self.photoCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    self.photoCollectionView.delegate = self;
    self.photoCollectionView.dataSource = self;
    self.photoCollectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.photoCollectionView];
    
    //添加无数据提示视图
    [self.photoCollectionView addSubview:self.noImageView];
    self.noImageView.hidden = YES;
    
    //注册 cell
    UINib *photoCellNib = [UINib nibWithNibName:@"PhotoSetCell" bundle:nil];
    [self.photoCollectionView registerNib:photoCellNib forCellWithReuseIdentifier:@"photoSetCell"];
    
    //注册SupplementaryView
    UINib *headReusableViewNib = [UINib nibWithNibName:@"PhotoSetHeadReusableView" bundle:nil];
    [self.photoCollectionView registerNib:headReusableViewNib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"photoSetHeadReusableView"];
    
    //设置上下拉刷新
    self.photoCollectionView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    self.photoCollectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    [self.photoCollectionView.header beginRefreshing];
 }

/**
 *  初始化导航条
 */
-(void)initNaviBar
{
    self.navigationItem.title = @"照片墙";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    self.leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_icon_black"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    self.rightItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style: UIBarButtonItemStylePlain target:self action:@selector(cancelSearch)];
    
    self.searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(7, 7, MTScreenW - 100, 30)];
    self.searchTextField.delegate = self;
    self.searchTextField.returnKeyType = UIReturnKeyDone;
    self.searchTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.searchTextField.textColor = [UIColor lightGrayColor];
    self.searchTextField.font = [UIFont systemFontOfSize:13];
    self.searchTextField.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1];
    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    leftView.image = [UIImage imageNamed:@"search_icon"];
    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
    self.searchTextField.leftView = leftView;
    self.searchTextField.placeholder = @"搜索地点";
    self.navigationItem.titleView = self.searchTextField;
}

#pragma mark -- setter和getter方法 --
/**
 *  dataProvider的 getter 方法
 */
-(NSMutableArray*)dataProvider
{
    if (!_dataProvider) {
        _dataProvider = [[NSMutableArray alloc] init];
    }
    return _dataProvider;
}

/**
 *  photoinfoHelper的 getter 方法
 */
-(PhotoinfoNTHelper *)photoinfoHelper
{
    if (!_photoinfoHelper) {
        _photoinfoHelper = [[PhotoinfoNTHelper alloc] init];
        _photoinfoHelper.callBackDelegate = self;
        _photoinfoHelper.paramSource = self;
    }
    return _photoinfoHelper;
}

-(UIView *)noImageView
{
    if (!_noImageView) {
        
        CGRect bgViewFrame = CGRectMake(
                                        0,
                                        kHeadViewHeight + 15,
                                        MTScreenW,
                                        MTViewH - (kHeadViewHeight + 20)
                                        );
        
        UIView *bgView = [[UIView alloc] initWithFrame:bgViewFrame];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, 80)];
        imgView.image = [UIImage imageNamed:@"no_image_icon"];
        imgView.contentMode = UIViewContentModeCenter;
        [bgView addSubview:imgView];
        
        UILabel *promptLb = [[UILabel alloc]init];
        promptLb.textAlignment = NSTextAlignmentCenter;
        promptLb.textColor = [UIColor lightGrayColor];
        promptLb.font = [UIFont systemFontOfSize:15];
        promptLb.numberOfLines = 0;
        
        [bgView addSubview:promptLb];
        
        promptLb.text = @"抱歉!没有相关图片\n 您可以稍后再刷新试试";
        CGFloat promptTextHeight = [promptLb.text boundingRectWithSize:CGSizeMake(MTScreenW, MAXFLOAT)
                                                               options:NSStringDrawingUsesLineFragmentOrigin
                                                            attributes:@{NSFontAttributeName:promptLb.font}
                                                               context:nil].size.height;
        
        promptLb.frame = CGRectMake(0, CGRectGetMaxY(imgView.frame)+15, MTScreenW, promptTextHeight);

        _noImageView = bgView;

    }
    return _noImageView;
}

#pragma mark 协议方法
#pragma mark UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataProvider.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *photoSetCellId = @"photoSetCell";
    PhotoSetCell *cell = [self.photoCollectionView dequeueReusableCellWithReuseIdentifier:photoSetCellId forIndexPath:indexPath];
    
    PhotoSetModel *model = self.dataProvider[indexPath.row];
    cell.addressLb.text = model.address;
    
    NSString *encodeUrlStr = [model.thumbpath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [cell.photoImageV sd_setImageWithURL:[NSURL URLWithString:encodeUrlStr] placeholderImage:[UIImage imageNamed:@"placeholder_image"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && [kind isEqualToString:UICollectionElementKindSectionHeader]) {
        static NSString *photoSetHeadReusableViewId = @"photoSetHeadReusableView";
        PhotoSetHeadReusableView *headView = [self.photoCollectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:photoSetHeadReusableViewId forIndexPath:indexPath];
        headView.headImageView.image = [UIImage imageNamed:@"headViewimage"];
        return headView;
    }
    return nil;
}

#pragma mark UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SWYCollectDetailViewController *detailVC = [[SWYCollectDetailViewController alloc] init];
    detailVC.photoInfor = self.dataProvider[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(1, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((MTScreenW-2)/3, (MTScreenW-2)/3);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeMake(0, kHeadViewHeight);
    }
    return CGSizeMake(0,0);
}

#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    [self.photoinfoHelper cancelAllRequests];
    [self loadNewData];
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.navigationItem.rightBarButtonItem = self.rightItem;
    [UIView animateWithDuration:0.3f animations:^{
        self.navigationItem.leftBarButtonItem = nil;
        
        CGRect titleFrame = self.navigationItem.titleView.frame;
        self.navigationItem.titleView.frame = CGRectMake(20, titleFrame.origin.y, titleFrame.size.width + 30, titleFrame.size.height);
    } completion:^(BOOL finished) {
        [self.navigationItem setRightBarButtonItem:self.rightItem animated:YES];
    }];
}

#pragma mark SWYNetworkParamSourceDelegate
- (SWYRequestParams *)paramsForRequest:(SWYBaseNetworkHelper *)networkHelper
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                @"customtag":@"pagination",
                                                                                @"page":[NSString stringWithFormat:@"%d",(int)self.photoinfoHelper.nextPageNumber],
                                                                                @"rows":[NSString stringWithFormat:@"%d",(int)self.photoinfoHelper.numbersOfEachPage],
                                                                                
                                                                                //                           @"keyword":
                                                                                }];
    
    NSString *searchText = self.searchTextField.text;
    if (searchText !=nil && searchText.length > 0) {
        [dict setObject:searchText forKey:@"keyword"];
    }
    
    SWYRequestParams *params = [[SWYRequestParams alloc] initWithParams:[dict mutableCopy] files:nil];
    
    return params;
}

#pragma mark SWYNetworkCallBackDelegate
- (void)requestDidSuccess:(SWYBaseNetworkHelper *)networkHelper
{
    NSMutableArray *newDataArr = [networkHelper fetchDataWithReformer:self];
    if (self.photoinfoHelper.isFirstPage) {
        self.dataProvider = newDataArr;
    }else{
        [self.dataProvider addObjectsFromArray:newDataArr];
    }
    
    [self.photoCollectionView reloadData];
    
    //结束头部刷新
    [self.photoCollectionView.header endRefreshing];

    //结束底部刷新
    if (self.photoinfoHelper.isFinshedAllLoad) {
        [self.photoCollectionView.footer endRefreshingWithNoMoreData];
    }else{
        [self.photoCollectionView.footer endRefreshing];
    }
    
    if (self.dataProvider.count == 0) {
        self.noImageView.hidden = NO;
    }else{
        self.noImageView.hidden = YES;
    }
    
    NSLog(@"SWYPhotoSetViewController  requestDidSuccess%@",self.dataProvider);
}

- (void)requestDidFailed:(SWYBaseNetworkHelper *)networkHelper
{
    [self.photoCollectionView.header endRefreshing];
    [self.photoCollectionView.footer endRefreshing];
    
    if (self.dataProvider.count == 0) {
        self.noImageView.hidden = NO;
    }else{
        self.noImageView.hidden = YES;
    }
    NSLog(@"失败");
    
}

#pragma mark SWYNetworkReformerDelegate
//对下载的原始数据进行重组，生成可直接使用的数据
- (id)networkHelper:(SWYBaseNetworkHelper *)networkHelper reformData:(id)data
{
    NSMutableArray *photoSetArr = [[NSMutableArray alloc] init];
    if ([data isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dataDict = (NSDictionary *)data;
        NSArray *tempArr = dataDict[@"rows"];
        for (NSDictionary *dict in tempArr) {
            PhotoSetModel *model = [[PhotoSetModel alloc] init];
            
            model.photopath = [NSString stringWithFormat:@"%@%@",URL_base,
                                                           [dict[@"photopath"] validateDataIsNull]];
            
            model.thumbpath = [NSString stringWithFormat:@"%@%@",URL_base,
                                                           [dict[@"thumbpath"]validateDataIsNull]];
            
            model.pointid = [dict[@"pointid"] validateDataIsNull];
            model.address = [dict[@"address"] validateDataIsNull];
            
            [photoSetArr addObject:model];
        }
    }
    NSLog(@"SWYPhotoSetViewController  SWYNetworkReformerDelegate %@",data);
    return photoSetArr;
}

#pragma mark 事件方法
/**
 *  下拉刷新时加载数据
 */
-(void)loadNewData
{
    //重置下载接口对象的状态
    [self.photoinfoHelper resetState];
    //开始发送请求
    [self.photoinfoHelper startSendRequest];
}

/**
 *  新一页数据
 */
-(void)loadMoreData
{
    [self.photoinfoHelper startSendRequestForNextPage];
}

-(void)cancelSearch
{
    [self.searchTextField resignFirstResponder];
    self.searchTextField.text = nil;
    
    [self.navigationItem setLeftBarButtonItem:self.leftItem animated:YES];
    [self.navigationItem setRightBarButtonItem:nil animated:YES];
    
    CGRect titleFrame = self.navigationItem.titleView.frame;
    self.navigationItem.titleView.frame = CGRectMake(0, titleFrame.origin.y, titleFrame.size.width - 30, titleFrame.size.height);
    
    [self.photoinfoHelper cancelAllRequests];
    [self loadNewData];
}

-(void)back
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)dealloc
{
    [self.photoinfoHelper cancelAllRequests];
    NSLog(@"SWYPhotoSetViewController 释放");
}

@end
