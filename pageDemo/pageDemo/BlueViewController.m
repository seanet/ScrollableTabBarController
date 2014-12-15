//
//  BlueViewController.m
//  pageDemo
//
//  Created by lmwl123 on 12/10/14.
//  Copyright (c) 2014 none. All rights reserved.
//

#import "BlueViewController.h"
#import "AppDelegate.h"
#import "SecondVC.h"

@interface BlueViewController ()

@end

@implementation BlueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"blue"];
}

- (IBAction)click:(id)sender {
    SecondVC *vc=[[SecondVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
