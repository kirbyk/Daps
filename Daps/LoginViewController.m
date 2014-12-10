//
//  LoginViewController.m
//  Daps
//
//  Created by Kirby Kohlmorgen on 12/1/14.
//  Copyright (c) 2014 Macrolab. All rights reserved.
//

#import "LoginViewController.h"
#import "MainViewController.h"
#import "PageViewController.h"

#import "FUIButton.h"
#import "UIColor+FlatUI.h"
#import "UIFont+FlatUI.h"

#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    FUIButton *button = [[FUIButton alloc] initWithFrame:CGRectMake(50.0, 140.0, 240.0, 40.0)];
    [button addTarget:self
               action:@selector(loginWithFacebook)
     forControlEvents:UIControlEventTouchUpInside];
    button.buttonColor = [UIColor peterRiverColor];
    button.shadowColor = [UIColor belizeHoleColor];
    button.shadowHeight = 3.0f;
    button.cornerRadius = 6.0f;
    button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
    [button setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    [button setTitle:@"Continue with Facebook" forState:UIControlStateNormal];
    button.center = self.view.center;
    button.frame = CGRectMake(button.frame.origin.x, CGRectGetMaxY(self.view.frame) - 80.0f, button.frame.size.width, button.frame.size.height);
    [self.view addSubview:button];
    
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_bg.jpg"]];
    backgroundImage.frame = self.view.frame;
    backgroundImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];
    
    NSMutableAttributedString *attributedCount;
    attributedCount = [[NSMutableAttributedString alloc] initWithString:@"Daps."];
    [attributedCount addAttribute:NSKernAttributeName value:@(-7) range:NSMakeRange(0, [attributedCount length])];
    
    UILabel *dapsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 200.0, CGRectGetWidth(self.view.frame), 200.0)];
    dapsLabel.attributedText = attributedCount;
    dapsLabel.center = self.view.center;
    dapsLabel.textAlignment = NSTextAlignmentCenter;
    dapsLabel.textColor = [UIColor whiteColor];
    dapsLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:90.0f];
    [self.view addSubview:dapsLabel];
    
}

- (void)loginWithFacebook
{
    NSArray *permissions = [NSArray arrayWithObjects:@"public_profile", @"email", @"user_friends", nil];
    [PFFacebookUtils logInWithPermissions:permissions block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"The user cancelled the Facebook login. %@", error);
        } else if (user.isNew) {
            PageViewController *pageViewController = (PageViewController *)self.presentingViewController;
            [self dismissViewControllerAnimated: YES completion: ^{
                [(MainViewController *)[pageViewController.viewControllers objectAtIndex:0] refreshUserData];
            }];
        } else {
            PageViewController *pageViewController = (PageViewController *)self.presentingViewController;
            [self dismissViewControllerAnimated: YES completion: ^{
                [(MainViewController *)[pageViewController.viewControllers objectAtIndex:0] refreshUserData];
            }];
        }
    }];
}

@end
