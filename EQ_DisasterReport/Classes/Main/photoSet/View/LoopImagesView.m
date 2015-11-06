//
//  LoopImagesView.m
//  EQ_DisasterReport
//
//  Created by shi on 15/11/6.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "LoopImagesView.h"


@interface LoopImagesView ()<UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView *imageScrollView; //放置图片的 UIScrollview
@property(nonatomic,strong)UIPageControl *pageContorl;  //指示器
@property(nonatomic,strong)NSTimer *timer;            //定时器

@end

@implementation LoopImagesView
-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

/**
 *  初始化子视图
 */
-(void)initSubViews
{
    //创建 UIScrollview
    self.imageScrollView = [[UIScrollView alloc] init];
    self.imageScrollView.scrollEnabled = YES;
    self.imageScrollView.pagingEnabled = YES;
    self.imageScrollView.showsHorizontalScrollIndicator = NO;
    self.imageScrollView.delegate = self;
    [self addSubview:self.imageScrollView];
    
    //创建指示器
    self.pageContorl = [[UIPageControl alloc] init];
    self.pageContorl.currentPage = 0 ;
    self.pageContorl.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    self.pageContorl.userInteractionEnabled = NO;
    [self addSubview:self.pageContorl];
    
    //添加定时器
    [self addtimer];
}

/**
 *  设置图片数据，并根据图片数量创建相应的imageView
 */
-(void)setImageArr:(NSArray *)imageArr
{
    _imageArr = imageArr;
    if (!_imageArr) {
        _imageArr = [[NSArray alloc] init];
    }
    //循环创建imageView
    for (int i=0;i<imageArr.count; i++) {
        UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(i*self.width, 0, self.width, self.height)];
        imgv.image = [UIImage imageNamed:imageArr[i]];
        //添加手势
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)];
        [imgv addGestureRecognizer:tapRecognizer];
        imgv.userInteractionEnabled = YES;

        [self.imageScrollView addSubview:imgv];
    }
    
    self.imageScrollView.contentSize = CGSizeMake(self.width*_imageArr.count, self.height);
    self.pageContorl.numberOfPages = _imageArr.count;
}

-(void)layoutSubviews
{
    self.imageScrollView.frame = self.bounds;
    self.pageContorl.frame = CGRectMake(0, self.height-20, self.width, 20);
}

#pragma mark  UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSUInteger pageNum = scrollView.contentOffset.x/scrollView.width+0.5;
    self.pageContorl.currentPage = pageNum;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removetimer];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addtimer];
}

/**
 * 添加定时器
 */
-(void)addtimer
{
   self.timer = [NSTimer timerWithTimeInterval:5.0f target:self selector:@selector(loadNextPage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

/**
 * 移除定时器
 */
-(void)removetimer
{
    [self.timer invalidate];
}

/**
 * 定时器自动调用方法，显示下一张图片
 */
-(void)loadNextPage
{
    NSUInteger nextpageNum;
    if (self.pageContorl.currentPage==self.imageArr.count-1) {
        nextpageNum = 0;
        [self.imageScrollView setContentOffset:CGPointMake(nextpageNum*self.imageScrollView.width, 0) animated:NO];
    }else {
        nextpageNum = self.pageContorl.currentPage+1;
        [self.imageScrollView setContentOffset:CGPointMake(nextpageNum*self.imageScrollView.width, 0) animated:YES];
    }
}

/**
 * 点击图片时回调并传加图片所属序号
 */
-(void)clickImage:(UITapGestureRecognizer *)tapRecognizer
{
    if ([self.delegate respondsToSelector:@selector(loopImagesView:didImageClickedIndex:)]){
        [self.delegate loopImagesView:self didImageClickedIndex:self.pageContorl.currentPage];
    }
}

@end
