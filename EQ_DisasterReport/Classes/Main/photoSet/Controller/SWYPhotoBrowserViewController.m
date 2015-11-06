//
//  SWYPhotoBrowserViewController.m
//  EQ_DisasterReport
//
//  Created by shi on 15/11/5.
//  Copyright © 2015年 董徐维. All rights reserved.
//

typedef NS_ENUM(NSInteger, movingDirection) {
    movingDirectionNone,     // 不移动
    movingDirectionRight,    // 右移
    movingDirectionleft      // 左移
};

#import "SWYPhotoBrowserViewController.h"

@interface SWYPhotoBrowserViewController ()<UIScrollViewDelegate>

@property(nonatomic,strong)UIScrollView *bkScrollView;         //背景scrollView
@property(nonatomic,strong)UIScrollView *leftScrollView;       //左侧scrollView
@property(nonatomic,strong)UIScrollView *currentScrollView;    //中间scrollView
@property(nonatomic,strong)UIScrollView *rightScrollView;      //右侧scrollView
@property(nonatomic,strong)UIImageView *leftImageView;         //左侧scrollView上的imageView
@property(nonatomic,strong)UIImageView *currentImageView;      //中间scrollView上的imageView
@property(nonatomic,strong)UIImageView *rightImageView;        //右侧scrollView上的imageView

@property(nonatomic,assign)BOOL isDoubleTapBigger;      //双击时是放大还是还原图片大小

@end

@implementation SWYPhotoBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initScrollView];
    [self initGestureRecognizer];
    [self changeImageWithMovingDirection:movingDirectionNone];
    
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.bkScrollView.frame = self.view.bounds;
    
    CGFloat bkWidth = self.bkScrollView.width;
    CGFloat bkHeight = self.bkScrollView.height;
    
    self.leftScrollView.frame = CGRectMake(0, 0, bkWidth, bkHeight);
    self.currentScrollView.frame = CGRectMake(bkWidth, 0, bkWidth, bkHeight);
    self.rightScrollView.frame = CGRectMake(2*bkWidth, 0, bkWidth, bkHeight);
    
    self.leftImageView.frame = self.leftScrollView.bounds;
    self.currentImageView.frame = self.currentScrollView.bounds;
    self.rightImageView.frame = self.rightScrollView.bounds;
}

#pragma mark 初始化方法、setter和getter方法
/**
 *  初始化ScrollView
 */
-(void)initScrollView
{
    self.bkScrollView = [[UIScrollView alloc] init];
    self.bkScrollView.contentSize = CGSizeMake(3*MTScreenW, MTScreenH);
    self.bkScrollView.pagingEnabled = YES;
    self.bkScrollView.delegate = self;
    self.bkScrollView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.bkScrollView];
    
    self.leftScrollView = [[UIScrollView alloc] init];
    self.leftScrollView.delegate = self;
    self.leftScrollView.minimumZoomScale=1;
    self.leftScrollView.maximumZoomScale=2;
    self.leftImageView = [[UIImageView alloc] init];
    self.leftImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.leftScrollView addSubview:self.leftImageView];
    [self.bkScrollView addSubview:self.leftScrollView];
    
    self.currentScrollView = [[UIScrollView alloc] init];
    self.currentScrollView.delegate = self;
    self.currentScrollView.minimumZoomScale=1;
    self.currentScrollView.maximumZoomScale=2;
    self.currentImageView = [[UIImageView alloc] init];
    self.currentImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.currentScrollView addSubview:self.currentImageView];
    [self.bkScrollView addSubview:self.currentScrollView];
    
    self.rightScrollView = [[UIScrollView alloc] init];
    self.rightScrollView.delegate = self;
    self.rightScrollView.minimumZoomScale=1;
    self.rightScrollView.maximumZoomScale=2;
    self.rightImageView = [[UIImageView alloc] init];
    self.rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.rightScrollView addSubview:self.rightImageView];
    [self.bkScrollView addSubview:self.rightScrollView];
    
}

/**
 *  初始化手势
 */
