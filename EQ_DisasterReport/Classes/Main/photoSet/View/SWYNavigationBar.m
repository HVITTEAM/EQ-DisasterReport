//
//  SWYNavigationBar.m
//  EQ_DisasterReport
//
//  Created by shi on 15/11/5.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "SWYNavigationBar.h"

@interface SWYNavigationBar()
@property(nonatomic,strong)UIButton *leftBtn;
@property(nonatomic,strong)UIButton *rightBtn;
@property(nonatomic,strong)UILabel *titleLb;
@end

@implementation SWYNavigationBar

-(instancetype)initCustomNavigatinBar
{
    if (self = [super init]) {
        [self initNavigatinBar];
    }
    return self;
}

/**
 *  初始化导航条
 */
-(void)initNavigatinBar
{
    //添加返回按钮
    self.leftBtn = [[UIButton alloc] init];
    [self.leftBtn setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    [self.leftBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.leftBtn];
    //添加分享按钮
    self.rightBtn = [[UIButton alloc] init];
    [self.rightBtn setImage:[UIImage imageNamed:@"share_icon"] forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    //[self addSubview:self.rightBtn];

    //导航条的标题
    self.titleLb = [[ UILabel alloc] init];
    self.titleLb.textColor = [UIColor whiteColor];
    self.titleLb.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLb];
    
    self.backgroundColor = [UIColor clearColor];
    self.clearsContextBeforeDrawing = YES;
}

/**
 *  布局子视图
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.frame = CGRectMake(0, 0, MTScreenW, 64);
    
    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    
    self.leftBtn.frame = CGRectMake(10, 27, 25, 25);
    self.rightBtn.frame = CGRectMake(w - 34, 31, 24, 18);
    
    CGFloat titleW = w * 0.7;
    CGFloat titleX = (w - titleW) / 2;
    self.titleLb.frame = CGRectMake(titleX, h * 0.25, titleW, h * 0.8);
    
    if (self.titleView) {
        CGFloat titleW = self.width * 0.7;
        CGFloat titleX = (self.width - titleW) / 2;
        self.titleView.frame = CGRectMake(titleX, self.height* 0.4, titleW, self.height * 0.5);
    }
}

/**
 *  重新绘制视图
 */
-(void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    //创建颜色
    CGFloat colors[] =
    {
        0 , 0 , 0 , 0.5,
        0 , 0 , 0 , 0.2,
        0 , 0 , 0 , 0,
    };
    //创建位置
    CGFloat locations[] = {0.0,0.5,1.0};
    //创建渐变对象
    CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, colors,locations, sizeof(colors)/(sizeof(colors[0])*4));
    CGColorSpaceRelease(rgb);
    CGPoint start = CGPointMake(0,0);
    CGPoint end =  CGPointMake(0,self.height);
    
    CGContextDrawLinearGradient(ctx, gradient, start,end,0);
    CGGradientRelease(gradient);
}

/**
 *  设置标题
 */
-(void)setTitleStr:(NSString *)titleStr
{
    self.titleLb.text = titleStr;
}

/**
 *  设置标题view
 */
-(void)setTitleView:(UIView *)titleView
{
    if (!titleView) {
        self.titleLb.hidden = NO;
        return;
    }
    _titleView = titleView;
    self.titleLb.hidden = YES;
    [self addSubview:titleView];
}

/**
 *  左侧按钮点击调用
 */
- (void)leftBtnClicked:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(navigationBar:didClickLeftBtn:)]) {
        [self.delegate navigationBar:self didClickLeftBtn:self.leftBtn];
    }
}

/**
 *  右侧按钮点击调用
 */
- (void)rightBtnClicked:(UIButton *)sender
{
    
}




@end
