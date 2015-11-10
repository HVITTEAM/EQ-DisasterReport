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

@interface ImageCollectionView : UICollectionViewController<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UIAlertViewDelegate,UzysAssetsPickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) NSMutableArray *dataProvider;
@property (nonatomic,assign)BOOL isShowAddBtn;
@property (nonatomic ,assign)BOOL isExitThread;
@property (nonatomic, strong) UIViewController *parentVC;

@end
