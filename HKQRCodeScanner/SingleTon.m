//
//  SingleTon.m
//  HKQRCodeScanner
//
//  Created by houke on 2017/12/29.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "SingleTon.h"

@implementation SingleTon

+(SingleTon *)getInstance
{
    static SingleTon *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SingleTon alloc] init];
        
    });
    return instance;
}
@end
