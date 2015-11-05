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
    [self addSubview:self.rightBtn];

    //导航条的标题
    self.titleLb = [[ UILabel alloc] init];
    [self addSubview:self.titleLb];
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.01];
}

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
}

- (void)leftBtnClicked:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(navigationBar:didClickLeftBtn:)]) {
        [self.delegate navigationBar:self didClickLeftBtn:self.leftBtn];
    }
}

- (void)rightBtnClicked:(UIButton *)sender
{
    
}

@end
