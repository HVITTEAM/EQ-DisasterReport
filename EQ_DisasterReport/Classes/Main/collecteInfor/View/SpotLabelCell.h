//
//  SpotLabelCell.h
//  EQ_DisasterReport
//
//  Created by shi on 15/11/9.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SpotCellModel;

@interface SpotLabelCell : UITableViewCell
@property(nonatomic,strong)SpotCellModel *cellModel;
+(instancetype)cellWithTableView:(UITableView *)tableView model:(SpotCellModel *)model;
-(CGFloat)calulateCellHeightWithModel:(SpotCellModel *)model;
- (void)setIndexPath:(NSIndexPath *)indexPath rowsInSection:(int)rows;
-(NSString *)getContent;
@end
