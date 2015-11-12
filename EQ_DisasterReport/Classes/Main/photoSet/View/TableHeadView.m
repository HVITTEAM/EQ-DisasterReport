//
//  TableHeadView.m
//  EQ_DisasterReport
//
//  Created by shi on 15/11/4.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "TableHeadView.h"
@implementation TableHeadView

-(void)awakeFromNib
{
    //给头部视图添加手势，点击回调协议方法
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bigimageViewClicked:)];
    gestureRecognizer.numberOfTapsRequired = 1;
    gestureRecognizer.numberOfTouchesRequired = 1;
    [self.bigImagV addGestureRecognizer:gestureRecognizer];
}

/**
 *  bigimageName的 setter 方法，传入数据时设置大图
 */
-(void)setBigimageName:(NSString *)bigimageName
{
    _bigimageName = bigimageName;
    UIImage *bigImage = [UIImage imageNamed:bigimageName];
    self.bigImagV.image = bigImage;
}

-(void)bigimageViewClicked:(UITapGestureRecognizer *)gestureRecognizer
{
    if ([self.delegate respondsToSelector:@selector(tableheadView:didClickImageName:)]) {
        [self.delegate tableheadView:self didClickImageName:self.bigimageName];
    }
}

@end
