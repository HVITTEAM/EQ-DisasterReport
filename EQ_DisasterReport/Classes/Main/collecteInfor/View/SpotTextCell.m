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

@property(nonatomic,strong)SpotCellModel *cellModel;

@end

@implementation SpotTextCell

- (void)awakeFromNib {
    // Initialization code
    self.contentTextField.delegate = self;
    [self.contentTextField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark -- 初始化方法 --
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

#pragma mark -- setter 方法和 getter方法 --
-(void)setCellModel:(SpotCellModel *)cellModel
{
    _cellModel = cellModel;
    self.titleLb.text =cellModel.titleStr;
    self.contentTextField.placeholder = cellModel.placeHolderStr;
    self.contentTextField.text = cellModel.contentStr;
}

#pragma mark -- UITextField delegate 方法 --
-(void)textChange:(UITextField *)textField
{
    self.cellModel.contentStr = textField.text;
    NSLog(@"SpotTextCell-----------%@",self.cellModel.contentStr);
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(beginEditCellContent:)]) {
        [self.delegate beginEditCellContent:self];
    }
}

#pragma mark -- 公开方法 --
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


@end
