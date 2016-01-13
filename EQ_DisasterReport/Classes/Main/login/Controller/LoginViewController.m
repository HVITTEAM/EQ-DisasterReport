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
#import "LoginUser.h"
#import "MBProgressHUD.h"
#import "APService.h"

@interface LoginViewController ()<SWYNetworkCallBackDelegate,SWYNetworkParamSourceDelegate,SWYNetworkReformerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *accountText;

@property (weak, nonatomic) IBOutlet UITextField *passwordText;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property(strong,nonatomic)LoginactionNTHelper *loginNetWorkHelper;   //登录接口对象

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
    
    NSDictionary *dict = @{
                           @"username":self.accountText.text,
                           @"password":self.passwordText.text
                           };
    
    //创建参数，发送请求
    NSMutableDictionary *paramDict = [dict mutableCopy];
    SWYRequestParams *params = [[SWYRequestParams alloc] initWithParams:paramDict files:nil];
    
    return params;
}

#pragma mark SWYNetworkCallBackDelegate
- (void)requestDidSuccess:(SWYBaseNetworkHelper *)networkHelper
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    id responseData = [networkHelper fetchDataWithReformer:self];   //获取返回的参数
    
    if ([responseData isKindOfClass:[NSDictionary class]]) {
       NSDictionary *responseDict = (NSDictionary *)responseData;
        
        LoginUser *user = [LoginUser shareInstance];
        user.login_status = responseDict[@"login_status"];
        user.loginname = responseDict[@"loginname"];
        user.userid = responseDict[@"userid"];
        
        if ((NSNull *)responseDict[@"username"] == [NSNull null]) {
            user.username = nil;
        }else{
            user.username = responseDict[@"username"];
        }
        
        if ((NSNull *)responseDict[@"station"] == [NSNull null]) {
            user.station = nil;
        }else{
            user.station = responseDict[@"station"];
        }

        if ([user.login_status isEqualToString:@"success"]) {
            
            //极光推送：设置别名和标签
            [APService setTags:nil alias: [NSString stringWithFormat:@"%@",user.userid] callbackSelector:@selector(tagsAliasCallback:tags:alias:) target:self];
            
            //跳转到主界面
            [HMControllerTool setRootViewController];
        }
    }
}

- (void)requestDidFailed:(SWYBaseNetworkHelper *)networkHelper
{
   [MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma mark SWYNetworkReformerDelegate
- (id)networkHelper:(SWYBaseNetworkHelper *)networkHelper reformData:(id)data
{
    NSLog(@"-------登录返回数据%@",data);
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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.loginNetWorkHelper startSendRequest];
    //[HMControllerTool setRootViewController];
}

#pragma mark -- 内部方法 --
/**
 *  极光推送相关方法:设置别名后的回调
 */
- (void)tagsAliasCallback:(int)iResCode tags:(NSSet *)tags alias:(NSString *)alias
{
    NSLog(@"极光推送相设置别名后回调 rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}


@end
