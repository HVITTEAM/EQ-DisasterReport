//
//  UseHelpViewController.m
//  EQCollect_HD
//
//  Created by shi on 15/10/24.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "UseHelpViewController.h"

@interface UseHelpViewController ()

@end

@implementation UseHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"常见问题";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_icon_white"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
