//
//  MRCViewController.m
//  CardTransition
//
//  Created by mathew cruz on 12/18/13.
//  Copyright (c) 2013 mathew cruz. All rights reserved.
//

#import "MRCViewController.h"
#import "MRCCardAnimationController.h"
#import "MRCPopCardAnimationController.h"

@interface MRCViewController () <UINavigationControllerDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation MRCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.countLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.navigationController.childViewControllers.count];
    
    self.view.backgroundColor = (self.navigationController.childViewControllers.count % 2) ? [UIColor whiteColor] : [UIColor redColor];
}

- (IBAction)push:(id)sender {
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MRCViewController"];
    controller.transitioningDelegate = (id<UIViewControllerTransitioningDelegate>)self.navigationController.delegate;
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)pop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
