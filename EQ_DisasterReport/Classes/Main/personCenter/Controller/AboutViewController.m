//
//  AboutViewController.m
//  EQ_DisasterReport
//
//  Created by shi on 15/11/21.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "AboutViewController.h"
#import "UseHelpViewController.h"
#import "WebsitViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initHeadView];
    [self initFootView];
    self.tableView.backgroundColor = HMGlobalBg;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    
}

-(void)initHeadView
{
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, 150)];
    self.tableView.tableHeaderView = headView;
    
    CGFloat x = (MTScreenW-60)/2;
    CGFloat y = 20;
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, 60, 60)];
    iconImageView.image = [UIImage imageNamed:@"headIcon"];
    [headView addSubview:iconImageView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(iconImageView.frame)+5,MTScreenW, 20)];
    nameLabel.font = [UIFont boldSystemFontOfSize:13];
    nameLabel.textColor = [UIColor darkTextColor];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.text = @"地震信息采集";
    [headView addSubview:nameLabel];
    
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(nameLabel.frame), MTScreenW, 20)];
    versionLabel.font = [UIFont systemFontOfSize:15];
    versionLabel.textColor = [UIColor redColor];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.text = @"1.0.0";
    [headView addSubview:versionLabel];
}

-(void)initFootView
{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, MTScreenH-144, MTScreenW, 60)];
    //footView.backgroundColor = [UIColor redColor];
    [self.tableView addSubview: footView];
    
    UILabel *promtLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, 20)];
    promtLabel.textColor = [UIColor lightGrayColor];
    promtLabel.font = [UIFont systemFontOfSize:10];
    promtLabel.textAlignment = NSTextAlignmentCenter;
    promtLabel.text = @"客服电话(按当地市话标准计算)";
    [footView addSubview:promtLabel];
    
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(promtLabel.frame), MTScreenW, 20)];
    NSString *str = @"联系电话: 8888-88888888";
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
    
    NSDictionary *attribute1 = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:13],
                                 NSForegroundColorAttributeName:[UIColor blackColor]
                                 };
    NSDictionary *attribute2 = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:15],
                                 NSForegroundColorAttributeName:[UIColor blueColor]
                                 };
    [attrString setAttributes:attribute1 range:NSMakeRange(0, str.length)];
    [attrString setAttributes:attribute2 range:[str rangeOfString:@"8888-88888888"]];
    phoneLabel.attributedText = attrString;
    phoneLabel.textAlignment = NSTextAlignmentCenter;
    [footView addSubview:phoneLabel];

    UILabel *copyrightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(phoneLabel.frame), MTScreenW, 20)];
    copyrightLabel.textColor = [UIColor lightGrayColor];
    copyrightLabel.font = [UIFont systemFontOfSize:10];
    copyrightLabel.textAlignment = NSTextAlignmentCenter;
    copyrightLabel.text = @"Copyright ©1996-2015 SINA Corporation)";
    [footView addSubview:copyrightLabel];
    //为 phoneLabel添加手势 用来打电话
    phoneLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhone:)];
    recognizer.numberOfTapsRequired = 1;
    recognizer.numberOfTouchesRequired = 1;
    [phoneLabel addGestureRecognizer:recognizer];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 3;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"aboutCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSInteger rowNum = indexPath.row;
    
    if (rowNum == 0) {
        cell.textLabel.text = @"给我评分";
    }else if (rowNum == 1){
        cell.textLabel.text = @"官方网站";
    }else{
        cell.textLabel.text = @"常见问题";
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
    }else if (indexPath.row == 1){
        WebsitViewController *websitVC = [[WebsitViewController alloc] init];
        [self.navigationController pushViewController:websitVC animated:YES];
    }else{
        UseHelpViewController *helpVC = [[UseHelpViewController alloc] init];
        [self.navigationController pushViewController:helpVC animated:YES];
    }
}

-(void)callPhone:(UITapGestureRecognizer *)recognizer
{
    UIWebView*callWebview =[[UIWebView alloc] init];
    NSURL *telURL =[NSURL URLWithString:[NSString stringWithFormat:@"tel:8888-88888888"]];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.tableView addSubview:callWebview];
}

@end
