//
//  SpotTextCell.m
//  EQ_DisasterReport
//
//  Created by shi on 15/11/9.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "SpotTextCell.h"
#import "SpotCellModel.h"

@interface SpotTextCell ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UITextField *contentTextField;

@end
@implementation SpotTextCell

- (void)awakeFromNib {
    // Initialization code
    self.contentTextField.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellModel:(SpotCellModel *)cellModel
{
    _cellModel = cellModel;
    self.titleLb.text =cellModel.titleStr;
    self.contentTextField.placeholder = cellModel.placeHolderStr;
    self.contentTextField.text = cellModel.contentStr;
}

+(instancetype)cellWithTableView:(UITableView *)tableView model:(SpotCellModel *)model
{
    static NSString *cellID = @"spotTextCell";
    SpotTextCell *cell = (SpotTextCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SpotTextCell" owner:nil options:nil] lastObject];
        
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
    return self.contentTextField.text;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.cellModel.contentStr = textField.text;
}

@end
