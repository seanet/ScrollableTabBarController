//
//  Animator.m
//  PanBackViewController
//
//  Created by zhaoqihao on 11/25/14.
//  Copyright (c) 2014 com.zhaoqihao. All rights reserved.
//

#import "Animator.h"

@implementation Animator

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromVC=[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC=[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    [[transitionContext containerView]addSubview:toVC.view];
    toVC.view.alpha=0;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        [fromVC.view.layer setTransform:CATransform3DMakeScale(0.1, 0.1, 0.1)];
        toVC.view.alpha=1;
    }completion:^(BOOL finished){
        [fromVC.view.layer setTransform:CATransform3DIdentity];
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

//-(void)animationEnded:(BOOL)transitionCompleted{
//
//}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.25;
}

@end
