//
//  SpotInfoCell.m
//  EQ_DisasterReport
//
//  Created by shi on 15/11/6.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "SpotInforCell.h"
#import "SpotInforModel.h"

@interface SpotInforCell ()
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UILabel *lonLb;
@property (weak, nonatomic) IBOutlet UILabel *latLb;
@property (weak, nonatomic) IBOutlet UILabel *levelLb;
@property (weak, nonatomic) IBOutlet UILabel *addrLb;
@property (weak, nonatomic) IBOutlet UIImageView *uploadStateImageView;

@end
@implementation SpotInforCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void)setCellModel:(SpotInforModel *)cellModel
{
    self.phoneNumLb.text = [NSString stringWithFormat:@"%@",cellModel.phoneNum];
    self.timeLb.text= [NSString stringWithFormat:@"%@",cellModel.occurTime];
    self.lonLb.text = [NSString stringWithFormat:@"经度:%@",cellModel.lon];
    self.latLb.text = [NSString stringWithFormat:@"纬度:%@",cellModel.lat];
    self.levelLb.text = [NSString stringWithFormat:@"%@",cellModel.level];
    self.addrLb.text = [NSString stringWithFormat:@"%@",cellModel.address];
    if ([cellModel.isUpload isEqualToString:kdidUpload]) {
        self.uploadStateImageView.hidden = YES;
    }else{
        self.uploadStateImageView.hidden = NO;
    }
}



@end
