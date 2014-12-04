//
//  FriendsCollectionViewCell.m
//  Daps
//
//  Created by Austin Louden on 12/4/14.
//  Copyright (c) 2014 Macrolab. All rights reserved.
//

#import "FriendsCollectionViewCell.h"

@implementation FriendsCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    //UIColor *color = [UIColor colorWithPatternImage:myPatternImage];
    UIColor *color = [UIColor redColor];
    [color set];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0.0, 0.0)];
    [path addLineToPoint:CGPointMake(0.0, 30.0)];
    [path addLineToPoint:CGPointMake(30.0, 30.0)];
    //[path addLineToPoint:p4];
    [path closePath]; // Implicitly does a line between p4 and p1
    [path fill];
    [path stroke];
}


@end
