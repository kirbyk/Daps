//
//  TopFriendsTableViewCell.m
//  Daps
//
//  Created by Austin Louden on 12/10/14.
//  Copyright (c) 2014 Macrolab. All rights reserved.
//

#import "TopFriendsTableViewCell.h"

@implementation TopFriendsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame))];
        self.nameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0];
        [self.contentView addSubview:self.nameLabel];
        
        self.countLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.contentView.frame)-40.0, 0.0, 40.0, CGRectGetHeight(self.contentView.frame))];
        self.countLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0];
        self.countLabel.textColor = [UIColor redColor];
        [self.contentView addSubview:self.countLabel];
    }
    
    return self;
}

@end
