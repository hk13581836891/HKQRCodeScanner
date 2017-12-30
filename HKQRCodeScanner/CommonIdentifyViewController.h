//
//  CommonIdentifyViewController.h
//  HKQRCodeScanner
//
//  Created by houke on 2017/12/29.
//  Copyright © 2017年 personal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonIdentifyViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *QRCodeImageView;
- (IBAction)openPhotoAlbum:(id)sender;

@end
