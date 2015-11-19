//
//  AudioVO.h
//  EQ_DisasterReport
//
//  Created by shi on 15/11/19.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioVO : NSObject
@property (nonatomic,copy) NSString *name;
@property (strong, nonatomic)NSData *audioData;
@end
