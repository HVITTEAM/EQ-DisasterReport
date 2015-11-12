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

@interface PersonCenterViewController ()<UIScrollViewDelegate>
@property(nonatomic,strong)PersonCenterHeadView *headView;

@end

@implementation PersonCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initNavigation];
    [self initHeadView];
    
    [self setupGroups];
    
    self.tableView.rowHeight = 50;
    self.tableView.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;

}

-(void)initHeadView
{
    self.tableView.contentInset = UIEdgeInsetsMake(224, 0, 0, 0);
    self.headView = [[[NSBundle mainBundle] loadNibNamed:@"PersonCenterHeadView" owner:self options:nil] lastObject];
    self.headView.frame = CGRectMake(0, -244, MTScreenW, 224);
    [self.tableView addSubview:self.headView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

/**
 *  初始化导航栏
 */
-(void)initNavigation
{
    self.title = @"个人中心";
    self.view.backgroundColor = HMGlobalBg;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

# pragma  mark 设置数据源
/**
 *  初始化模型数据
 */
- (void)setupGroups
{
    //每次刷新数据源的时候需要将数据源清空
    [self.groups removeAllObjects];
    
    //重置数据源
    //[self setupGroup0];
    [self setupGroup1];
    
    //[self setupFooter];
    
    //刷新表格
    [self.tableView reloadData];
}

- (void)setupGroup1
{
    // 1.创建组
    HMCommonGroup *group = [HMCommonGroup group];
    [self.groups addObject:group];
    
    // 设置组的所有行数据
    HMCommonArrowItem *account = [HMCommonArrowItem itemWithTitle:@"帐号管理" icon:nil];
    account.icon = @"headIcon";
    
    HMCommonArrowItem *version = [HMCommonArrowItem itemWithTitle:@"版本信息" icon:nil];
    version.icon = @"headIcon";
    //version.destVcClass = [VersionViewController class];
    version.operation = ^{
    };
    
    HMCommonArrowItem *help = [HMCommonArrowItem itemWithTitle:@"使用帮助" icon:nil];
    help.icon = @"headIcon";
    
    HMCommonArrowItem *advice = [HMCommonArrowItem itemWithTitle:@"意见反馈" icon:nil];
    advice.icon = @"headIcon";
    
    group.items = @[account,version,help,advice];
}

-(void)back
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat y = scrollView.contentOffset.y;
    if (y<=-224) {
        CGRect frame = self.headView.frame;
        frame.size.height = -y;
        frame.origin.y = y;
        self.headView.frame = frame;
    }
//    if (scrollView.contentOffset.y >=-224) {
//        self.headView.y = -224;
//    }
    
}

@end
