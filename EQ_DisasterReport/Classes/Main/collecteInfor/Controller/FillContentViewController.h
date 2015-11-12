//
//  FillContentViewController.h
//  EQ_DisasterReport
//
//  Created by shi on 15/11/10.
//  Copyright © 2015年 董徐维. All rights reserved.

/*
 *  让用户填写内容的VC
 */

#import <UIKit/UIKit.h>

@class FillContentViewController;

@protocol FillContentViewControllerDelegate <NSObject>
/*
 *  将编辑的内容回传
 *  content:编辑的内容  indexpath:对应的 cell 位置
 */
-(void)fillContentViewController:(FillContentViewController*)fillContentVC filledContent:(NSString *)content indexPath:(NSIndexPath *)indexpath;

@end

@interface FillContentViewController : UIViewController
@property(nonatomic,copy)NSString *titleStr;            //标题
@property(nonatomic,copy)NSString *contentStr;          //编辑的内容
@property(nonatomic,strong)NSIndexPath *indexpath;     //对应cell 位置

@property(nonatomic,weak)id<FillContentViewControllerDelegate>delegate;

@end
