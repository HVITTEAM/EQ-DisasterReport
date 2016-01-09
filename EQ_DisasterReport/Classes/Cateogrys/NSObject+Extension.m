//
//  NSObject+Extension.m
//  EQ_DisasterReport
//
//  Created by shi on 15/12/24.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "NSObject+Extension.h"

@implementation NSObject (Extension)

-(id)validateDataIsNull
{
    if ((NSNull *)self == [NSNull null]) {
        return nil;
    }else{
        return self;
    }
}

@end
