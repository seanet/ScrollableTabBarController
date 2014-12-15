//
//  PanBackNavController.m
//  PanBackViewController
//
//  Created by zhaoqihao on 11/24/14.
//  Copyright (c) 2014 com.zhaoqihao. All rights reserved.
//

#import "PanBackNavController.h"
#import "Animator.h"

@interface PanBackNavController ()

@property (nonatomic,strong)Animator *animator;
@property (strong, nonatomic) UIPercentDrivenInteractiveTransition *interactionController;

@end

@implementation PanBackNavController
@synthesize animator=_animator,interactionController=_interactionController;

- (void)viewDidLoad {
    [super viewDidLoad];

//    __weak typeof(self) weakSelf=self;
//    if([self respondsToSelector:NSSelectorFromString(@"interactivePopGestureRecognizer")])
//        self.interactivePopGestureRecognizer.delegate=weakSelf;
    
    [self prepare];
}

-(void)prepare{
    _animator=[[Animator alloc]init];
    
    self.interactivePopGestureRecognizer.enabled=NO;
    
    UIPanGestureRecognizer *panGes=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:panGes];
    
    [self setDelegate:self];
}

-(void)pan:(UIPanGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateBegan) {
        CGPoint location = [sender locationInView:self.view];
        if (location.x <  self.view.bounds.size.width/3 && self.viewControllers.count > 1){ // left half
            self.interactionController = [[UIPercentDrivenInteractiveTransition alloc]init];
            [self popViewControllerAnimated:YES];
        }
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [sender translationInView:self.view];
        CGFloat d = fabs(translation.x / CGRectGetWidth(self.view.bounds));
        [self.interactionController updateInteractiveTransition:d];
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint translation = [sender translationInView:self.view];
        if ([sender velocityInView:self.view].x > 50||(translation.x>=100)) {
            [self.interactionController finishInteractiveTransition];
        } else {
            [self.interactionController cancelInteractiveTransition];
        }
        self.interactionController = nil;
    }

}

//-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
//    if([self respondsToSelector:NSSelectorFromString(@"SwipeBackNavController")])
//        self.interactivePopGestureRecognizer.enabled=NO;
//    
//    [super pushViewController:viewController animated:animated];
//}

#pragma mark - nav delegate

//-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
//    if([navigationController respondsToSelector:NSSelectorFromString(@"interactivePopGestureRecognizer")])
//       [navigationController.interactivePopGestureRecognizer setEnabled:YES];
//}

-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    if(operation==UINavigationControllerOperationPop)
        return self.animator;
    
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
    return self.interactionController;
}

@end
