//
//  PersonCenterHeadView.m
//  EQ_DisasterReport
//
//  Created by shi on 15/11/12.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "PersonCenterHeadView.h"

@implementation PersonCenterHeadView

-(void)awakeFromNib
{
    self.userIcon.layer.cornerRadius = self.userIcon.width/2;
    self.userIcon.layer.masksToBounds = YES;
    self.userIcon.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.userIcon.layer.borderWidth = 1.0f;
}

@end
