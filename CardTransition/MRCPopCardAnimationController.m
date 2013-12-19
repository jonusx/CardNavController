//
//  MRCPopCardAnimationController.m
//  CardTransition
//
//  Created by mathew cruz on 12/18/13.
//  Copyright (c) 2013 mathew cruz. All rights reserved.
//

#import "MRCPopCardAnimationController.h"

@interface MRCPopCardAnimationController ()
@property (nonatomic, strong) UINavigationController *viewController;
@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@property (nonatomic) BOOL shouldComplete;
@end

@implementation MRCPopCardAnimationController

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.75;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *inView = [transitionContext containerView];
    
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    CGRect offScreenFrame = [transitionContext initialFrameForViewController:fromViewController];
    offScreenFrame.origin.y = inView.frame.size.height;
    toViewController.view.frame = offScreenFrame;
    
    [inView insertSubview:toViewController.view belowSubview:fromViewController.view];
    
    offScreenFrame.origin.y = offScreenFrame.origin.y/2;
    toViewController.view.frame = offScreenFrame;
    toViewController.view.layer.anchorPoint = CGPointMake(0.5, 1.0);
    offScreenFrame.origin.y = offScreenFrame.origin.y * 2;
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 1.0/-900;
    transform = CATransform3DScale(transform, 0.85, 0.85, 1);
    transform = CATransform3DRotate(transform, 40.0f * M_PI/180.0f, 1, 0, 0);
    transform = CATransform3DTranslate(transform, 0, 0, -400.0);
    
    toViewController.view.layer.transform = transform;
    
    [UIView animateWithDuration:.55 delay:0.0 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
        toViewController.view.frame = inView.frame;
        toViewController.view.layer.transform = CATransform3DIdentity;
        fromViewController.view.frame = offScreenFrame;
    } completion:^(BOOL finished) {
        //[fromViewController.view removeFromSuperview];
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
    
}

@end
