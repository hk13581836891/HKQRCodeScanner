//
//  WebviewViewController.m
//  HKQRCodeScanner
//
//  Created by houke on 2017/12/29.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "WebviewViewController.h"

@interface WebviewViewController ()<UIWebViewDelegate>

@end

@implementation WebviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    //获取系统状态栏、导航栏、底部导航栏的高度
    CGFloat staturBarH = [[UIApplication sharedApplication] statusBarFrame].size.height;
    CGFloat navBarH = self.navigationController.navigationBar.frame.size.height;
    CGFloat tabBarH = self.tabBarController.tabBar.frame.size.height;
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, staturBarH+navBarH, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-staturBarH-navBarH -tabBarH)];
    webView.delegate = self;
    webView.scalesPageToFit = YES;
    NSLog(@"------%@",_urlStr);
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlStr]]];
    [self.view addSubview:webView];
    
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

@end
