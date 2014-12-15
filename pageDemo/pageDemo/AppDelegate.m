//
//  AppDelegate.m
//  pageDemo
//
//  Created by ren kai on 27/12/2011.
//  Copyright (c) 2011 none. All rights reserved.
//

#import "AppDelegate.h"
#import "BlueViewController.h"
#import "RedViewController.h"
#import "YellowViewController.h"
#import "GreenViewController.h"
#import "PanBackNavController.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
    ZQHTabBarController *tabBarController=[[ZQHTabBarController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    BlueViewController *blueVC=[[BlueViewController alloc]init];
    RedViewController *redVC=[[RedViewController alloc]init];
    YellowViewController *yellowVC=[[YellowViewController alloc]init];
    GreenViewController *greenVC=[[GreenViewController alloc]init];
    
    ZQHTabBarItem *item1=[[ZQHTabBarItem alloc]initWithTitle:@"item1" titleNormalColor:[UIColor lightGrayColor] titleSelectedColor:[UIColor greenColor] imageNormal:[UIImage imageNamed:@"first_normal"] imageSelected:[UIImage imageNamed:@"first_selected"]];
    ZQHTabBarItem *item2=[[ZQHTabBarItem alloc]initWithTitle:@"item2" titleNormalColor:[UIColor lightGrayColor] titleSelectedColor:[UIColor greenColor] imageNormal:[UIImage imageNamed:@"second_normal"] imageSelected:[UIImage imageNamed:@"second_selected"]];
    ZQHTabBarItem *item3=[[ZQHTabBarItem alloc]initWithTitle:@"item3" titleNormalColor:[UIColor lightGrayColor] titleSelectedColor:[UIColor greenColor] imageNormal:[UIImage imageNamed:@"third_normal"] imageSelected:[UIImage imageNamed:@"third_selected"]];
    ZQHTabBarItem *item4=[[ZQHTabBarItem alloc]initWithTitle:@"item4" titleNormalColor:[UIColor lightGrayColor] titleSelectedColor:[UIColor greenColor] imageNormal:[UIImage imageNamed:@"first_normal"] imageSelected:[UIImage imageNamed:@"first_selected"]];
    
    [tabBarController setControllers:[NSArray arrayWithObjects:blueVC,redVC,yellowVC,greenVC, nil]];
    [tabBarController setTabBarItems:[NSArray arrayWithObjects:item1,item2,item3,item4, nil]];
    [tabBarController setTitleChangedAutomatically:NO];
    [tabBarController setTabBarItemAnimatableWhenClicked:NO];
    [tabBarController setTabBarItemAnimatableWhenScrolled:YES];
    [tabBarController setScrollEnabled:YES];
    
    PanBackNavController *nav=[[PanBackNavController alloc]initWithRootViewController:tabBarController];
    self.window.rootViewController = nav;
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
