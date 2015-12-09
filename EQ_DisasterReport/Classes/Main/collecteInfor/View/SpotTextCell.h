//
//  SpotTextCell.h
//  EQ_DisasterReport
//
//  Created by shi on 15/11/9.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SpotCellModel;
@class SpotTextCell;

@protocol SpotTextCellDelegate <NSObject>

-(void)beginEditCellContent:(SpotTextCell *)cell;

@end

@interface SpotTextCell : UITableViewCell

@property(nonatomic,strong)SpotCellModel *cellModel;
@property(nonatomic,weak)id<SpotTextCellDelegate>delegate;

+(instancetype)cellWithTableView:(UITableView *)tableView model:(SpotCellModel *)model;

- (void)setIndexPath:(NSIndexPath *)indexPath rowsInSection:(int)rows;

-(NSString *)getContent;
@end
