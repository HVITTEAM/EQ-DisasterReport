//
//  FillContentViewController.h
//  EQ_DisasterReport
//
//  Created by shi on 15/11/10.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FillContentViewController;

@protocol FillContentViewControllerDelegate <NSObject>

-(void)fillContentViewController:(FillContentViewController*)fillContentVC filledContent:(NSString *)content indexPath:(NSIndexPath *)indexpath;

@end

@interface FillContentViewController : UIViewController
@property(nonatomic,copy)NSString *titleStr;
@property(nonatomic,strong)NSIndexPath *indexpath;
@property(nonatomic,weak)id<FillContentViewControllerDelegate>delegate;

@end
