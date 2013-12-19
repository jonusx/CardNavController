//
//  MRCCardAnimationController.m
//  CardTransition
//
//  Created by mathew cruz on 12/18/13.
//  Copyright (c) 2013 mathew cruz. All rights reserved.
//

#import "MRCCardAnimationController.h"

@implementation MRCCardAnimationController

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.75;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {

    UIView *containerView = [transitionContext containerView];
    
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    CGRect offScreenFrame = [transitionContext initialFrameForViewController:fromViewController];
    offScreenFrame.origin.y = containerView.frame.size.height;
    toViewController.view.frame = offScreenFrame;
    
    [containerView addSubview:toViewController.view];
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 1.0/-900;
    transform = CATransform3DScale(transform, 0.85, 0.85, 1);
    transform = CATransform3DRotate(transform, 40.0f * M_PI/180.0f, 1, 0, 0);
    transform = CATransform3DTranslate(transform, 0, 0, -400.0);
    
//    offScreenFrame.origin.y = offScreenFrame.origin.y/3;
    
    [UIView animateWithDuration:.55 delay:0.0 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
        toViewController.view.frame = containerView.frame;
        //fromViewController.view.frame = offScreenFrame;
        fromViewController.view.layer.transform = transform;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
    
}


@end
