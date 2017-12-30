//
//  Tools.h
//  HKQRCodeScanner
//
//  Created by houke on 2017/12/29.
//  Copyright © 2017年 personal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Tools : NSObject

/**
 生成QR二维码
 
 @param text 字符串
 @param size 大小
 @param qrColor 二维码前景色
 @param bkColor 二维码背景色
 @return 二维码图像
 */
+ (UIImage*)createQRWithString:(NSString*)text QRSize:(CGSize)size QRColor:(UIColor*)qrColor bkColor:(UIColor*)bkColor;
@end
