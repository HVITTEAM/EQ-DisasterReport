//
//  ImagePickCell.m
//  EQ_DisasterReport
//
//  Created by shi on 15/11/10.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "ImagePickCell.h"
#import "ImageCollectionView.h"

@interface ImagePickCell ()
@property(nonatomic,strong)ImageCollectionView *imagePickVC;
@end
@implementation ImagePickCell

- (void)awakeFromNib {
    // Initialization code
    self.imagePickVC = [[ImageCollectionView alloc] initWithNibName:@"ImageCollectionView" bundle:nil];
    
    UICollectionView *collectionView = (UICollectionView *)self.imagePickVC.view;
    collectionView.frame = CGRectMake(0, 0, MTScreenW, 240);
    [self addSubview:collectionView];
    
    self.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setParentVC:(UIViewController *)parentVC
{
    self.imagePickVC.parentVC = parentVC;;
}

@end
