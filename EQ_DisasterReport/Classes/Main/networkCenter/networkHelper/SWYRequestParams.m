//
//  SWYRequestParams.m
//  EQCollect_HD
//
//  Created by shi on 15/12/13.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "SWYRequestParams.h"
#import "AFNetworking.h"
#import "SWYMultipartFormObject.h"

@interface SWYRequestParams ()

@property(strong,nonatomic,readwrite)NSMutableDictionary *userParams;

@property(strong,nonatomic,readwrite)NSMutableArray *multipartFormFiles;

@end

@implementation SWYRequestParams

-(instancetype)initWithParams:(NSMutableDictionary *)params files:(NSMutableArray *)files
{
    self = [super init];
    if (self) {
        _userParams = params;
        _multipartFormFiles = files;
    }
    return self;
}

-(SWYMultipartFormDataBlock)getMultiFormDataBlock
{
    if (self.multipartFormFiles == nil || self.multipartFormFiles.count == 0) {
        return nil;
    }
    
    return ^(id<AFMultipartFormData> formData) {
        for (SWYMultipartFormObject *fileObject in self.multipartFormFiles) {
            [formData appendPartWithFileData:fileObject.fileData name:fileObject.name fileName:fileObject.fileName mimeType:fileObject.mimeType];
        }
    };
}

@end
