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
<
UITableViewDataSource,UITableViewDelegate
>
{
    //展开相关参数
    BOOL _expanded;
    UIImageView *_expandTopMask ;
    UIImageView *_expandBottomMask;
    
    // 滚动全屏相关参数
    float _fullFromY;
    CGFloat _prevContentOffsetY;
    
    BOOL _isScrollingTop;
    BOOL _hadFullScreen;
    
    //标志位。在动画其间不接受其它的动画请求。
    BOOL _fullAnimationStarted;
}

-(void)popToMe;

@property(nonatomic,weak)id <ExpandableAndScrollFullDelegate>  exandAndScrollFulldelegate;
@property(nonatomic,weak)UITableView* targetTable;
@property(nonatomic,assign)BOOL supportExpand;

@end

