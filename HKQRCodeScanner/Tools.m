//
//  Tools.m
//  HKQRCodeScanner
//
//  Created by houke on 2017/12/29.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "Tools.h"

@implementation Tools

+ (UIImage*)createQRWithString:(NSString*)text QRSize:(CGSize)size QRColor:(UIColor*)qrColor bkColor:(UIColor*)bkColor
{
    
    NSData *stringData = [text dataUsingEncoding: NSUTF8StringEncoding];
    
    //生成
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    
    //上色
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"
                                       keysAndValues:
                             @"inputImage",qrFilter.outputImage,
                             @"inputColor0",[CIColor colorWithCGColor:qrColor.CGColor],
                             @"inputColor1",[CIColor colorWithCGColor:bkColor.CGColor],
                             nil];
    
    CIImage *qrImage = colorFilter.outputImage;
    
    //绘制
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRelease(cgImage);
    
    //二维码图面
    UIImage *QRCodeImage = codeImage;
    
    //设置中心图片
    CGRect frame = CGRectMake(0, 0, size.width/6, size.height/6);
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, 0);
    [[UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:5] addClip];
    [[UIImage imageNamed:@"portrait.jpg"] drawInRect:frame];
    UIImage *clipImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //在二维码图片上添加中心图片
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    [QRCodeImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    [clipImage drawInRect:CGRectMake((size.width - clipImage.size.width)/2, (size.height - clipImage.size.height)/2, clipImage.size.width, clipImage.size.height)];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    return resultImage;
}


@end
