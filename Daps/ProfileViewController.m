//
//  ProfileViewController.m
//  Daps
//
//  Created by Austin Louden on 12/7/14.
//  Copyright (c) 2014 Macrolab. All rights reserved.
//

#import "ProfileViewController.h"

#import "UIImageView+WebCache.h"

#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>

#define PROFILE_HEADER_HEIGHT 90

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIImageView *mainImageView;
@property (nonatomic, strong) UIImageView *subImageView;
@property (nonatomic, strong) UILabel *mainNameLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UILabel *dapsCountLabel;
@property (nonatomic, strong) NSMutableArray *friendData;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *topFriends;

@property (nonatomic, strong) NSDictionary *userData;
@end

@implementation ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBar.hidden = YES;
    
    // header
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.frame), PROFILE_HEADER_HEIGHT)];
    headerView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:headerView];
    
    // profile label
    UILabel *profileLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, CGRectGetWidth(self.view.frame), 45)];
    profileLabel.textColor = [UIColor whiteColor];
    profileLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:42.0];
    [headerView addSubview:profileLabel];
    
    NSMutableAttributedString *attributedString;
    attributedString = [[NSMutableAttributedString alloc] initWithString:@"Daps"];
    [attributedString addAttribute:NSKernAttributeName value:@(-2) range:NSMakeRange(0, [attributedString length])];
    profileLabel.attributedText = attributedString;
    
    // daps count label
    self.dapsCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(profileLabel.frame)-8.0, CGRectGetWidth(self.view.frame), 45)];
    self.dapsCountLabel.textColor = [UIColor redColor];
    self.dapsCountLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:42.0];
    [headerView addSubview:self.dapsCountLabel];
    
    // blurred profile picture (main)
    self.mainImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, PROFILE_HEADER_HEIGHT, CGRectGetWidth(self.view.frame), CGRectGetWidth(self.view.frame))];
    self.mainImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.mainImageView.clipsToBounds = YES;
    [self.view addSubview:self.mainImageView];
    
    UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectView.frame = self.mainImageView.bounds;
    [self.mainImageView addSubview:visualEffectView];
    
    // clear profile picture (sub)
    self.subImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.frame)/3.0, CGRectGetWidth(self.view.frame)/3.0)];
    self.subImageView.center = self.mainImageView.center;
    self.subImageView.layer.cornerRadius = CGRectGetWidth(self.subImageView.frame)/2.0;
    self.subImageView.layer.masksToBounds = YES;
    self.subImageView.frame = CGRectMake(self.subImageView.frame.origin.x, PROFILE_HEADER_HEIGHT + 70, CGRectGetWidth(self.subImageView.frame), CGRectGetHeight(self.subImageView.frame));
    [self.view addSubview:self.subImageView];
    
    // main name label
    self.mainNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(self.subImageView.frame)+10.0, CGRectGetWidth(self.view.frame), 30.0)];
    self.mainNameLabel.textAlignment = NSTextAlignmentCenter;
    self.mainNameLabel.textColor = [UIColor whiteColor];
    self.mainNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:24.0];
    [self.view addSubview:self.mainNameLabel];
    
    // subtitle label (x daps from y friends)
    self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(self.mainNameLabel.frame)-5, CGRectGetWidth(self.view.frame), 30.0)];
    self.subtitleLabel.textAlignment = NSTextAlignmentCenter;
    self.subtitleLabel.textColor = [UIColor colorWithWhite:(215.0/255.0) alpha:1.0];
    self.subtitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0];
    [self.view addSubview:self.subtitleLabel];
    
    // top friends label
    UILabel *topFriendsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, CGRectGetMaxY(self.mainImageView.frame), CGRectGetWidth(self.view.frame), 40.0)];
    topFriendsLabel.textColor = [UIColor colorWithWhite:(215.0/255.0) alpha:1.0];
    topFriendsLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0];
    [self.view addSubview:topFriendsLabel];
    
    NSMutableAttributedString *topFriendsString;
    topFriendsString = [[NSMutableAttributedString alloc] initWithString:@"TOP FRIENDS"];
    [topFriendsString addAttribute:NSKernAttributeName value:@(-1) range:NSMakeRange(0, [attributedString length])];
    topFriendsLabel.attributedText = topFriendsString;
    
    // top friends table
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(topFriendsLabel.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-CGRectGetMaxY(topFriendsLabel.frame)) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellIdentifier"];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    FBRequest *requestMe = [FBRequest requestForMe];
    [requestMe startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            
            // result is a dictionary with the user's Facebook data
            self.userData = (NSDictionary *)result;
            self.topFriends = [NSMutableArray array];
            
            // set the profile images (blurred and clear)
            NSString *facebookID = self.userData[@"id"];
            NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            [self.mainImageView sd_setImageWithURL:imageURL];
            [self.subImageView sd_setImageWithURL:imageURL];
            
            // set the user's name
            NSMutableAttributedString *attributedString;
            attributedString = [[NSMutableAttributedString alloc] initWithString:self.userData[@"name"]];
            [attributedString addAttribute:NSKernAttributeName value:@(-1) range:NSMakeRange(0, [attributedString length])];
            self.mainNameLabel.attributedText = attributedString;
            
            PFQuery *query = [PFQuery queryWithClassName:@"Daps"];
            [query whereKey:@"facebookId" equalTo:facebookID];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    
                    NSMutableDictionary *fromCounts = [objects[0] objectForKey:@"fromCounts"];
                    NSMutableDictionary *toCounts = [objects[0] objectForKey:@"toCounts"];
                    
                    NSLog(@"%@", fromCounts);
                    
                    // get the total count of daps for the user
                    int dapsCount = 0;
                    for (NSString *key in [fromCounts allKeys]) {
                        dapsCount += [[fromCounts objectForKey:key] intValue];
                    }
                    
                    // set the count number in the header
                    NSMutableAttributedString *attributedCount;
                    attributedCount = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", dapsCount]];
                    [attributedCount addAttribute:NSKernAttributeName value:@(-2) range:NSMakeRange(0, [attributedCount length])];
                    self.dapsCountLabel.attributedText = attributedCount;
                    
                    // set the subtitle string
                    NSMutableAttributedString *attributedSubtitle;
                    attributedSubtitle = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d daps from %d friends", dapsCount, (int)[fromCounts count]]];
                    [attributedSubtitle addAttribute:NSKernAttributeName value:@(-1) range:NSMakeRange(0, [attributedCount length])];
                    self.subtitleLabel.attributedText = attributedSubtitle;
                    
                    // sort the friends by order of importance (most daps)
                    NSArray *sortedFromCountsKeys = [NSArray array];
                    if(fromCounts != nil) {
                        sortedFromCountsKeys = [self sortCountsKeys:fromCounts];
                    }
                    
                    NSLog(@"SortedFromCounts: %@", sortedFromCountsKeys);
                    
                    // get details of friends
                    FBRequest *requestFriends = [FBRequest requestForMyFriends];
                    [requestFriends startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                        if (!error) {
                            self.friendData = [NSMutableArray array];
                            for (NSDictionary *friend in result[@"data"]) {
                                [self.friendData addObject:friend];
                            }
                            
                            NSLog(@"%@", self.friendData);
                            
                            for (NSString *facebookID in sortedFromCountsKeys) {
                                int count = [[fromCounts objectForKey:facebookID] intValue];
                                NSString *name;
                                for (NSDictionary *friend in self.friendData) {
                                    if([facebookID isEqualToString:friend[@"id"]])
                                        name = friend[@"name"];
                                }
                                
                                [self.topFriends addObject:@{name: [NSNumber numberWithInt:count]}];
                            }
                            
                            NSLog(@"%@", self.topFriends);
                            [self.tableView reloadData];
                            
                        } else NSLog(@"error %@", error);
                    }];
                    
                } else {
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
            
        }
    }];
}

- (NSArray *)sortCountsKeys:(NSMutableDictionary *)counts {
    return [counts keysSortedByValueUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        } else {
            return (NSComparisonResult)NSOrderedDescending;
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.topFriends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0];
    UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)-40.0, 0.0, 40.0, cell.contentView.frame.size.height)];
    countLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0];
    countLabel.textColor = [UIColor redColor];
    [cell.contentView addSubview:countLabel];
    
    if (self.topFriends.count > 0) {
        cell.textLabel.text = [[[self.topFriends objectAtIndex:indexPath.row] allKeys] objectAtIndex:0];
        countLabel.text = [NSString stringWithFormat:@"%@", [[self.topFriends objectAtIndex:indexPath.row] objectForKey:cell.textLabel.text]];
    }
    return cell;
}

@end
