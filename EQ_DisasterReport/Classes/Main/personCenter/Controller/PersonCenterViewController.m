//
//  PersonCenterViewController.m
//  EQ_DisasterReport
//
//  Created by shi on 15/11/12.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "PersonCenterViewController.h"
#import "HMCommonArrowItem.h"
#import "HMCommonGroup.h"
#import "PersonCenterHeadView.h"
#import "AboutViewController.h"
#import "FeedbackView.h"
#import "AccountTableViewController.h"
#import "LoginUser.h"

#define headViewHeight 224

@interface PersonCenterViewController ()<UIScrollViewDelegate>

@property(nonatomic,strong)PersonCenterHeadView *headView;         //头部 view

@end

@implementation PersonCenterViewController

#pragma mark -- 生命周期方法 --

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initNavigation];
    
    [self initHeadView];
    
    [self setupGroups];
    
    self.tableView.rowHeight = 50;
    self.tableView.delegate = self;
    self.view.backgroundColor = HMGlobalBg;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

#pragma mark -- 初始化子控件方法 --
/**
 *  初始化头部视图
 */
-(void)initHeadView
{
    self.tableView.contentInset = UIEdgeInsetsMake(headViewHeight, 0, 0, 0);
    
    self.headView = [[[NSBundle mainBundle] loadNibNamed:@"PersonCenterHeadView" owner:self options:nil] lastObject];
    self.headView.frame = CGRectMake(0, -headViewHeight - 20, MTScreenW, headViewHeight);
    
    UIImage *bkimage = [UIImage imageNamed:@"personCenterHeadBK"];
    self.headView.headBKImageView.image = [bkimage resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
    
    self.headView.userNameLb.text = [LoginUser shareInstance].username;
    
    [self.tableView insertSubview:self.headView atIndex:0];
}

/**
 *  初始化导航栏
 */
-(void)initNavigation
{
    self.title = @"个人中心";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_icon_white"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.barTintColor = HMColor(99, 148, 225);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark -- 协议方法 --
#pragma mark UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat y = scrollView.contentOffset.y;
    if (y<=-headViewHeight) {
        CGRect frame = self.headView.frame;
        frame.size.height = -y;
        frame.origin.y = y;
        self.headView.frame = frame;
    }
}

#pragma mark -- 内部方法 --
# pragma  mark 设置数据源
/**
 *  初始化模型数据
 */
- (void)setupGroups
{
    //每次刷新数据源的时候需要将数据源清空
    [self.groups removeAllObjects];
    
    //重置数据源
    [self setupGroup1];
    
    //刷新表格
    [self.tableView reloadData];
}

- (void)setupGroup1
{
    //__weak typeof(self)weakSelf = self;
    
    // 1.创建组
    HMCommonGroup *group = [HMCommonGroup group];
    [self.groups addObject:group];
    
    // 设置组的所有行数据
    HMCommonArrowItem *account = [HMCommonArrowItem itemWithTitle:@"帐号管理" icon:nil];
    account.icon = @"account_icon";
    account.destVcClass = [AccountTableViewController class];
    
    HMCommonArrowItem *about = [HMCommonArrowItem itemWithTitle:@"关于" icon:nil];
    about.icon = @"about_icon";
    about.destVcClass = [AboutViewController class];
    about.operation = ^{
    };
    
//    HMCommonArrowItem *advice = [HMCommonArrowItem itemWithTitle:@"意见反馈" icon:nil];
//    advice.icon = @"user_info_Icon";
//    advice.operation = ^{
//        FeedbackView *feedbackView = [[FeedbackView alloc] init];
//        [feedbackView showViewtoFatherView:weakSelf.navigationController.view];
//    };
    
    group.items = @[account,about];
}

-(void)back
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc
{
    NSLog(@"PersonCenterViewController 释放");
}

@end
