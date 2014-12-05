//
//  ViewController.m
//  Daps
//
//  Created by Kirby Kohlmorgen on 12/1/14.
//  Copyright (c) 2014 Macrolab. All rights reserved.
//

#import "MainViewController.h"
#import "LoginViewController.h"
#import "FriendsCollectionViewCell.h"

#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "UIImageView+WebCache.h"

@interface MainViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) NSDictionary *userData;
@property (nonatomic, strong) NSMutableArray *friendData;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    // data source
    self.friendData = [NSMutableArray array];
    
    // collection view setup
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0.0;
    layout.minimumLineSpacing = 0.0;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[FriendsCollectionViewCell class] forCellWithReuseIdentifier:@"friendCellIdentifier"];
    
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
        FBRequest *requestMe = [FBRequest requestForMe];
        [requestMe startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
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
        
        FBRequest *requestFriends = [FBRequest requestForMyFriends];
        [requestFriends startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
        
                for (NSDictionary *friend in result[@"data"]) {
                    [self.friendData addObject:friend];
                }
                
#warning add more friends (this is adding Kirby i times)
                [self.friendData addObject:self.userData];
                [self.friendData addObject:self.userData];
                [self.friendData addObject:[self.friendData objectAtIndex:0]];
                [self.friendData addObject:[self.friendData objectAtIndex:0]];
                [self.friendData addObject:self.userData];
                [self.friendData addObject:self.userData];
                [self.friendData addObject:[self.friendData objectAtIndex:0]];
                
                [self.collectionView reloadData];
                
            }
        }];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.friendData count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FriendsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"friendCellIdentifier" forIndexPath:indexPath];
    
    // need to determine whether content should be drawn left, center, or right
    
    //if (indexPath.section % 2 == 0) cell.backgroundColor = [UIColor blueColor];
    //else cell.backgroundColor = [UIColor orangeColor];
    
    NSString *facebookID = [[self.friendData objectAtIndex:indexPath.row] objectForKey:@"id"];
    NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
    [cell.imageView sd_setImageWithURL:imageURL];
    
    cell.name = [[self.friendData objectAtIndex:indexPath.row] objectForKey:@"name"];

    
    
    return cell;
}

#pragma mark - UICollectionViewFlowLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section % 2 == 0) return CGSizeMake(CGRectGetWidth(self.view.frame)/2.0, CGRectGetWidth(self.view.frame)/2.0);
    else return CGSizeMake(CGRectGetWidth(self.view.frame)/2.0, CGRectGetWidth(self.view.frame)/2.0);
}

@end
