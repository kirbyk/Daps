//
//  AppDelegate.h
//  Daps
//
//  Created by Kirby Kohlmorgen on 12/1/14.
//  Copyright (c) 2014 Macrolab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) NSArray *viewControllers;
@property (nonatomic, readwrite) int currentPage;

@end
