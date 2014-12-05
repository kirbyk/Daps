//
//  FriendsCollectionViewCell.m
//  Daps
//
//  Created by Austin Louden on 12/4/14.
//  Copyright (c) 2014 Macrolab. All rights reserved.
//

#import "FriendsCollectionViewCell.h"

@interface FriendsCollectionViewCell ()
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation FriendsCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.frame)-1.5, CGRectGetHeight(self.frame)-1.5)];
        self.imageView.center = self.contentView.center;
        [self.contentView addSubview:self.imageView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, CGRectGetHeight(self.frame)-22.0, CGRectGetWidth(self.frame)-5.0, 22.0)];
        self.nameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0];
        self.nameLabel.textColor = [UIColor whiteColor];
        self.nameLabel.shadowColor = [UIColor blackColor];
        self.nameLabel.shadowOffset = CGSizeMake(0, 1);
        self.nameLabel.layer.masksToBounds = NO;
        [self.contentView addSubview:self.nameLabel];
        
        
        
    }
    
    return self;
}

- (void)setName:(NSString *)name
{
    self.nameLabel.text = name;
}


@end
