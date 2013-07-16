//
//  AJFirstViewController.h
//  ExpandAndScrollFullVC
//
//  Created by Jianwen on 13-7-16.
//  Copyright (c) 2013年 Dark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AJExpandAndScrollFullVC.h"

@interface AJFirstViewController : AJExpandAndScrollFullVC
<ExpandableAndScrollFullDelegate>
{
    UITableView* _tableView;

}

@end
