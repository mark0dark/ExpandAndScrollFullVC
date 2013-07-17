
#import "AJExpandAndScrollFullVC.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+Additions.h"

#define BASE_TAG 1578
#define FULL_UPPER_MASK_TAG (BASE_TAG+5)

#define EXPAND_DURATION 0.8
#define FULL_DURATION 0.3

@interface AJExpandAndScrollFullVC ()

@end

@implementation AJExpandAndScrollFullVC

#pragma mark -- Init View

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _expanded = NO;
        self.supportExpand = YES;
        
        _fullAnimationStarted = NO;
        _hadFullScreen = NO;
    }
    return self;
}

#pragma mark -- UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView != _targetTable || !self.supportExpand){return;}
    
    dispatch_block_t  ExpandCall = ^(void){
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        [self expandFromCell:cell];
        
        if(self.exandAndScrollFulldelegate && [self.exandAndScrollFulldelegate respondsToSelector:@selector(getPushVCByIndexPath:)])
        {
            UIViewController* vc = [self.exandAndScrollFulldelegate getPushVCByIndexPath:indexPath];
            
            [self.navigationController pushViewController:vc animated:NO];
        }
    };
    
    if(_hadFullScreen)
    {
        [self restoreScreen];
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (FULL_DURATION+0.1) * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ExpandCall);
    }
    else{
        ExpandCall();
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Expand About

- (void)expandFromCell:(UIView *)sourceCell
{
    if( YES == _expanded|| NO == self.supportExpand){return;}
    
    _expanded = YES;
    
    //expand frame
    float expandFromWindowY = [sourceCell convertPoint:CGPointMake(0, sourceCell.height) toView:self.view.window].y;
    
    CGRect topRect = CGRectMake(0, 0, 320, expandFromWindowY);
    CGRect bottomRect = CGRectMake(0, expandFromWindowY, 320, HEIGHT_SCREEN - expandFromWindowY);
    
    NSArray* images = [self getImagesFromView:self.view.window
                                        rects:@[NSStringFromCGRect(topRect),NSStringFromCGRect(bottomRect)]];
    
    _expandTopMask = [[UIImageView alloc] initWithFrame:topRect];
    _expandTopMask.contentMode = UIViewContentModeScaleAspectFit;
    [_expandTopMask setImage:images[0]];
    [self.view.window addSubview:_expandTopMask];
    
    _expandBottomMask = [[UIImageView alloc] initWithFrame:bottomRect];
    _expandBottomMask.contentMode = UIViewContentModeScaleAspectFit;
    [_expandBottomMask setImage:images[1]];
    [self.view.window addSubview:_expandBottomMask];
    
    [UIView animateWithDuration:EXPAND_DURATION
                     animations:^(void) {
                         _expandTopMask.bottom = 0;
                         _expandBottomMask.top = HEIGHT_SCREEN;
                     } completion:^(BOOL finished) {
                         //unlocked view
                         self.navigationController.view.userInteractionEnabled = YES;
                         self.tabBarController.view.userInteractionEnabled = YES;
                     }];
}

-(void)popToMe
{
    _expanded = NO;
    
    
    UIImage* fullMaskImage = [self getImageFromView:self.view.window rect:self.view.window.bounds];
    UIImageView *fullMaskView = [[UIImageView alloc] initWithFrame:self.view.window.bounds];
    fullMaskView.contentMode = UIViewContentModeScaleAspectFit;
    [fullMaskView setImage:fullMaskImage];
    [self.view.window insertSubview:fullMaskView belowSubview:_expandTopMask];
    
    [UIView animateWithDuration:EXPAND_DURATION
                     animations:^(void) {
                         _expandTopMask.top = 0;
                         _expandBottomMask.top = _expandTopMask.height;
                         
                     }
                     completion:^(BOOL finished){
                         
                         [self.navigationController popToViewController:self animated:NO];
                         
                         [_expandTopMask removeFromSuperview];
                         [_expandBottomMask removeFromSuperview];
                         [fullMaskView removeFromSuperview];
                     }
     ];
}

#pragma mark -- Sroll fulll

-(void)fullScreen
{
    if(_fullAnimationStarted){return;}
    
    _fullFromY = _targetTable.top;
    
    _fullAnimationStarted = YES;
    _hadFullScreen = YES;
    
    _targetTable.height = HEIGHT_N_NAV_N_TAB;
    
    UIImageView *topMaskView = [[UIImageView alloc] init];
    {
        float height = [_targetTable.superview convertPoint:_targetTable.frame.origin toView:self.view.window].y;
        CGRect rect = CGRectMake(0, 0, 320, height);
        
        topMaskView.frame = rect;
        topMaskView.contentMode = UIViewContentModeScaleAspectFit;
        [topMaskView setImage:[self getImageFromView:self.view.window rect:rect]];
        [topMaskView setTag:FULL_UPPER_MASK_TAG];
        [self.view.window addSubview:topMaskView];
    }
    
    float navBarHeight = [self getNavHeight];
    BOOL isNavBarExisting = [self isNavBarExisting];
    
    [UIView animateWithDuration:FULL_DURATION animations:^{
        
        topMaskView.top = -1*topMaskView.height+ HEIGHT_STATUS_BAR;
        
        if(isNavBarExisting)
        {
            self.navigationController.navigationBar.top -= NAV_BAR_H;
            
            _targetTable.top = -1*navBarHeight;
        }
        else
        {
            _targetTable.top = 0;
        }
        
        if([self isTabBarExisting]){
            
            UIView* tabBarTransitionView = [self.tabBarController.view.subviews objectAtIndex:0];
            tabBarTransitionView.clipsToBounds = NO;
            
            self.tabBarController.tabBar.top += TAB_BAR_H;
            
            tabBarTransitionView.height += TAB_BAR_H;
        }
    }
                     completion:^(BOOL finiish)
     {
         if(isNavBarExisting){
             _targetTable.top = 0;
             UIView* navBarTransitionView = [self.navigationController.view.subviews objectAtIndex:0];
             
             navBarTransitionView.frame = CGRectMake(0
                                                     , navBarTransitionView.top-NAV_BAR_H
                                                     , 320
                                                     , navBarTransitionView.height+NAV_BAR_H);
         }
         
         _fullAnimationStarted = NO;
     }];
    
    return;
}

-(void)restoreScreen
{
    if(_fullAnimationStarted){return;}
    
    _hadFullScreen = NO;
    _fullAnimationStarted = YES;
    
    UIView *topView = [self.view.window viewWithTag:FULL_UPPER_MASK_TAG];
    
    float navBarHeight = [self getNavHeight];
    BOOL isNavBarExisting = [self isNavBarExisting];
    
    BOOL isTabBarExisting = [self isTabBarExisting];
    
    [UIView animateWithDuration:FULL_DURATION animations:
     ^{
         topView.top = 0;
         
         
         if(isNavBarExisting){
             _targetTable.top = navBarHeight + _fullFromY;
             
             self.navigationController.navigationBar.top += NAV_BAR_H;
         }
         else
         {
             _targetTable.top = _fullFromY;
         }
         
         if(isTabBarExisting)
         {
             self.tabBarController.tabBar.top -= TAB_BAR_H;
             
             UIView* tabBarTransitionView = [self.tabBarController.view.subviews objectAtIndex:0];
             tabBarTransitionView.height -= TAB_BAR_H;
         }
         
     }completion:^(BOOL finish){
         _fullAnimationStarted = NO;
         
         [topView removeFromSuperview];
         
         if(isNavBarExisting){
             UIView* navBarTransitionView = [self.navigationController.view.subviews objectAtIndex:0];
             
             navBarTransitionView.frame = CGRectMake(0
                                                     , navBarTransitionView.top+NAV_BAR_H
                                                     , 320
                                                     , navBarTransitionView.height-NAV_BAR_H);
             
             _targetTable.top = _fullFromY;
         }
         
     }];
    
    
    return;
}

#pragma mark -- UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(scrollView != _targetTable){return;}
    
    _prevContentOffsetY = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView != _targetTable){return;}
    
    if (scrollView.dragging || _isScrollingTop)
    {
        CGFloat deltaY = scrollView.contentOffset.y-_prevContentOffsetY;
        _prevContentOffsetY = MAX(scrollView.contentOffset.y, -scrollView.contentInset.top);
                
        if(abs(deltaY)>3)
        {
            //up
            if(deltaY>0 && !_hadFullScreen)
            {
                [self fullScreen];
            }
            //down
            if(deltaY<0 && _hadFullScreen)
            {
                [self restoreScreen];
            }
        }
    }
    
    return;
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    if(scrollView != _targetTable){return NO;}
    
    _prevContentOffsetY = scrollView.contentOffset.y;
    _isScrollingTop = YES;
    return YES;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    if(scrollView != _targetTable){return;}
    
    _isScrollingTop = NO;
}


