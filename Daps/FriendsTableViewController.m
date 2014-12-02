//
//  FriendsTableViewController.m
//  Daps
//
//  Created by Kirby Kohlmorgen on 12/1/14.
//  Copyright (c) 2014 Macrolab. All rights reserved.
//

#import "FriendsTableViewController.h"
#import "UIColor+FlatUI.h"

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
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 33;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Test");
    NSInteger currentCellColorIndex = indexPath.item % self.cellColors.count;
    UIColor *currentCellColor = self.cellColors[currentCellColorIndex];
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = [@"Amy" uppercaseString];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:40.0];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.contentView.backgroundColor = currentCellColor;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.0;
}


@end
