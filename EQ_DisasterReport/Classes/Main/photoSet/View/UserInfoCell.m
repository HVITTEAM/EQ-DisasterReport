//
//  UserInfoCell.m
//  EQ_DisasterReport
//
//  Created by shi on 15/11/4.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "UserInfoCell.h"

@implementation UserInfoCell

- (void)awakeFromNib {
    // Initialization code
    self.headIconImgV.layer.cornerRadius = self.headIconImgV.width/2;
    self.headIconImgV.layer.masksToBounds = YES;
    self.headIconImgV.backgroundColor = [UIColor brownColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
