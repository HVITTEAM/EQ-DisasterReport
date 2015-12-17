//
//  PhotoInfoCell.h
//  EQ_DisasterReport
//
//  Created by shi on 15/11/23.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lonLb;
@property (weak, nonatomic) IBOutlet UILabel *latLb;
@property (weak, nonatomic) IBOutlet UILabel *levelLb;

@end
