//
//  ImagePickCell.h
//  EQ_DisasterReport
//
//  Created by shi on 15/11/10.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImagePickCellDelegate;

@interface ImagePickCell : UITableViewCell
@property (nonatomic, strong) UIViewController *parentVC;
@property (nonatomic, weak)id<ImagePickCellDelegate>delegate;
@property (nonatomic,strong)NSMutableArray *images;
@end

@protocol ImagePickCellDelegate <NSObject>

-(void)imagePickCell:(ImagePickCell *)cell pickedImages:(NSMutableArray *)images imagePickViewheight:(CGFloat)height;

@end