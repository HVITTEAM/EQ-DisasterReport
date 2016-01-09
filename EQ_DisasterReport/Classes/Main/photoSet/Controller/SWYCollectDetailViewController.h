//
//  SWYCollectDetailViewController.h
//  EQ_DisasterReport
//
//  Created by shi on 15/11/4.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoSetModel.h"

@interface SWYCollectDetailViewController : UIViewController

@property(nonatomic,strong)PhotoSetModel *photoInfor;      //照片信息对象，由上一级传递过来

@end
