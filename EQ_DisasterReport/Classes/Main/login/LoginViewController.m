//
//  LoginViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/8/12.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "LoginViewController.h"
#import "HMControllerTool.h"
#import "LoginactionNTHelper.h"
#import "SWYRequestParams.h"

@interface LoginViewController ()<SWYNetworkCallBackDelegate,SWYNetworkParamSourceDelegate,SWYNetworkReformerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *accountText;

@property (weak, nonatomic) IBOutlet UITextField *passwordText;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property(strong,nonatomic)LoginactionNTHelper *loginNetWorkHelper;

@end

@implementation LoginViewController

#pragma mark -- 生命周期方法 --
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置登录按钮外观
    self.loginBtn.layer.cornerRadius = 5.0f;
    self.loginBtn.layer.masksToBounds = YES;
}

#pragma mark -- getter方法和 setter 方法 --
-(LoginactionNTHelper *)loginNetWorkHelper
{
    if (!_loginNetWorkHelper) {
        _loginNetWorkHelper = [[LoginactionNTHelper alloc] init];
        _loginNetWorkHelper.callBackDelegate = self;
        _loginNetWorkHelper.paramSource = self;
    }
    return _loginNetWorkHelper;
}

#pragma mark -- 协议方法 --

#pragma mark SWYNetworkParamSourceDelegate
- (SWYRequestParams *)paramsForRequest:(SWYBaseNetworkHelper *)networkHelper
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]
                                                  initWithDictionary:@{
                                                                        @"username":self.accountText.text,
                                                                        @"password":self.passwordText.text
                                                                      }];
    SWYRequestParams *params = [[SWYRequestParams alloc] initWithParams:dict files:nil];
    return params;
}

#pragma mark SWYNetworkCallBackDelegate
- (void)requestDidSuccess:(SWYBaseNetworkHelper *)networkHelper
{
   id responseData = [networkHelper fetchDataWithReformer:self];
    if ([responseData isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)responseData;
        if ([dict[@"login_status"] isEqualToString:@"success"]) {
            [HMControllerTool setRootViewController];
        }
    }
}

- (void)requestDidFailed:(SWYBaseNetworkHelper *)networkHelper
{

}

#pragma mark SWYNetworkReformerDelegate
- (id)networkHelper:(SWYBaseNetworkHelper *)networkHelper reformData:(id)data
{
    return data;
}



#pragma mark -- 事件方法 --
/**
 *  单击背景取消键盘
 */
- (IBAction)sigleTapBackgrouned:(id)sender {
    [self.view endEditing:YES];
}

#pragma mark 登录、注册、取回密码
/**
 *  登录
 */
- (IBAction)loginNow:(id)sender {
    [self.view endEditing:YES];
    [self.loginNetWorkHelper startSendRequest];
}



@end
