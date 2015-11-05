//
//  SWYPhotoBrowserViewController.h
//  EQ_DisasterReport
//
//  Created by shi on 15/11/5.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWYPhotoBrowserViewController : UIViewController
@property(nonatomic,strong)NSArray *imageNames;    //图片数组
@property(nonatomic,assign)NSInteger currentIndex; //当前显示哪张
@end
