//
//  SWYPhotoSetViewController.m
//  EQ_DisasterReport
//
//  Created by shi on 15/11/4.
//  Copyright © 2015年 董徐维. All rights reserved.
//
#define collectionViewInset 200
#import "SWYPhotoSetViewController.h"
#import "PhotoSetCell.h"
#import "SWYCollectDetailViewController.h"
#import "SWYNavigationBar.h"
#import "PhotoSetReusableHeadView.h"
#import "LoopImagesView.h"

@interface SWYPhotoSetViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate,NavigationBarDelegate,LoopImagesViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong)UICollectionView *photoCollectionView;
@property(nonatomic,strong)SWYNavigationBar *naviBar;
@property(nonatomic,strong)LoopImagesView *loopView;
@property(nonatomic,strong)NSMutableArray *dataProvider;
@end

@implementation SWYPhotoSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initPhotoCollectionView];
    [self initLoopImageView];
    [self initNaviBar];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark 初始化方法、setter和getter方法
/**
 *  初始化自定义导航栏
 */
-(void)initNaviBar
{
    self.naviBar = [[SWYNavigationBar alloc]initCustomNavigatinBar];
    self.naviBar.titleStr = @"标题";
    self.naviBar.delegate = self;
    [self.view addSubview:self.naviBar];
    
//    UISearchBar *searbar = [[UISearchBar alloc]init];
//    [searbar setSearchBarStyle:UISearchBarStyleMinimal];
    UITextField *searchTextField = [[UITextField alloc] init];
    searchTextField.delegate = self;
    searchTextField.returnKeyType = UIReturnKeyDone;
    searchTextField.borderStyle = UITextBorderStyleRoundedRect;
    searchTextField.textColor = [UIColor whiteColor];
    searchTextField.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    leftView.image = [UIImage imageNamed:@"search_icon"];
    searchTextField.leftViewMode = UITextFieldViewModeAlways;
    searchTextField.leftView = leftView;

    self.naviBar.titleView = searchTextField;
}

/**
 *  初始化集合视图
 */
-(void)initPhotoCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake((MTScreenW-2)/3, (MTScreenW-2)/3);
    flowLayout.minimumLineSpacing = 1;
    flowLayout.minimumInteritemSpacing = 1;
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 0, 5, 0);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.headerReferenceSize = CGSizeMake(MTScreenW,20);

    self.photoCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    self.photoCollectionView.delegate = self;
    self.photoCollectionView.dataSource = self;
    self.photoCollectionView.backgroundColor = [UIColor whiteColor];
    self.photoCollectionView.bounces = YES;
    self.photoCollectionView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.photoCollectionView];
    
    //注册 cell
    UINib *photoCellNib = [UINib nibWithNibName:@"PhotoSetCell" bundle:nil];
    [self.photoCollectionView registerNib:photoCellNib forCellWithReuseIdentifier:@"photoSetCell"];
    
    UINib *photoHeadView = [UINib nibWithNibName:@"PhotoSetReusableHeadView" bundle:nil];
    [self.photoCollectionView registerNib:photoHeadView forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"photoSetReusableHeadView"];
    
    //设置上下拉刷新
   // self.photoCollectionView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.photoCollectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    //[self.photoCollectionView.header beginRefreshing];
}

/**
 *  初始化轮播视图
 */
-(void)initLoopImageView
{
    self.photoCollectionView.contentInset = UIEdgeInsetsMake(collectionViewInset, 0, 0, 0);
    self.loopView = [[LoopImagesView alloc] initWithFrame:CGRectMake(0,-235, MTScreenW, 230)];
    self.loopView.imageArr = self.dataProvider;
    self.loopView.delegate = self;
    [self.photoCollectionView addSubview:self.loopView];
}

/**
 *  dataProvider的 getter 方法
 */
-(NSMutableArray*)dataProvider
{
    if (!_dataProvider) {
        _dataProvider = [[NSMutableArray alloc] initWithArray:@[@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg",@"5.jpg",@"6.jpg",@"7.jpg",@"8.jpg",@"9.jpg",@"10.jpg",@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg",@"5.jpg",@"6.jpg",@"7.jpg",@"8.jpg",@"9.jpg",@"10.jpg"]];
    }
    return _dataProvider;
}

#pragma mark 协议方法
#pragma mark UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataProvider.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *photoSetCellId = @"photoSetCell";
    PhotoSetCell *cell = [self.photoCollectionView dequeueReusableCellWithReuseIdentifier:photoSetCellId forIndexPath:indexPath];
    
    CGFloat imgvWidth = (MTScreenW-2)/3;
    UIImage *img = [UIImage imageNamed:self.dataProvider[indexPath.row]];
    cell.photoImageV.image = [img scaleImageToSize:CGSizeMake(imgvWidth, imgvWidth)];
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
     PhotoSetReusableHeadView *reusableV;
    if (kind == UICollectionElementKindSectionHeader)
    {
       reusableV = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"photoSetReusableHeadView" forIndexPath:indexPath];
        reusableV.backgroundColor = [UIColor redColor];
    }
    reusableV.titleLb.text = @"sdfsfsfsfsdfs";
    return reusableV;
}

#pragma mark UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SWYCollectDetailViewController *detailVC = [[SWYCollectDetailViewController alloc] init];
    detailVC.headImageName = self.dataProvider[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat alph;
    if (offsetY>0) {
        alph = offsetY/200;
        if (alph>=1.0) {
            alph = 1.0;
        }
    }else{
        alph = 0.0;
    }
    self.naviBar.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:alph];
    self.naviBar.titleView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:alph];
    
    if (alph <= 0.2) {
        self.naviBar.titleView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.1];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark NavigationBarDelegate
/**
 *  自定义导航条的协议方法
 */
-(void)navigationBar:(SWYNavigationBar *)naviBar didClickLeftBtn:(UIButton *)leftBtn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark LoopImagesViewDelegate
-(void)loopImagesView:(LoopImagesView *)loopImageView didImageClickedIndex:(NSInteger)index
{
    //NSLog(@"%d",index);
}

#pragma mark 事件方法
/**
 *  下拉刷新时加载数据
 */
-(void)loadNewData
{
    [self.photoCollectionView reloadData];
    [self.photoCollectionView.header endRefreshing];
}

/**
 *  下拉刷新时加载数据
 */
-(void)loadMoreData
{
    [self.photoCollectionView.footer endRefreshing];
    //[self.photoCollectionView.footer endRefreshingWithNoMoreData];
}

-(void)back
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
