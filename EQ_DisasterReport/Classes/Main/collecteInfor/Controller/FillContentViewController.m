//
//  FillContentViewController.m
//  EQ_DisasterReport
//
//  Created by shi on 15/11/10.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "FillContentViewController.h"

@interface FillContentViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *contentTextView; //让用户填写内容的文本框

@end

@implementation FillContentViewController

#pragma mark -- 生命周期方法 --
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //设置导航栏
    self.navigationItem.title = self.titleStr;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_icon_white"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //设置文本输入框
    self.contentTextView.layer.borderColor = [[UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:1.0] CGColor];
    self.contentTextView.layer.borderWidth = 0.5;
    self.contentTextView.font = [UIFont systemFontOfSize:15];
    self.contentTextView.text = self.contentStr;
    self.contentTextView.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if ([self.delegate respondsToSelector:@selector(fillContentViewController:filledContent:indexPath:)]) {
        [self.delegate fillContentViewController:self filledContent:self.contentTextView.text indexPath:self.indexpath];
    }
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc
{
    NSLog(@"FillContentViewController  释放了吗");
}

@end
