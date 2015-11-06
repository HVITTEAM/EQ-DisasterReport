//
//  LoopImagesView.h
//  EQ_DisasterReport
//
//  Created by shi on 15/11/6.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoopImagesViewDelegate;

@interface LoopImagesView : UIView
@property(nonatomic,strong)NSArray *imageArr;
@property(nonatomic,weak)id<LoopImagesViewDelegate>delegate;
@end

/*点击图片后将图片的序号回传*/
@protocol LoopImagesViewDelegate <NSObject>
-(void)loopImagesView:(LoopImagesView *)loopImageView didImageClickedIndex:(NSInteger)index;
@end