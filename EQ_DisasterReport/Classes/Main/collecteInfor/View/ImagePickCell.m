//
//  ImagePickCell.m
//  EQ_DisasterReport
//
//  Created by shi on 15/11/10.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "ImagePickCell.h"
#import "ImageCollectionView.h"
#define kCellMargin 10

@interface ImagePickCell ()
@property(nonatomic,strong)ImageCollectionView *imagePickVC;
@end
@implementation ImagePickCell

- (void)awakeFromNib {
    // Initialization code
    self.imagePickVC = [[ImageCollectionView alloc] initWithNibName:@"ImageCollectionView" bundle:nil];
    
    __weak typeof(self) weakSelf = self;
    self.imagePickVC.changeHeightBlock = ^(CGFloat viewHeight,NSMutableArray *images){
        if ([weakSelf.delegate respondsToSelector:@selector(imagePickCell:pickedImages:imagePickViewheight:)]) {
            [weakSelf.delegate imagePickCell:weakSelf pickedImages:images imagePickViewheight:viewHeight];
        }
    };
    UICollectionView *collectionView = (UICollectionView *)self.imagePickVC.view;
    
    CGFloat w = [[UIScreen mainScreen] bounds].size.width - 5 *kCellMargin;
    NSInteger cellWidth =floor(w/4);
    collectionView.frame = CGRectMake(0, 0, MTScreenW, cellWidth *3+4*kCellMargin);
    [self addSubview:collectionView];
    
    self.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setParentVC:(UIViewController *)parentVC
{
    self.imagePickVC.parentVC = parentVC;
}

-(void)setImages:(NSMutableArray *)images
{
    self.imagePickVC.canEdit = self.canEdit;
    self.imagePickVC.dataProvider = images;
}

@end
