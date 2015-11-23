//
//  DescriptionCell.h
//  EQ_DisasterReport
//
//  Created by shi on 15/11/23.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DescriptionCell : UITableViewCell
@property (copy,nonatomic)NSString *descriptionStr;
-(CGFloat)calculateCellHeight;
@end
