//
//  SpotTextCell.h
//  EQ_DisasterReport
//
//  Created by shi on 15/11/9.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpotInfoModel.h"

@interface SpotTextCell : UITableViewCell
@property(nonatomic,strong)SpotInfoModel *cellModel;
+(instancetype)cellWithTableView:(UITableView *)tableView model:(SpotInfoModel *)model;
- (void)setIndexPath:(NSIndexPath *)indexPath rowsInSection:(int)rows;
@end
