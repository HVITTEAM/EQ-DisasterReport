//
//  MenuView.m
//  EQ_DisasterReport
//
//  Created by shi on 15/12/7.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "MenuView.h"
#import "MenuContentView.h"
#define margin 10
#define contentViewWidth 110
#define itemHeight 40

@interface MenuView ()<MenuContentViewDelegate>

@property(strong,nonatomic)MenuContentView *contentView;

@property(assign,nonatomic)NSUInteger itemCount;

@end

@implementation MenuView

-(instancetype)initWithTitles:(NSArray *)titles titleIcons:(NSArray *)titleIcons
{
    self = [super init];
    if (self) {
        self.itemCount = titles.count;
        
        self.contentView = [[MenuContentView alloc] initWithTitles:titles titleIcons:titleIcons];
        self.contentView.delegate = self;
        [self addSubview:self.contentView];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
     self.contentView.frame = CGRectMake(self.bounds.size.width - contentViewWidth - margin,0, contentViewWidth,itemHeight * self.itemCount +20);
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self hideMenuView];
}

-(void)showMenuViewInView:(UIView *)view frame:(CGRect)frame
{
    self.frame = frame;
    [view addSubview:self];
}

-(void)hideMenuView
{
    [self removeFromSuperview];
}

-(void)menuContentView:(MenuContentView *)MenuContentView indexForItem:(NSInteger)idx
{
    NSLog(@"%d",(int)idx);
    if ([self.delegate respondsToSelector:@selector(menuView:indexForItem:)]) {
        [self.delegate menuView:self indexForItem:idx];
    }
    [self removeFromSuperview];
}
@end
