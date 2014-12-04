//
//  ViewController.m
//  Daps
//
//  Created by Kirby Kohlmorgen on 12/1/14.
//  Copyright (c) 2014 Macrolab. All rights reserved.
//

#import "MainViewController.h"
#import "LoginViewController.h"

#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <FacebookSDK/FacebookSDK.h>

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSDictionary *userData;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // table view setup
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellIdentifier"];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [self refreshUserData];
}

- (void)refreshUserData
{
    // get the cached active user
    PFUser *user = [PFUser currentUser];
    
    // if there is no active user, prompt login
    if (!user) {
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        [self presentViewController:loginViewController animated:YES completion:nil];
    } else {
        FBRequest *request = [FBRequest requestForMe];
        [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                
                // result is a dictionary with the user's Facebook data
                self.userData = (NSDictionary *)result;
                
                NSString *name = self.userData[@"name"];
                [user setObject:name forKeyedSubscript:@"name"];
                [user saveInBackground];
                //NSString *facebookID = self.userData[@"id"];
                //NSString *location = self.userData[@"location"][@"name"];
                //NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
                
                
                NSLog(@"USERNAME: %@", name);
            }
        }];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    cell.textLabel.text = @"hello";
    return cell;
}

#pragma mark - UITableViewDelegate


@end
