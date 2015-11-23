//
//  SQCollectionCell.m
//  EQ_DisasterReport
//
//  Created by shi on 15/11/20.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "SQCollectionCell.h"

@implementation SQCollectionCell

- (IBAction)deletePhotoBtnClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(SQCollectionCell:deletePhotoWithIndexpath:)]) {
        [self.delegate SQCollectionCell:self deletePhotoWithIndexpath:self.indexpath];
    }
}
@end
