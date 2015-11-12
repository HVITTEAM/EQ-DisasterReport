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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.contentTextView.layer.borderColor = [[UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:1.0] CGColor];
    self.contentTextView.layer.borderWidth = 0.5;
    self.contentTextView.font = [UIFont systemFontOfSize:15];
    self.contentTextView.text = self.contentStr;
    self.contentTextView.delegate = self;

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = self.titleStr;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if ([self.delegate respondsToSelector:@selector(fillContentViewController:filledContent:indexPath:)]) {
        [self.delegate fillContentViewController:self filledContent:self.contentTextView.text indexPath:self.indexpath];
    }
}


@end
