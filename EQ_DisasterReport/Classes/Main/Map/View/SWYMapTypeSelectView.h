//
//  SWYMapTypeSelectView.h
//  EQ_DisasterReport
//
//  Created by shi on 15/11/3.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MapTypeSelectViewDelegate;
@interface SWYMapTypeSelectView : UIView
@property(nonatomic,strong)UIButton *bkView;

@property(nonatomic,weak)id<MapTypeSelectViewDelegate>delegate;

- (void)showMapTypeViewToView:(UIView *)superView position:(CGPoint)loc;
-(void)removeMapTypeView;

@end


@protocol MapTypeSelectViewDelegate <NSObject>
-(void)mapTypeSelectView:(SWYMapTypeSelectView *)mapTypeView selectedType:(CGFloat)type;
@end