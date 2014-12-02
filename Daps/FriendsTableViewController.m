//
//  FriendsTableViewController.m
//  Daps
//
//  Created by Kirby Kohlmorgen on 12/1/14.
//  Copyright (c) 2014 Macrolab. All rights reserved.
//

#import "FriendsTableViewController.h"
#import "UIColor+FlatUI.h"

#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>

@interface FriendsTableViewController ()

@end

@implementation FriendsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor emerlandColor];
    
    self.cellColors = @[[UIColor turquoiseColor],
                        [UIColor amethystColor],
                        [UIColor belizeHoleColor],
                        [UIColor alizarinColor],
                        [UIColor peterRiverColor],
                        [UIColor carrotColor],
                        [UIColor sunflowerColor],
                        [UIColor wisteriaColor],
                        [UIColor pomegranateColor],
                        [UIColor greenSeaColor],
                        [UIColor wetAsphaltColor]];
    
    self.friends = @[@"Alex Akagi",
                     @"Amy Conrad",
                     @"Andrew Shildmyer",
                     @"Austin Louden",
                     @"Ben Alderfer",
                     @"Evan Walsh",
                     @"Grant Gumina",
                     @"Jack Hammons",
                     @"Kurt Kroeger",
                     @"Luke Walsh",
                     @"Mason Everett",
                     @"Rachel Pereira",
                     @"Scott Opell",
                     @"Spencer Brown",
                     @"Viraj Sinha",
                     @"Zach Price"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.friends.count;
}

- (NSString *)friendNameFormatter:(NSString *)name {
    NSString *betterName = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
    betterName = [betterName uppercaseString];
    return betterName;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger currentCellColorIndex = indexPath.item % self.cellColors.count;
    UIColor *currentCellColor = self.cellColors[currentCellColorIndex];
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = [self friendNameFormatter:self.friends[indexPath.item]];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:40.0];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.contentView.backgroundColor = currentCellColor;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"Sending daps to: %@", selectedCell.textLabel.text);
    
    
    PFUser *user = [PFUser currentUser];
    NSString *fromName = [self friendNameFormatter:[user objectForKey:@"name"]];
    NSString *message = [@"👊 from " stringByAppendingString:fromName];
    
    PFPush *push = [[PFPush alloc] init];
    [push setChannel:@"global"];
    [push setMessage:message];
    [push sendPushInBackground];
}


@end