#pragma mark -- Public Function

-(UIImage*)getImageFromView:(UIView*)view rect:(CGRect)rect
{
    NSArray* images = [self getImagesFromView:view rects:@[NSStringFromCGRect(rect)]];
    return images[0];
}

-(NSArray*)getImagesFromView:(UIView*)view rects:(NSArray*)rects
{
    NSMutableArray* arr = [NSMutableArray arrayWithCapacity:rects.count];
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    
    for(int i=0;i<rects.count;i++)
    {
        CGRect rect =  CGRectFromString(rects[i]);
        CGFloat scale = [UIScreen mainScreen].scale;
        CGRect scaledRect = CGRectMake(rect.origin.x * scale, rect.origin.y*scale, rect.size.width*scale, rect.size.height*scale);
        CGImageRef partImageRef = CGImageCreateWithImageInRect([snapshot CGImage],scaledRect);
        
        UIImage* partImage = [UIImage imageWithCGImage:partImageRef];
        [arr addObject:partImage];
    }
    
    return [NSArray arrayWithArray:arr];
}

- (CGRect)scaleRect:(CGRect)rect withScale:(float) scale
{
    return CGRectMake(rect.origin.x * scale, rect.origin.y*scale, rect.size.width*scale, rect.size.height*scale);
}

-(float)getNavHeight
{
    if([self isNavBarExisting])
    {
        UINavigationBar* navBar = self.navigationController.navigationBar;
        return navBar.height;
    }
    else
    {
        return 0;
    }
}

-(BOOL)isNavBarExisting
{
    UINavigationBar* navBar = self.navigationController.navigationBar;
    return navBar && navBar.superview && !navBar.hidden;
}

-(float)getTabBarHeight
{
    if([self isTabBarExisting])
    {
        UITabBar* tabBar = self.tabBarController.tabBar;
        return tabBar.height;
    }
    else
    {
        return 0;
    }
}

-(float)isTabBarExisting
{
    UITabBar* tabBar = self.tabBarController.tabBar;
    return tabBar && tabBar.superview && !tabBar.hidden && (tabBar.left == 0);
}

@end
