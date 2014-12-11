//
//  ZQHTabBarController.h
//  pageDemo
//
//  Created by lmwl123 on 12/10/14.
//  Copyright (c) 2014 zhaoqihao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

//IMPORTANT: Please make sure this Controller is in an UINavigationController. If you don't want the navigation bar, you can hide it.
//Please add the QuartzCore.framework into your project.

#define ZQHTBC_TABBAR_BACKGROUNDCOLOR [UIColor colorWithWhite:0.92 alpha:1.0] //tabbar's background color
#define ZQHTBC_TABBAR_IMAGESIZE 30

@interface ZQHTabBarController : UIPageViewController <UIPageViewControllerDelegate,UIPageViewControllerDataSource,UIScrollViewDelegate>

@property (strong,nonatomic) NSArray *controllers;
@property (strong,nonatomic) NSArray *tabBarItems;

@property (weak,nonatomic,readonly) UIView *separateLine;

@property (assign,nonatomic,getter=isNavigationBarHidden) BOOL navigationBarHidden;

@end

//tabBar Item
@interface ZQHTabBarItem : UIView

-(id)initWithTitle:(NSString *)title titleNormalColor:(UIColor *)normalColor titleSelectedColor:(UIColor *)selectedColor imageNormal:(UIImage *)imageNormal imageSelected:(UIImage *)imageSelected;

@end
