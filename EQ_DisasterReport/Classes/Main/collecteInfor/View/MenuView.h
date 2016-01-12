//
//  MenuView.h
//  EQ_DisasterReport
//
//  Created by shi on 15/12/7.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuView;

@protocol MenuViewDelegate <NSObject>

-(void)menuView:(MenuView *)menuView indexForItem:(NSInteger)idx;

@end

@interface MenuView : UIView

@property(weak,nonatomic)id<MenuViewDelegate>delegate;

-(instancetype)initWithTitles:(NSArray *)titles titleIcons:(NSArray *)titleIcons;

-(void)showMenuViewInView:(UIView *)view frame:(CGRect)frame;

-(void)hideMenuView;

@end
