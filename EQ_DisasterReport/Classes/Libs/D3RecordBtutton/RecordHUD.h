//
//  RecordHUD.h
//  D3RecordButtonDemo
//
//  Created by bmind on 15/7/29.
//  Copyright (c) 2015年 bmind. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RecordHUD;
@protocol RecordHudDelegate <NSObject>

-(void)finishRecord:(RecordHUD *)recordHUD;
-(void)cancelRecord:(RecordHUD *)recordHUD;
@end

@interface RecordHUD : UIView{
    UIImageView *imgView;
    UILabel *titleLabel;
    UILabel *timeLabel;
}
@property (nonatomic, strong, readonly) UIWindow *overlayWindow;
@property (nonatomic,weak)id<RecordHudDelegate>delegate;

+ (RecordHUD*)shareView;  //by swy

+ (void)show;

+ (void)dismiss;

+ (void)setTitle:(NSString*)title;

+ (void)setTimeTitle:(NSString*)time;

+ (void)setImage:(NSString*)imgName;
@end
