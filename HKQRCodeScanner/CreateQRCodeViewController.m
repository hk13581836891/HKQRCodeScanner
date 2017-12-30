//
//  CreateQRCodeViewController.m
//  HKQRCodeScanner
//
//  Created by houke on 2017/12/29.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "CreateQRCodeViewController.h"
#import "Tools.h"
#import "SingleTon.h"
#import "WebviewViewController.h"

@interface CreateQRCodeViewController ()

@end

@implementation CreateQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //长按识别图中的二维码，类似于微信里面的功能,前提是当前页面必须有二维码
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(readCode:)];
    [self.view addGestureRecognizer:longPress];
    // Do any additional setup after loading the view.
}
- (void)readCode:(UILongPressGestureRecognizer *)pressSender {
    
    if (pressSender.state == UIGestureRecognizerStateBegan) {
        
        
        //截图 再读取
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, YES, 0);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        [self.view.layer renderInContext:context];
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        CIImage *ciImage = [[CIImage alloc] initWithCGImage:image.CGImage options:nil];
        CIContext *ciContext = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(YES)}]; // 软件渲染
        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:ciContext options:@{CIDetectorAccuracy : CIDetectorAccuracyHigh}];// 二维码识别
        
        NSArray *features = [detector featuresInImage:ciImage];
        for (CIQRCodeFeature *feature in features) {
            NSLog(@"msg = %@",feature.messageString); // 打印二维码中的信息
            WebviewViewController *webview = [[WebviewViewController alloc] init];
            webview.urlStr = feature.messageString;
            [self.navigationController pushViewController:webview animated:YES];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)createQRVodeBtnClick:(id)sender {
    UIImage *tempCodeImage =  [Tools createQRWithString:@"http://p1b0tkq2t.bkt.clouddn.com/secondTest.html" QRSize:CGSizeMake(CGRectGetWidth(_QRCodeImage.frame), CGRectGetWidth(_QRCodeImage.frame)) QRColor:[UIColor blackColor] bkColor:[UIColor whiteColor]];
    _QRCodeImage.image = tempCodeImage;
    [SingleTon getInstance].myQRCodeImage = tempCodeImage;
    
}
@end
