//
//  SWYMapTypeSelectView.m
//  EQ_DisasterReport
//
//  Created by shi on 15/11/3.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "SWYMapTypeSelectView.h"
#define kMargin 20

@implementation SWYMapTypeSelectView
{
    CGFloat imgwidth;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self initMapTypeView];
    }
    
    return self;
}

- (void)initMapTypeView
{
    self.bkView = [UIButton buttonWithType:UIButtonTypeCustom];
    self.bkView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
    [self.bkView addTarget:self action:@selector(removeMapTypeView) forControlEvents:UIControlEventTouchUpInside];
    
    for (int i = 0; i<3; i++) {
        UIImageView *imgv = [[UIImageView alloc] init];
        imgv.layer.cornerRadius = 7;
        imgv.layer.masksToBounds = YES;
        imgv.userInteractionEnabled = YES;
        imgv.tag = 30+i;
        UITapGestureRecognizer *gestureRe = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectType:)];
        gestureRe.numberOfTapsRequired = 1;
        gestureRe.numberOfTouchesRequired = 1;
        [imgv addGestureRecognizer:gestureRe];
        
        UILabel *lb = [[UILabel alloc] init];
        lb.textAlignment = NSTextAlignmentCenter;
        lb.font = [UIFont systemFontOfSize:13];
        lb.tag = 40+i;
        
        if (i==0) {
            imgv.image = [UIImage imageNamed:@"standardimage"];
            lb.text = @"标准2D图";
        }else if (i==1){
            imgv.image = [UIImage imageNamed:@"satelliteImage"];
            lb.text = @"卫星图";
        }else{
            imgv.image = [UIImage imageNamed:@"standard_night_image"];
            lb.text = @"夜景图";
        }
        
        [self addSubview:imgv];
        [self addSubview:lb];
    }
    
    self.backgroundColor = [UIColor whiteColor];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    imgwidth = (self.width - 4*kMargin)/3;
    for (int i = 0; i<3; i++) {
        UIImageView *imgv = (UIImageView *)[self viewWithTag:30+i];
        UILabel *lb = (UILabel *)[self viewWithTag:40+i];
        
        imgv.frame = CGRectMake(kMargin+i*(imgwidth+kMargin), kMargin, imgwidth, imgwidth*0.75);
        lb.frame = CGRectMake(kMargin+i*(imgwidth+kMargin), CGRectGetMaxY(imgv.frame), imgwidth, 30);
    }
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];

}

- (void)showMapTypeViewToView:(UIView *)superView position:(CGPoint)loc
{
    CGFloat width = superView.bounds.size.width-20;
    CGFloat height = (width-4*kMargin)/3 *0.75+2*kMargin+20;
    
    self.bkView.frame = superView.bounds;
    [superView addSubview:self.bkView];
    
    self.frame = CGRectMake(10, loc.y, width, height);
    [superView addSubview:self];
//        self.layer.anchorPoint = CGPointMake(1, 0);
    CGAffineTransform transform = CGAffineTransformMakeScale(0, 0);
    transform = CGAffineTransformTranslate(transform,-(width-10), 0);
    self.transform = transform;

    [UIView animateWithDuration:0.5 animations:^{
        self.transform = CGAffineTransformIdentity;
    }];
}

-(void)removeMapTypeView
{
    [self.bkView removeFromSuperview];
    [self removeFromSuperview];
}


-(void)selectType:(UITapGestureRecognizer *)gestureRecongnizer
{
    UIView *tappedView = [gestureRecongnizer view];
    if ([self.delegate respondsToSelector:@selector(mapTypeSelectView:selectedType:)]) {
        [self.delegate mapTypeSelectView:self selectedType:tappedView.tag-30];
    }
}
@end
