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

@property(weak,nonatomic)id<TableHeadViewDelegate>delegate;
@end

/*点击头部图片后回调*/
@protocol TableHeadViewDelegate <NSObject>

-(void)tableheadView:(TableHeadView *)headVeiw didClickImageName:(NSString *)imageName;

@end