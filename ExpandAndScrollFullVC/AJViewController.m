//
//  AJViewController.m
//  ExpandAndScrollFullVC
//
//  Created by Jianwen on 13-7-16.
//  Copyright (c) 2013年 Dark. All rights reserved.
//

#import "AJViewController.h"
#import "AJFirstViewController.h"
#import "AJSecondViewController.h"
#import "UIView+Additions.h"

#define TAB_SLIDER_TAG 2394859

@interface AJViewController ()

@end

@implementation AJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINavigationController* homeNav_0 = [[UINavigationController alloc] init];
    AJFirstViewController* homePageVC_0 = [[AJFirstViewController alloc] init];
    homePageVC_0.tabBarItem = [self createBarWithSeledImage:@"tab_home_pressed" unseledImage:@"tab_home"];
    homeNav_0.viewControllers = @[homePageVC_0];

    UINavigationController* homeNav_1 = [[UINavigationController alloc] init];
    AJSecondViewController* homePageVC_1 = [[AJSecondViewController alloc] init];
    homePageVC_1.tabBarItem = [self createBarWithSeledImage:@"tab_home_pressed" unseledImage:@"tab_home"];
    homeNav_1.viewControllers = @[homePageVC_1];

    self.viewControllers = @[homeNav_0, homeNav_1];
    
    self.delegate = self;
    self.selectedIndex = 0;
    [self addTabBarSliderAtIndex:self.selectedIndex];
}

#pragma mark -- UITabBarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    UIImageView* slider = (UIImageView*)[self.tabBar viewWithTag:TAB_SLIDER_TAG];
    
    NSUInteger selectedIndex = [self.viewControllers indexOfObjectIdenticalTo:viewController];
    if (slider)
    {
        [self.tabBar bringSubviewToFront:slider];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        CGRect frame = slider.frame;
        frame.origin.x = [self horizontalLocationFor:selectedIndex];
        slider.frame = frame;
        [UIView commitAnimations];
    }
    else
    {
        [self addTabBarSliderAtIndex:selectedIndex];
    }
}

#pragma mark -- tab bar 相关

-(UITabBarItem*)createBarWithSeledImage:(NSString*)seledImage unseledImage:(NSString*)unseledImage
{
    UITabBarItem* barItem = [[UITabBarItem alloc] init];

    barItem.titlePositionAdjustment = UIOffsetMake(0, 20.0);
    
    [barItem setFinishedSelectedImage:[UIImage imageNamed:seledImage]
          withFinishedUnselectedImage:[UIImage imageNamed:unseledImage]];

    barItem.imageInsets = UIEdgeInsetsMake(6, 0, -5, 0);
    return barItem;
}

- (void)addTabBarSliderAtIndex:(NSUInteger)itemIndex
{
    UIImage* sliderImage = [UIImage imageNamed:@"tab_slider"];
    UIImageView* slider = [[UIImageView alloc] initWithImage:sliderImage] ;
    slider.tag = TAB_SLIDER_TAG;
    
    CGFloat tabItemWidth = self.tabBar.frame.size.width / self.viewControllers.count;
    slider.frame = CGRectMake([self horizontalLocationFor:itemIndex]
                              , self.tabBar.height - sliderImage.size.height
                              , tabItemWidth
                              , sliderImage.size.height);
    
    [self.tabBar addSubview:slider];
}

- (CGFloat) horizontalLocationFor:(NSUInteger)tabIndex
{
    CGFloat tabItemWidth = self.tabBar.frame.size.width / self.viewControllers.count;
    return (tabIndex * tabItemWidth);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
