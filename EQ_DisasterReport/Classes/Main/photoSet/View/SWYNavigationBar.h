//
//  SWYNavigationBar.h
//  EQ_DisasterReport
//
//  Created by shi on 15/11/5.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol NavigationBarDelegate;

@interface SWYNavigationBar : UIView
@property(nonatomic,weak)id<NavigationBarDelegate>delegate;
-(instancetype)initCustomNavigatinBar;

@end


@protocol NavigationBarDelegate <NSObject>

-(void)navigationBar:(SWYNavigationBar *)naviBar didClickLeftBtn:(UIButton *)leftBtn;

@end