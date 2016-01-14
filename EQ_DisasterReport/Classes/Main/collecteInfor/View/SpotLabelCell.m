//
//  SpotLabelCell.m
//  EQ_DisasterReport
//
//  Created by shi on 15/11/9.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "SpotLabelCell.h"
#import "SpotCellModel.h"

@interface SpotLabelCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *contentLb;
@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;

@end

@implementation SpotLabelCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(instancetype)cellWithTableView:(UITableView *)tableView model:(SpotCellModel *)model
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

-(void)setCellModel:(SpotCellModel *)cellModel
{
    _cellModel = cellModel;
    self.titleLb.text =cellModel.titleStr;
    self.contentLb.text = cellModel.contentStr;
    self.placeHolderLabel.text = cellModel.placeHolderStr;
    if (cellModel.contentStr&&cellModel.contentStr.length>0) {
        self.placeHolderLabel.hidden = YES;
    }else{
        self.placeHolderLabel.hidden = NO;
    }
}

-(CGFloat)calulateCellHeightWithModel:(SpotCellModel *)model
{
    self.cellModel = model;
    
    self.contentLb.preferredMaxLayoutWidth = MTScreenW-130;

    CGSize size = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
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


-(NSString *)getContent
{
    return self.contentLb.text;
}


@end
