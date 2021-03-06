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

/**
 *  开始编辑时回调
 */
-(void)beginEditCellContent:(SpotTextCell *)cell;

/**
 *  键盘输入内容改变前回调,返回 YES 改变，返回 NO 输入的内容无效
 */
-(BOOL)spotTextCell:(SpotTextCell *)cell
          textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
  replacementString:(NSString *)string;

@end


@interface SpotTextCell : UITableViewCell

@property(nonatomic,weak)id<SpotTextCellDelegate>delegate;

/**
 *  根据 tableView 和 model数据创建并返回一个 cell
 */
+(instancetype)cellWithTableView:(UITableView *)tableView model:(SpotCellModel *)model;

/**
 *  设置 cell 的分割线
 */
- (void)setIndexPath:(NSIndexPath *)indexPath rowsInSection:(int)rows;

/**
 *  获取 cell 的的内容
 */
-(NSString *)getContent;

@end
