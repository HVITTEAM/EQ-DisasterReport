//
//  SQCollectionCell.h
//  EQ_DisasterReport
//
//  Created by shi on 15/11/20.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SQCollectionCell;
@protocol SQCollectionCellDelegate <NSObject>

-(void)SQCollectionCell:(SQCollectionCell *)cell deletePhotoWithIndexpath:(NSIndexPath *)indexpath;

@end

@interface SQCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UIButton *delButton;

@property(weak,nonatomic)id<SQCollectionCellDelegate>delegate;

@property(strong,nonatomic)NSIndexPath *indexpath;
@end
