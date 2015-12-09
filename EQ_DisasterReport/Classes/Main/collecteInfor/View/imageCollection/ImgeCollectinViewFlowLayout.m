//
//  ImgeCollectinViewFlowLayout.m
//  EQ_DisasterReport
//
//  Created by shi on 15/11/10.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "ImgeCollectinViewFlowLayout.h"

#define kMarginH 10
#define kMarginV 10
#define kColumn  4

@implementation ImgeCollectinViewFlowLayout

//// 指定CGRect范围内各单元格的大小和位置
//-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
//{
//    NSArray* attributes = [super layoutAttributesForElementsInRect:rect];
//
//    for(int i = 0; i < attributes.count; i++) {
//        
//        UICollectionViewLayoutAttributes *currentLayoutAttributes = attributes[i];
//        if (i <3) {
//            CGRect frame = currentLayoutAttributes.frame;
//            frame.origin.x = 10+i * (currentLayoutAttributes.size.width + 10);
//            frame.origin.y = 10;
//            currentLayoutAttributes.frame = frame;
//        }else if (i < 6){
//            CGRect frame = currentLayoutAttributes.frame;
//            frame.origin.x = 10+i%3 * (currentLayoutAttributes.size.width + 10);
//            frame.origin.y = 10+currentLayoutAttributes.size.height+10;
//            currentLayoutAttributes.frame = frame;
//        }else{
//            CGRect frame = currentLayoutAttributes.frame;
//            frame.origin.x = 10+i%3 * (currentLayoutAttributes.size.width + 10);
//            frame.origin.y = 10+(currentLayoutAttributes.size.height+10)*2;
//            currentLayoutAttributes.frame = frame;
//        }
//    }
//    return attributes;
//}

// 指定CGRect范围内各单元格的大小和位置
-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray* attributes = [super layoutAttributesForElementsInRect:rect];
    
    for(int i = 0; i < attributes.count; i++) {
        
        NSInteger row = i/kColumn;
        NSInteger col = i%kColumn;
        
        UICollectionViewLayoutAttributes *currentLayoutAttributes = attributes[i];
        CGRect frame = currentLayoutAttributes.frame;
        frame.origin.x = kMarginH + col * (currentLayoutAttributes.size.width + kMarginH);
        frame.origin.y = kMarginV + (currentLayoutAttributes.size.height+kMarginV)*row;
        currentLayoutAttributes.frame = frame;
    }
    return attributes;
}


@end
