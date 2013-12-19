//
//  MRCNavControllerDelegate.m
//  CardTransition
//
//  Created by mathew cruz on 12/18/13.
//  Copyright (c) 2013 mathew cruz. All rights reserved.
//

#import "MRCNavControllerDelegate.h"
#import "MRCCardAnimationController.h"
#import "MRCPopCardAnimationController.h"

@interface MRCNavControllerDelegate () <UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *percentController;
@property (nonatomic, strong) MRCCardAnimationController *cardAnimationController;
@property (nonatomic, strong) MRCPopCardAnimationController *popAnimationController;
@property (nonatomic) BOOL shouldComplete;
@end

@implementation MRCNavControllerDelegate

- (void)awakeFromNib {
    UIPanGestureRecognizer *panner = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
    [self.navigationController.view addGestureRecognizer:panner];
    self.navigationController.delegate = self;
}

- (void)onPan:(UIPanGestureRecognizer *)pan {
    
    CGPoint translation = [pan translationInView:pan.view.superview];
    switch (pan.state) {
        case UIGestureRecognizerStateBegan: {
            
            self.percentController = [UIPercentDrivenInteractiveTransition new];
            if (self.percentController.percentComplete > 0.0) {
                break;
            }
            if (translation.y > 0) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else {
                UIViewController *controller = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"MRCViewController"];
                controller.transitioningDelegate  = self;
                [self.navigationController pushViewController:controller animated:YES];
            }
            
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGFloat dragAmount = self.navigationController.view.frame.size.height/1.5;
            CGFloat percent = abs(translation.y) / dragAmount;
            percent = fmaxf(percent, 0.0);
            percent = fminf(percent, 0.99);
            [self.percentController updateInteractiveTransition:percent];
            self.shouldComplete = percent >= 0.5;
            
            break;
        }
            
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            if (pan.state == UIGestureRecognizerStateCancelled || !self.shouldComplete) {
                [self.percentController cancelInteractiveTransition];
            } else {
                [self.percentController finishInteractiveTransition];
            }
            
            self.popAnimationController = nil;
            self.cardAnimationController = nil;
            self.percentController = nil;
            break;
        }
            
            
        default:
            break;
    }
}


//Lazy load this baby
- (MRCCardAnimationController *)cardAnimationController {
    if (_cardAnimationController) {
        return _cardAnimationController;
    }
    _cardAnimationController = [MRCCardAnimationController new];
    return _cardAnimationController;
}

- (MRCPopCardAnimationController *)popAnimationController {
    if (_popAnimationController) {
        return _popAnimationController;
    }
    _popAnimationController = [MRCPopCardAnimationController new];
    return _popAnimationController;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPush) {
        return self.cardAnimationController;
    }
    return self.popAnimationController;
}

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
    return self.percentController;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
