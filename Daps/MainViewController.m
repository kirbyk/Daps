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
#import "AppDelegate.h"

#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "UIImageView+WebCache.h"

#define HEADER_HEIGHT 90

@interface MainViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) NSDictionary *userData;
@property (nonatomic, strong) NSMutableArray *friendData;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
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
        UIViewController *rootController =(UIViewController*)[[(AppDelegate *)[[UIApplication sharedApplication]delegate] window] rootViewController];
        [rootController presentViewController:loginViewController animated:YES completion:nil];
    } else {
        
        FBRequest *requestMe = [FBRequest requestForMe];
        [requestMe startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                
                // result is a dictionary with the user's Facebook data
                self.userData = (NSDictionary *)result;
                
                //NSString *name = self.userData[@"name"];
                //[user setObject:name forKeyedSubscript:@"name"];
                //[user saveInBackground];
                //NSString *facebookID = self.userData[@"id"];
                //NSString *location = self.userData[@"location"][@"name"];
                //NSLog(@"USERNAME: %@", name);
            }
        }];
        
        FBRequest *requestFriends = [FBRequest requestForMyFriends];
        [requestFriends startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
        
                
                self.friendData = [NSMutableArray array];
                
                for (NSDictionary *friend in result[@"data"]) {
                    [self.friendData addObject:friend];
                }
                
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
    return CGSizeMake(CGRectGetWidth(self.view.frame)/3.0, CGRectGetWidth(self.view.frame)/3.0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *toId = [[self.friendData objectAtIndex:indexPath.item] objectForKey:@"id"];
    NSString *fromId = [self.userData objectForKey:@"id"];
    
    [self incrementAndSendFromCountFrom:fromId to:toId];
    [self incrementAndSendToCountFrom:fromId to:toId];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(CGRectGetWidth(self.view.frame), HEADER_HEIGHT);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
    
        UICollectionReusableView *headerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        
        headerView.backgroundColor = [UIColor blackColor];
        for (UIView *subview in [headerView subviews]) [subview removeFromSuperview];
        
        NSMutableAttributedString *attributedString;
        attributedString = [[NSMutableAttributedString alloc] initWithString:@"Friends"];
        [attributedString addAttribute:NSKernAttributeName value:@(-2) range:NSMakeRange(0, [attributedString length])];
        
        UILabel *lblHeader = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, CGRectGetWidth(self.view.frame), 45)];
        lblHeader.textColor = [UIColor whiteColor];
        lblHeader.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:42.0];
        lblHeader.attributedText = attributedString;
        [headerView addSubview:lblHeader];
        
        UILabel *countHeader = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lblHeader.frame)-8.0, CGRectGetWidth(self.view.frame), 45)];
        countHeader.textColor = [UIColor redColor];
        countHeader.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:42.0];
        countHeader.text = [NSString stringWithFormat:@"%d", (int)[self.friendData count]];
        [headerView addSubview:countHeader];
        
        reusableview = headerView;

        
    }
    
    return reusableview;
}

#pragma mark - Model Methods

- (void)incrementAndSendToCountFrom:(NSString *)fromId to:(NSString *)toId {
    PFQuery *query = [PFQuery queryWithClassName:@"Daps"];
    [query whereKey:@"facebookId" equalTo:fromId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if([objects count] > 0) {
                NSMutableDictionary *toCounts = [objects[0] objectForKey:@"toCounts"];
                NSNumber *currentToCount = [toCounts objectForKey:toId];
                int currentToCountInt = [currentToCount intValue];
                int newToCountInt = currentToCountInt + 1;
                NSNumber *newToCount = [NSNumber numberWithInt:newToCountInt];
                [toCounts setObject:newToCount forKey:toId];
                    
                objects[0][@"toCounts"] = toCounts;
                [objects[0] saveInBackground];
            } else {
                NSMutableDictionary *toCounts = [[NSMutableDictionary alloc] init];
                [toCounts setObject:[NSNumber numberWithInt:1] forKey:toId];
                
                PFObject *daps = [PFObject objectWithClassName:@"Daps"];
                daps[@"facebookId"] = fromId;
                daps[@"toCounts"] = toCounts;
                [daps saveInBackground];
            }
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)incrementAndSendFromCountFrom:(NSString *)fromId to:(NSString *)toId {
    PFQuery *query = [PFQuery queryWithClassName:@"Daps"];
    [query whereKey:@"facebookId" equalTo:toId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if([objects count] > 0) {
                NSMutableDictionary *fromCounts = [objects[0] objectForKey:@"fromCounts"];
                NSNumber *currentFromCount = [fromCounts objectForKey:fromId];
                int currentFromCountInt = [currentFromCount intValue];
                int newFromCountInt = currentFromCountInt + 1;
                NSNumber *newFromCount = [NSNumber numberWithInt:newFromCountInt];
                [fromCounts setObject:newFromCount forKey:fromId];
                
                objects[0][@"fromCounts"] = fromCounts;
                [objects[0] saveInBackground];
            } else {
                NSMutableDictionary *fromCounts = [[NSMutableDictionary alloc] init];
                [fromCounts setObject:[NSNumber numberWithInt:1] forKey:fromId];
                
                PFObject *daps = [PFObject objectWithClassName:@"Daps"];
                daps[@"facebookId"] = toId;
                daps[@"fromCounts"] = fromCounts;
                [daps saveInBackground];
            }
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

@end
