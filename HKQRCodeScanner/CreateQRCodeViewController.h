//
//  CreateQRCodeViewController.h
//  HKQRCodeScanner
//
//  Created by houke on 2017/12/29.
//  Copyright © 2017年 personal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateQRCodeViewController : UIViewController

- (IBAction)createQRVodeBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *QRCodeImage;

@end
