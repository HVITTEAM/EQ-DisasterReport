//
//  TableHeadView.h
//  EQ_DisasterReport
//
//  Created by shi on 15/11/4.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TableHeadViewDelegate;

@interface TableHeadView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *bigImagV;    //头部大图 view
@property (weak, nonatomic) IBOutlet UILabel *addressLb;       //地址label
@property (strong,nonatomic)NSString *bigimageName;            //大图名字
@property (weak, nonatomic) IBOutlet UIImageView *gradientBKView;     //显示一个渐变图片，防止图片与文字颜色太近字看不清

@property(weak,nonatomic)id<TableHeadViewDelegate>delegate;

@end


@protocol TableHeadViewDelegate <NSObject>
/**
 *  点击头部图片后回调
 */
-(void)tableheadView:(TableHeadView *)headVeiw didClickImageName:(NSString *)imageName;

@end