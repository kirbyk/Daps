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
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    
    // setup main profile picture
    self.mainImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20.0, 20.0, 80.0, 80.0)];
    self.mainImageView.layer.cornerRadius = 5.0;
    self.mainImageView.layer.masksToBounds = YES;
    [self.view addSubview:self.mainImageView];
    
    // name label
    self.mainNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.mainImageView.frame) + 20.0, CGRectGetMinY(self.mainImageView.frame) + 10.0, CGRectGetWidth(self.view.frame) - CGRectGetMaxX(self.mainImageView.frame) - 20, 30.0)];
    self.mainNameLabel.textColor = [UIColor colorWithWhite:(25.0f/255.0f) alpha:1.0];
    self.mainNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:24.0];
    [self.view addSubview:self.mainNameLabel];
    
    // daps count label
    self.dapsCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.mainNameLabel.frame), CGRectGetMaxY(self.mainNameLabel.frame), CGRectGetWidth(self.view.frame), 20.0)];
    self.dapsCountLabel.textColor = [UIColor colorWithWhite:(65.0f/255.0f) alpha:1.0];
    self.dapsCountLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0];
    [self.view addSubview:self.dapsCountLabel];
    
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
            
            NSMutableAttributedString *attributedCount;
            attributedCount = [[NSMutableAttributedString alloc] initWithString:@"107 daps from 45 friends"];
            [attributedCount addAttribute:NSKernAttributeName value:@(-1) range:NSMakeRange(0, [attributedCount length])];
            self.dapsCountLabel.attributedText = attributedCount;
            
            PFQuery *query = [PFQuery queryWithClassName:@"Daps"];
            [query whereKey:@"facebookId" equalTo:facebookID];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    NSMutableDictionary *fromCounts = [objects[0] objectForKey:@"fromCounts"];
                    NSMutableDictionary *toCounts = [objects[0] objectForKey:@"toCounts"];
                    
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
