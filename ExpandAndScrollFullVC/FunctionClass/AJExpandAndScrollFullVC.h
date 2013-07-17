//
//  AJExpandAndScrollFullVC.h
//  ExpandAndScrollFullVC
//
//  Created by Jianwen on 13-7-16.
//  Copyright (c) 2013年 Dark. All rights reserved.
//


#import <UIKit/UIKit.h>

#define HEIGHT_STATUS_BAR 20
#define NAV_BAR_H 44.0
#define TAB_BAR_H 49.0

#define HEIGHT_SCREEN ([[UIScreen mainScreen] bounds].size.height)
#define HEIGHT_N_NAV_N_TAB ([[UIScreen mainScreen] bounds].size.height -HEIGHT_STATUS_BAR)
#define HEIGHT_Y_NAV_Y_TAB (HEIGHT_N_NAV_N_TAB - NAV_BAR_H - TAB_BAR_H)

@protocol ExpandableAndScrollFullDelegate<NSObject>

@optional
- (UIViewController*)getPushVCByIndexPath:(NSIndexPath *)indexPath;
@end

@interface AJExpandAndScrollFullVC : UIViewController
<UITableViewDataSource, UITableViewDelegate>
{
    //expand parameters
    BOOL _expanded;
    UIImageView *_expandTopMask ;
    UIImageView *_expandBottomMask;
    
    //full scroll parameters
    float _fullFromY;
    CGFloat _prevContentOffsetY;
    
    BOOL _isScrollingTop;
    BOOL _hadFullScreen;
    
    //flag,if animation begin, not begin other animation
    BOOL _fullAnimationStarted;
}

//pop to last ViewController
-(void)popToMe;

@property(nonatomic, weak) id <ExpandableAndScrollFullDelegate>  exandAndScrollFulldelegate;
@property(nonatomic, weak) UITableView* targetTable;
@property(nonatomic, assign) BOOL supportExpand;

@end

