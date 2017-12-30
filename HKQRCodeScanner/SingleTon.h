//
//  SingleTon.h
//  HKQRCodeScanner
//
//  Created by houke on 2017/12/29.
//  Copyright © 2017年 personal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SingleTon : NSObject

+(SingleTon *)getInstance;

@property (nonatomic, strong) UIImage *myQRCodeImage;
@end
