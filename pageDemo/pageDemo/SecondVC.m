//
//  SecondVC.m
//  pageDemo
//
//  Created by lmwl123 on 12/15/14.
//  Copyright (c) 2014 none. All rights reserved.
//

#import "SecondVC.h"
#import "ThirdVC.h"

@interface SecondVC ()

@end

@implementation SecondVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"SecondVC"];
}

- (IBAction)click:(id)sender {
    ThirdVC *vc=[[ThirdVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
