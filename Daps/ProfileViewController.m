//
//  ProfileViewController.m
//  Daps
//
//  Created by Austin Louden on 12/7/14.
//  Copyright (c) 2014 Macrolab. All rights reserved.
//

#import "ProfileViewController.h"

#import <FacebookSDK/FacebookSDK.h>

@implementation ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    FBRequest *requestMe = [FBRequest requestForMe];
    [requestMe startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            
            // result is a dictionary with the user's Facebook data
            //self.userData = (NSDictionary *)result;
            
            //NSString *name = self.userData[@"name"];
            //[user setObject:name forKeyedSubscript:@"name"];
            //[user saveInBackground];
            //NSString *facebookID = self.userData[@"id"];
            //NSString *location = self.userData[@"location"][@"name"];
            //NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            
            //NSLog(@"USERNAME: %@", name);
        }
    }];
}

@end
