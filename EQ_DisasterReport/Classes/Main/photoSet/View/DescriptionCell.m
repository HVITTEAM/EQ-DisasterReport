//
//  DescriptionCell.m
//  EQ_DisasterReport
//
//  Created by shi on 15/11/23.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#define margin 20
#import "DescriptionCell.h"

@interface DescriptionCell ()
@property (weak, nonatomic) IBOutlet UILabel *descriptionLb;
@end

@implementation DescriptionCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDescriptionStr:(NSString *)descriptionStr
{
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineSpacing = 5;
    
    NSDictionary *attribution = @{
                                  NSForegroundColorAttributeName:[UIColor lightGrayColor],
                                  NSParagraphStyleAttributeName:paragraph,
                                  NSFontAttributeName:[UIFont systemFontOfSize:14],
                                  };
    self.descriptionLb.attributedText = [[NSAttributedString alloc] initWithString:descriptionStr attributes:attribution];    
}

-(CGFloat)calculateCellHeight
{
    self.descriptionLb.preferredMaxLayoutWidth = MTScreenW - 2*margin;
    CGFloat h =[self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height +1;
    return h;
}

@end
