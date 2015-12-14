//
//  SWYRequestParams.h
//  EQCollect_HD
//
//  Created by shi on 15/12/13.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SWYMultipartFormDataBlock)(id <AFMultipartFormData> formData);

@interface SWYRequestParams : NSObject

@property(strong,nonatomic,readonly)NSMutableDictionary *userParams;

@property(strong,nonatomic,readonly)NSMutableArray *multipartFormFiles;        //元素是SWYMultipartFormObject对象

-(SWYMultipartFormDataBlock)getMultiFormDataBlock;

-(instancetype)initWithParams:(NSMutableDictionary *)params files:(NSMutableArray *)files;

@end
