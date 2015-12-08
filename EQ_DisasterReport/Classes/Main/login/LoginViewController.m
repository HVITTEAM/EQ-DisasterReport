//
//  LoginViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/8/12.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "LoginViewController.h"
#import "HMControllerTool.h"

@interface LoginViewController ()<UITextFieldDelegate>

- (IBAction)loginNow:(id)sender;
- (IBAction)regist:(id)sender;
- (IBAction)backPassword:(id)sender;
- (IBAction)sigleTapBackgrouned:(id)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置登录按钮外观
    self.loginBtn.layer.cornerRadius = 5.0f;
    self.loginBtn.layer.masksToBounds = YES;
    
    self.accountText.delegate = self;
    self.passwordText.delegate = self;
   
   
    [self initNaviBar];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //注册键盘通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //解除键盘通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)initNaviBar
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.navigationController.navigationBar.barTintColor = HMColor(79, 127, 175);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
//    //左侧按钮
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
//    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.title = @"登陆";
}


#pragma mark UITextField协议方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.currentText = textField;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.currentText = nil;
}

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
    [HMControllerTool setRootViewController];
}

/**
 *  跳转到注册界面
 */
- (IBAction)regist:(id)sender {
    NSLog(@"注册");
}

/**
 *  找回密码
 */
- (IBAction)backPassword:(id)sender {
    NSLog(@"找回密码");
}

#pragma mark 解决键盘遮挡文本框
-(void)keyBoardWillShow:(NSNotification *)notification
{
    NSDictionary *dict = [notification userInfo];
    CGRect keyboardFrame = [[dict objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.keyBoardH = keyboardFrame.size.height;
    CGFloat keyBoardToTop = MTScreenH - self.keyBoardH;
    NSInteger animationCurve =[[dict objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGFloat duration =  [[dict objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGRect currentTextFrame = [self.view convertRect:self.currentText.frame fromView:self.txtview];
    CGFloat currentTextBottomToTop = CGRectGetMaxY(currentTextFrame);
    
    if (keyBoardToTop - currentTextBottomToTop < 0) {
        [UIView animateWithDuration:duration delay:0 options:animationCurve animations:^{
            
            self.view.bounds = CGRectMake(0, -(keyBoardToTop-currentTextBottomToTop)+30, MTScreenW, MTScreenH);
            
        } completion:nil];
    }
}

-(void)keyBoardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.5 animations:^{
        self.view.bounds = CGRectMake(0, 0, MTScreenW, MTScreenH);
    }];
}


-(void)back
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


@end