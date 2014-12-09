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

@interface ProfileViewController ()
@property (nonatomic, strong) UIImageView *mainImageView;
@property (nonatomic, strong) UILabel *mainNameLabel;
@property (nonatomic, strong) UILabel *dapsCountLabel;

@property (nonatomic, strong) NSDictionary *userData;
@end

@implementation ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBar.hidden = YES;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.frame), PROFILE_HEADER_HEIGHT)];
    headerView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:headerView];
    
    self.mainNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, CGRectGetWidth(self.view.frame), 45)];
    self.mainNameLabel.textColor = [UIColor whiteColor];
    self.mainNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:42.0];
    [headerView addSubview:self.mainNameLabel];
    
    self.dapsCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.mainNameLabel.frame)-8.0, CGRectGetWidth(self.view.frame), 45)];
    self.dapsCountLabel.textColor = [UIColor redColor];
    self.dapsCountLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:42.0];
    [headerView addSubview:self.dapsCountLabel];
    
    // setup main profile picture
    self.mainImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, PROFILE_HEADER_HEIGHT, CGRectGetWidth(self.view.frame), 180.0)];
    self.mainImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.mainImageView.clipsToBounds = YES;
    [self.view addSubview:self.mainImageView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    FBRequest *requestMe = [FBRequest requestForMe];
    [requestMe startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            
            // result is a dictionary with the user's Facebook data
            self.userData = (NSDictionary *)result;
            
            // update UI
            NSString *facebookID = self.userData[@"id"];
            NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            [self.mainImageView sd_setImageWithURL:imageURL];
            
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
                    
                    NSMutableAttributedString *attributedCount;
                    attributedCount = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", dapsCount]];
                    [attributedCount addAttribute:NSKernAttributeName value:@(-1) range:NSMakeRange(0, [attributedCount length])];
                    self.dapsCountLabel.attributedText = attributedCount;
                    
                    if(fromCounts != nil) {
                        NSArray *sortedFromCountsKeys = [self sortCountsKeys:fromCounts];
                        NSLog(@"SortedFromCounts: %@", sortedFromCountsKeys);
                    }
                    
                    if(toCounts != nil) {
                        NSArray *sortedToCountsKeys = [self sortCountsKeys:toCounts];
                        NSLog(@"SortedToCounts: %@", sortedToCountsKeys);
                    }
                } else {
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
            
        }
    }];
}

-(NSArray *)sortCountsKeys:(NSMutableDictionary *)counts {
    return [counts keysSortedByValueUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        } else {
            return (NSComparisonResult)NSOrderedDescending;
        }
    }];
}

@end
