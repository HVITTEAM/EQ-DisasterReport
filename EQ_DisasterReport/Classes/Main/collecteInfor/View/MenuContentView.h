//
//  MenuContentView.h
//  EQ_DisasterReport
//
//  Created by shi on 15/12/7.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuContentView;

@protocol MenuContentViewDelegate <NSObject>

-(void)menuContentView:(MenuContentView *)MenuContentView indexForItem:(NSInteger)idx;

@end

@interface MenuContentView : UIView

@property(weak,nonatomic)id<MenuContentViewDelegate>delegate;

-(instancetype)initWithTitles:(NSArray *)titles titleIcons:(NSArray *)titleIcons;
@end
