//
//  WebviewIdentifyViewController.m
//  HKQRCodeScanner
//
//  Created by houke on 2017/12/29.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "WebviewIdentifyViewController.h"
#import <WebKit/WebKit.h>
#import "FSActionSheet.h"


@interface WebviewIdentifyViewController ()<WKUIDelegate,WKNavigationDelegate,FSActionSheetDelegate,UIGestureRecognizerDelegate>
{
    UIImage *_saveImage;
    NSString *_qrCodeString;
}
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation WebviewIdentifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat navBarH = self.navigationController.navigationBar.frame.size.height;
    CGFloat tabBarH = self.tabBarController.tabBar.frame.size.height;
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, navBarH, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height -navBarH - tabBarH )];
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://p1b0tkq2t.bkt.clouddn.com/secondTest.html"]]];
    [self.view addSubview:_webView];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(readCode:)];
    longPress.delegate = self;
    [_webView addGestureRecognizer:longPress];
    
    
    // Do any additional setup after loading the view.
}
- (void)readCode:(UILongPressGestureRecognizer *)sender{
    if (sender.state != UIGestureRecognizerStateBegan) {
        return;
    }
    CGPoint touchPoint = [sender locationInView:self.webView];
    // 获取长按位置对应的图片url的JS代码
    NSString *imgJS = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", touchPoint.x, touchPoint.y];
    // 执行对应的JS代码 获取url
    [self.webView evaluateJavaScript:imgJS completionHandler:^(id _Nullable imgUrl, NSError * _Nullable error) {
        if (imgUrl) {
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
            UIImage *image = [UIImage imageWithData:data];
            if (!image) {
                NSLog(@"读取图片失败");
                return;
            }
            _saveImage = image;
            FSActionSheet *actionSheet = nil;
            if ([self isAvailableQRcodeIn:image]) {
                actionSheet = [[FSActionSheet alloc] initWithTitle:nil
                                                          delegate:self
                                                 cancelButtonTitle:@"取消"
                                            highlightedButtonTitle:nil
                                                 otherButtonTitles:@[@"保存图片", @"打开二维码"]];
            } else {
                actionSheet = [[FSActionSheet alloc] initWithTitle:nil
                                                          delegate:self
                                                 cancelButtonTitle:@"取消"
                                            highlightedButtonTitle:nil
                                                 otherButtonTitles:@[@"保存图片"]];
            }
            [actionSheet show];
        }
    }];
}
- (BOOL)isAvailableQRcodeIn:(UIImage *)img{
    //判断点击区域的图片是否二维码
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{}];
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:img.CGImage]];
    if (features.count >= 1) {
        CIQRCodeFeature *feature = [features objectAtIndex:0];
        _qrCodeString = [feature.messageString copy];
        NSLog(@"二维码信息:%@", _qrCodeString);
        return YES;
    } else {
        NSLog(@"无可识别的二维码");
        return NO;
    }
}
#pragma mark UIGestureDelegate
//是否支持多时候触发，返回YES，则可以多个手势一起触发方法，返回NO则为互斥
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}
#pragma mark navigationDelegate

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    // 不执行前段界面弹出列表的JS代码
    [_webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:nil];
}


#pragma mark - FSActionSheetDelegate
- (void)FSActionSheet:(FSActionSheet *)actionSheet selectedIndex:(NSInteger)selectedIndex{
    switch (selectedIndex) {
        case 0:
        {
            UIImageWriteToSavedPhotosAlbum(_saveImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
            break;
        case 1:
        {
            NSURL *qrUrl = [NSURL URLWithString:_qrCodeString];
            // Safari打开
            if ([[UIApplication sharedApplication] canOpenURL:qrUrl]) {
                [[UIApplication sharedApplication] openURL:qrUrl];
            }
            // 内部应用打开
            [self.webView loadRequest:[NSURLRequest requestWithURL:qrUrl]];
        }
            break;
            
        default:
            break;
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    NSString *message = @"Succeed";
    if (error) {
        message = @"Fail";
    }
    NSLog(@"save result :%@", message);
}
@end
