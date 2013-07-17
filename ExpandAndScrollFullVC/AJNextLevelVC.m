
#import "AJNextLevelVC.h"

@interface AJNextLevelVC ()

@end

@implementation AJNextLevelVC

#pragma mark -- Button Clicked Even

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

#pragma mark -- Init View Frame

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blueColor];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"popBack" style:UIBarButtonItemStyleBordered target:self action:@selector(popBack)];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
}

#pragma mark -- Memory

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
