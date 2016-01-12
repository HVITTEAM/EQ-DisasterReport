//
//  SpotInfoViewController.h
//  EQ_DisasterReport
//
//  Created by shi on 15/11/9.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SpotInforModel;
@protocol SpotInfoUploadDelegate;

typedef NS_ENUM(NSInteger, ActionType) {
    kActionTypeAdd = 0,    //新增数据
    kActionTypeShow        //显示和更新数据
};

@interface SpotInfoViewController : UIViewController
{
   SpotInforModel *_spotInfoModel;
}
@property(nonatomic,strong)SpotInforModel *spotInfoModel;      //除图片和声音之外的采集数据(新增时不需要传，显示和更新信息时需要传)

@property(nonatomic,strong)NSIndexPath *currentIdx;         //这个spotInfoModel的位置(新增时不需要传，显示和更新信息时需要传)

@property(nonatomic,assign)ActionType actionType;                   //当前页面的操作类型

@property(nonatomic,weak)id<SpotInfoUploadDelegate>delegate;

@end

///////////////////////////////////////////////////////////////

@protocol SpotInfoUploadDelegate <NSObject>

-(void)spotInfoViewController:(SpotInfoViewController *)spotInfoVC uploadSuccessIndexPath:(NSIndexPath *)idx;

@end