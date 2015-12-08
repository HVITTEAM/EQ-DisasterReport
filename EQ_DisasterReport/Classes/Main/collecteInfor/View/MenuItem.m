//
//  MenuItem.m
//  EQ_DisasterReport
//
//  Created by shi on 15/12/7.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "MenuItem.h"
#define marginH 30
#define marginV 10

@interface MenuItem ()
@property(strong,nonatomic)UIImageView *iconImgV;
@property(strong,nonatomic)UILabel *titleLb;
@end

@implementation MenuItem
-(instancetype)initWithTitle:(NSString *)titleStr imageName:(NSString *)imgNameStr
{
    self = [super init];
    if (self) {
        self.iconImgV = [[UIImageView alloc] init];
        self.iconImgV.image = [UIImage imageNamed:imgNameStr];
        self.iconImgV.clipsToBounds = YES;
        //self.iconImgV.backgroundColor = [UIColor yellowColor];
        [self addSubview:self.iconImgV];
        
        self.titleLb = [[UILabel alloc] init];
        self.titleLb.text = titleStr;
        self.titleLb.textAlignment = NSTextAlignmentLeft;
        self.titleLb.font = [UIFont systemFontOfSize:16];
        self.titleLb.textColor = [UIColor whiteColor];
        [self addSubview:self.titleLb];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat iconW = self.size.height - 2 * marginV;
    self.iconImgV.frame = CGRectMake(marginH, marginV,iconW, iconW);
    
    CGFloat titleLbX = CGRectGetMaxX(self.iconImgV.frame) + 10;
    CGFloat titleLbW = self.size.width - titleLbX;
    self.titleLb.frame = CGRectMake(titleLbX, 0, titleLbW , self.size.height);
}

@end
