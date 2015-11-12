//
//  SpotInfoViewController.h
//  EQ_DisasterReport
//
//  Created by shi on 15/11/9.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SpotInforModel;

typedef NS_ENUM(NSInteger, ActionType) {
    kActionTypeAdd = 0,    //新增数据
    kActionTypeShow        //显示和更新数据
};

@interface SpotInfoViewController : UIViewController
@property(nonatomic,strong)SpotInforModel *spotInfoModel;     //除图片和声音之外的采集数据
@property(nonatomic,assign)ActionType actionType;                   //操作类型
@end
