//
//  CustomNavViewController.m
//  UTASnaps
//
//  Created by James Fielder on 6/8/14.
//  Copyright (c) 2014 com.mobi. All rights reserved.
//

#import "CustomNavViewController.h"

@interface CustomNavViewController ()

@end

@implementation CustomNavViewController

- (id)initWithRootViewController:(UIViewController *)rootViewController andTabBarName: (NSString *)tabBarName{
    self = [super initWithRootViewController:rootViewController];
    if(self){
        
        NSDictionary *titleTextAttr =@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0f],
                                       NSForegroundColorAttributeName : [UIColor lightGrayColor]};
        
        NSDictionary *selectedTextAttr =@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0f],
                                          NSForegroundColorAttributeName : [UIColor whiteColor]};
        
        self.tabBarItem.title = tabBarName;
        
        [self.tabBarItem setTitleTextAttributes:titleTextAttr forState:UIControlStateNormal];
        [self.tabBarItem setTitleTextAttributes:selectedTextAttr forState:UIControlStateSelected];
        
        UIColor *navColor = [UIColor colorWithRed:1.0 green:204.0/255 blue:0.0 alpha:1.0];
        [self.navigationBar setBarTintColor:navColor];
       [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        
        [self.navigationBar setTintColor:[UIColor whiteColor]];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
