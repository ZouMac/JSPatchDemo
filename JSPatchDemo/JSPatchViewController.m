//
//  JSPatchViewController.m
//  JSPatchDemo
//
//  Created by tanzou on 2018/7/9.
//  Copyright © 2018年 Tanz. All rights reserved.
//

#import "JSPatchViewController.h"

@interface JSPatchViewController ()

@end

@implementation JSPatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 50)];
    [btn setTitle:@"Push JPTableViewController" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(handleBtn:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:btn];
}
    
- (void)handleBtn:(id)sender {
}

@end
