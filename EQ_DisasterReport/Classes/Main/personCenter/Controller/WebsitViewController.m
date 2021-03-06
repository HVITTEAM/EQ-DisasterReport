//
//  WebsitViewController.m
//  EQ_DisasterReport
//
//  Created by shi on 15/11/21.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "WebsitViewController.h"

@interface WebsitViewController ()<UIWebViewDelegate,MBProgressHUDDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (strong,nonatomic)MBProgressHUD *hud;

@end

@implementation WebsitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.navigationItem.title = @"我们网站";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_icon_white"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    
    self.webView.delegate = self;
    
    NSString *reqAddr = @"http://www.baidu.com";
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:reqAddr]];
    [self.webView loadRequest:request];
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.delegate = self;
}

#pragma mark -- UIWebViewDelegate 方法 --
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{

}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"加载网站结束");
    [self.hud hide:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{

}

#pragma mark -- MBProgressHUDDelegate 方法 --
-(void)hudWasHidden:(MBProgressHUD *)hud
{
    [hud removeFromSuperview];
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
