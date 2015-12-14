//
//  SWYMultipartFormObject.h
//  EQCollect_HD
//
//  Created by shi on 15/12/13.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWYMultipartFormObject : NSObject

@property(strong,nonatomic)NSData *fileData;

@property(strong,nonatomic)NSString *name;

@property(strong,nonatomic)NSString *fileName;

@property(strong,nonatomic)NSString *mimeType;


@end
