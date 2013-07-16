//
//  AJNextLevelVC.m
//  ExpandAndScrollFullVC
//
//  Created by Jianwen on 13-7-16.
//  Copyright (c) 2013年 Dark. All rights reserved.
//

#import "AJNextLevelVC.h"

@interface AJNextLevelVC ()

@end

@implementation AJNextLevelVC

-(void)popBack
{
    UIViewController* preVC = self.navigationController.viewControllers[self.navigationController.viewControllers.count-2];
    
    if([preVC respondsToSelector:@selector(popToMe)])
    {
        [preVC performSelector:@selector(popToMe)];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blueColor];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"popBack" style:UIBarButtonItemStyleBordered target:self action:@selector(popBack)];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