-(void)initGestureRecognizer
{
    //单击手势
    UITapGestureRecognizer *sigleGestureRe = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
    sigleGestureRe.numberOfTouchesRequired = 1;
    sigleGestureRe.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:sigleGestureRe];
    
    //双击手势
    UITapGestureRecognizer *doubleGestureRe = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scaleImage:)];
    doubleGestureRe.numberOfTouchesRequired = 1;
    doubleGestureRe.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleGestureRe];
    [sigleGestureRe requireGestureRecognizerToFail:doubleGestureRe];
    
    //双击是否放大还是还原
    self.isDoubleTapBigger = YES;
    
}

#pragma mark 协议方法
#pragma mark  UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.bkScrollView) {
        if (scrollView.contentOffset.x<=0 ) {
            //如果小于等于0表示图片向右侧移动
            [self changeImageWithMovingDirection:movingDirectionRight];
        }else if (scrollView.contentOffset.x>=2*MTScreenW){
            //如果小于等于0表示图片向左侧移动
            [self changeImageWithMovingDirection:movingDirectionleft];
        }
    }
}

/**
 *  确定要放大的view
 */
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.currentImageView;
}

/**
 *  根据滚动方向重新设置图片
 */
-(void)changeImageWithMovingDirection:(movingDirection)direction
{
    //重新设置图片时缩放比例复原
    if (self.currentScrollView.zoomScale !=1.0) {
        self.currentScrollView.zoomScale = 1.0;
    }
    
    NSInteger imgCount = self.imageNames.count;
    
    //确定当前要显示的图片的index,
    switch (direction) {
        case movingDirectionRight:
            self.currentIndex = (self.currentIndex -1+imgCount)%imgCount;   //将左侧的图片作为当前图片
            break;
        case movingDirectionleft:
            self.currentIndex = (self.currentIndex+1)%imgCount;            //将右侧图片作为当前图片
            break;
        case movingDirectionNone:
            break;
    }
    //根据当前图片计算左侧和右侧图片。
    NSInteger leftIndex = (self.currentIndex -1+imgCount)%imgCount;
    NSInteger rigthIndex = (self.currentIndex+1)%imgCount;
    
    NSLog(@"l:%d  c:%d  r:%d",leftIndex,self.currentIndex,rigthIndex);
    
    //设置图片
    self.leftImageView.image = [UIImage imageNamed:self.imageNames[leftIndex]];
    self.currentImageView.image = [UIImage imageNamed:self.imageNames[self.currentIndex]];
    self.rightImageView.image = [UIImage imageNamed:self.imageNames[rigthIndex]];
    
    //将currentScrollView这个视图显示在屏幕上
    self.bkScrollView.contentOffset = CGPointMake(MTScreenW, 0);
    
    self.isDoubleTapBigger = YES;
}

/**
 *  双击手势时调用，来放大或缩小图片
 */
-(void)scaleImage:(UITapGestureRecognizer *)gestureRecognizer
{
    CGFloat newscale = 1.9;

    CGRect zoomRect = [self zoomRectForScale:newscale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view] andScrollView:self.currentScrollView];
    
    if (self.isDoubleTapBigger == YES)  {
        
        [self.currentScrollView zoomToRect:zoomRect animated:YES];
        
    }else {
        
        [self.currentScrollView zoomToRect:self.currentScrollView.frame animated:YES];
    }
    self.isDoubleTapBigger = !self.isDoubleTapBigger;

}

/**
 *  缩放大小获取方法，将点击的点作为中心
 */
- (CGRect)zoomRectForScale:(CGFloat)newscale withCenter:(CGPoint)center andScrollView:(UIScrollView *)scrollV{
    
    CGRect zoomRect = CGRectZero;
    //计算大小
    zoomRect.size.height = scrollV.frame.size.height / newscale;
    zoomRect.size.width = scrollV.frame.size.width  / newscale;
    //计算原点坐标
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);

    return zoomRect;
    
}

-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)dealloc
{
    NSLog(@"SWYPhotoBrowserViewController 释放");
}

@end
