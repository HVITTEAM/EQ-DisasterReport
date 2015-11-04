//
//  SWYPhotoSetViewController.m
//  EQ_DisasterReport
//
//  Created by shi on 15/11/4.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "SWYPhotoSetViewController.h"
#import "PhotoSetCell.h"

@interface SWYPhotoSetViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic,strong)UICollectionView *photoCollectionView;
@property(nonatomic,strong)NSMutableArray *dataProvider;
@end

@implementation SWYPhotoSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initPhotoCollectionView];
    [self initNavigationBar];
}

#pragma mark 初始化方法、setter和getter方法
/**
 *  初始化导航栏
 */
-(void)initNavigationBar
{
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.title = @"照片墙";
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
}

/**
 *  初始化集合视图
 */
-(void)initPhotoCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake((MTScreenW-40)/3, (MTScreenW-40)/3);
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 9);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;

    self.photoCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    self.photoCollectionView.delegate = self;
    self.photoCollectionView.dataSource = self;
    self.photoCollectionView.backgroundColor = [UIColor whiteColor];
    self.photoCollectionView.bounces = YES;
    [self.view addSubview:self.photoCollectionView];
    self.photoCollectionView.contentSize = CGSizeMake(700, 2000);
    
    //注册 cell
    UINib *photoCellNib = [UINib nibWithNibName:@"PhotoSetCell" bundle:nil];
    [self.photoCollectionView registerNib:photoCellNib forCellWithReuseIdentifier:@"photoSetCell"];
    
    //设置上下拉刷新
    self.photoCollectionView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.photoCollectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.photoCollectionView.header beginRefreshing];
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
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataProvider.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *photoSetCellId = @"photoSetCell";
    PhotoSetCell *cell = [self.photoCollectionView dequeueReusableCellWithReuseIdentifier:photoSetCellId forIndexPath:indexPath];
    
    CGFloat imgvWidth = (MTScreenW-40)/3;
    UIImage *img = [UIImage imageNamed:self.dataProvider[indexPath.row]];
    cell.photoImageV.image = [img scaleImageToSize:CGSizeMake(imgvWidth, imgvWidth)];
    return cell;
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
