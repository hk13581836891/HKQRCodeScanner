//
//  CommonIdentifyViewController.m
//  HKQRCodeScanner
//
//  Created by houke on 2017/12/29.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "CommonIdentifyViewController.h"
#import "SingleTon.h"
#import "WebviewViewController.h"

@interface CommonIdentifyViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation CommonIdentifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.topItem.title = @"从相册识别二维码";
    
    // Do any additional setup after loading the view.
}


- (IBAction)openPhotoAlbum:(id)sender {
    
    [self openLocalPhoto];
}

/*!
 *  打开本地照片，选择图片识别
 */
- (void)openLocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    picker.delegate = self;
    
    //部分机型可能导致崩溃
    picker.allowsEditing = YES;
    
    [self presentViewController:picker animated:YES completion:nil];
}

//当选择一张图片后进入这里

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    __block UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (!image){
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    CIDetector*detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    
    for (CIQRCodeFeature *feature in features) {
        NSLog(@"msg = %@",feature.messageString); // 打印二维码中的信息
        WebviewViewController *webview = [[WebviewViewController alloc] init];
        webview.urlStr = feature.messageString;
        [self.navigationController pushViewController:webview animated:YES];
    }
    
   
}

@end
