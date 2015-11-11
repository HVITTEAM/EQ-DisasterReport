//
//  ImageCollectionView.h
//  EQCollect_HD
//
//  Created by 董徐维 on 15/9/17.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "UzysAssetsPickerController.h"

typedef void(^changeHeight)(CGFloat,NSMutableArray *);

@interface ImageCollectionView : UICollectionViewController<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UIAlertViewDelegate,UzysAssetsPickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong)NSMutableArray *dataProvider;
@property (nonatomic, assign)BOOL isShowAddBtn;
@property (nonatomic, assign)BOOL isExitThread;
@property (nonatomic, strong)UIViewController *parentVC;

/**根据图片的数改变view的高度,并传出所选择的图片**/
@property (nonatomic,copy)changeHeight changeHeightBlock;

@end
