//
//  CollectInfoViewController.m
//  EQ_DisasterReport
//
//  Created by shi on 15/11/6.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "CollectInfoViewController.h"
#import "SpotInfoCell.h"

@interface CollectInfoViewController ()

@end

@implementation CollectInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UINib *cellNib = [UINib nibWithNibName:@"SpotInfoCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"spotInfoCell"];
    [self initNaviBar];
}

-(void)initNaviBar
{
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftItem;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"新增" style:UIBarButtonItemStylePlain target:self action:@selector(addNewSpotInfo)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.navigationItem.title = @"采集信息列表";
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *spotInfoCellID = @"spotInfoCell";
    SpotInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:spotInfoCellID];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

-(void)addNewSpotInfo
{

}

-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
