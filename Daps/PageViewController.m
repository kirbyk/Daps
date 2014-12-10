//
//  PageViewController.m
//  Daps
//
//  Created by Austin Louden on 12/10/14.
//  Copyright (c) 2014 Macrolab. All rights reserved.
//

#import "PageViewController.h"
#import "LoginViewController.h"
#import <Parse/Parse.h>

@implementation PageViewController

- (id)initWithTransitionStyle:(UIPageViewControllerTransitionStyle)style navigationOrientation:(UIPageViewControllerNavigationOrientation)navigationOrientation options:(NSDictionary *)options
{
    if (self = [super initWithTransitionStyle:style navigationOrientation:navigationOrientation options:options]) {
        
    }
    
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    PFUser *user = [PFUser currentUser];
    if (!user) {
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        [self presentViewController:loginViewController animated:YES completion:nil];
    }
}


@end
