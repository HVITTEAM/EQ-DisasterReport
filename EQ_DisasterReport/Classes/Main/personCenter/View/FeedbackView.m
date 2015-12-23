//
//  FeedbackView.m
//  EQ_DisasterReport
//
//  Created by shi on 15/11/21.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "FeedbackView.h"

#define textViewHeight 150
#define textViewMargin 30
#define naviHeight 64
#define btnWidth 60
#define btnHeight 30

@interface FeedbackView ()

@property(strong,nonatomic)UITextView *contentTextView;

@property(strong,nonatomic)UIView *fatherView;          //当前 view 的父视图

@property(strong,nonatomic)UIView *naviView;            //导航视图

@property(strong,nonatomic)UILabel *titleLable;         //导航视图的标题

@property(strong,nonatomic)UIButton *backBtn;           //导航视图的返回按钮

@property(strong,nonatomic)UIButton *sendBtn;           //导航视图的发送按钮

@end


@implementation FeedbackView

-(instancetype)init
{
    if (self = [super init]) {
        [self initView];
    }
    return self;
}

#pragma mark -- 初始化子控件方法 --
/**
 *  初始化视图
 */
-(void)initView
{
    self. backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.frame = CGRectMake(0, 0, MTScreenW, MTScreenH);
    self.userInteractionEnabled = YES;
    
    self.contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(textViewMargin, naviHeight - textViewHeight, MTScreenW-2*textViewMargin, textViewHeight)];
    self.contentTextView.layer.cornerRadius = 6.0f;
    self.contentTextView.layer.masksToBounds = YES;
    [self addSubview:self.contentTextView];
    
    self.naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, naviHeight)];
    self.naviView.backgroundColor = [UIColor colorWithRed:45/255.0 green:45/255.0 blue:45/255.0 alpha:1.0];
    [self addSubview:self.naviView];
    
    self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 32, self.naviView.width, 20)];
    self.titleLable.font = [UIFont systemFontOfSize:16];
    self.titleLable.textColor = [UIColor whiteColor];
    self.titleLable.textAlignment = NSTextAlignmentCenter;
    self.titleLable.text = @"发送返馈";
    [self.naviView addSubview:self.titleLable];
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.frame = CGRectMake(10,27, btnWidth, btnHeight);
    [self.backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [self.backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.backBtn.backgroundColor = [UIColor colorWithRed:70/255.0 green:70/255.0 blue:70/255.0 alpha:1.0];
    self.backBtn.layer.cornerRadius = 7.0f;
    self.backBtn.layer.masksToBounds = YES;
    [self.backBtn addTarget:self action:@selector(bakcBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.naviView addSubview:self.backBtn];
    
    self.sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sendBtn.frame = CGRectMake( MTScreenW-60-10,27, btnWidth, btnHeight);
    [self.sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [self.sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.sendBtn.titleLabel.textColor = [UIColor whiteColor];
    self.sendBtn.backgroundColor = [UIColor colorWithRed:70/255.0 green:70/255.0 blue:70/255.0 alpha:1.0];
    self.sendBtn.layer.cornerRadius = 7.0f;
    self.sendBtn.layer.masksToBounds = YES;
    [self.sendBtn addTarget:self action:@selector(sendBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.naviView addSubview:self.sendBtn];
}

#pragma mark -- 事件方法 --
//返回按钮被点击
-(void)bakcBtnClicked:(UIButton *)sender
{
    [self hideView];
}

//发送按钮被点击
-(void)sendBtnClicked:(UIButton *)sender
{
    [self hideView];
}

//背景 View 被点击
-(void)backgroundClicked:(UIView *)sender
{
    [self hideView];
}

/**
 *  显示视图
 */
-(void)showViewtoFatherView:(UIView *)fatherView
{
    self.fatherView = fatherView;
    [self.fatherView addSubview:self];
    [self.contentTextView becomeFirstResponder];
    [UIView animateWithDuration:0.3f animations:^{
        CGRect frame = self.contentTextView.frame;
        frame.origin.y = frame.origin.y + self.contentTextView.frame.size.height +8;
        self.contentTextView.frame = frame;
    } completion:^(BOOL finished) {

    }];
}

/**
 *  隐藏视图
 */
-(void)hideView
{
    [UIView animateWithDuration:0.3f animations:^{
        
        CGRect frame = self.contentTextView.frame;
        frame.origin.y = frame.origin.y - self.contentTextView.frame.size.height - 8;
        self.contentTextView.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.fatherView = nil;
    }];
}

@end
