//
//  SpotLabelCell.m
//  EQ_DisasterReport
//
//  Created by shi on 15/11/9.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "SpotLabelCell.h"

@interface SpotLabelCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *contentLb;

@end

@implementation SpotLabelCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(instancetype)cellWithTableView:(UITableView *)tableView model:(SpotInfoModel *)model
{
    static NSString *cellID = @"SpotLabelCell";
    SpotLabelCell *cell = (SpotLabelCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SpotLabelCell" owner:nil options:nil] lastObject];
        // 去除cell的默认背景色
        cell.backgroundColor = [UIColor clearColor];
        // 设置背景view
        cell.backgroundView = [[UIImageView alloc] init];
        cell.selectedBackgroundView = [[UIImageView alloc] init];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.cellModel = model;
    
    return cell;
}

-(void)setCellModel:(SpotInfoModel *)cellModel
{
    _cellModel = cellModel;
    self.titleLb.text =cellModel.titleStr;
    self.contentLb.text = cellModel.contentStr;
}

-(CGFloat)calulateCellHeightWithModel:(SpotInfoModel *)model
{
    self.cellModel = model;
    
    self.contentLb.preferredMaxLayoutWidth = MTScreenW-130;
    //[self.contentView layoutIfNeeded];
//    [self.contentView updateConstraintsIfNeeded];
//    [self.contentView layoutIfNeeded];

    CGSize size = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
     NSLog(@"cell-------%f",size.height+1);
    return size.height+1.0f;
}


- (void)setIndexPath:(NSIndexPath *)indexPath rowsInSection:(int)rows
{
    // 1.取出背景view
    UIImageView *bgView = (UIImageView *)self.backgroundView;
    UIImageView *selectedBgView = (UIImageView *)self.selectedBackgroundView;
    
    // 2.设置背景图片
    if (rows == 1) {
        bgView.image = [UIImage resizedImage:@"common_card_background"];
        selectedBgView.image = [UIImage resizedImage:@"common_card_background_highlighted"];
    } else if (indexPath.row == 0) { // 首行
        bgView.image = [UIImage resizedImage:@"common_card_top_background"];
        selectedBgView.image = [UIImage resizedImage:@"common_card_top_background_highlighted"];
    } else if (indexPath.row == rows - 1) { // 末行
        bgView.image = [UIImage resizedImage:@"common_card_bottom_background"];
        selectedBgView.image = [UIImage resizedImage:@"common_card_bottom_background_highlighted"];
    } else { // 中间
        bgView.image = [UIImage resizedImage:@"common_card_middle_background"];
        selectedBgView.image = [UIImage resizedImage:@"common_card_middle_background_highlighted"];
    }
}



@end
